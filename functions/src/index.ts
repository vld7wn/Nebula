import { onCall, HttpsError } from "firebase-functions/v2/https";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, Timestamp, FieldValue } from "firebase-admin/firestore";
import * as nodemailer from "nodemailer";
import { defineString } from "firebase-functions/params";

initializeApp();
const db = getFirestore();

// Параметры для email
const smtpHost = defineString("SMTP_HOST", { default: "" });
const smtpPort = defineString("SMTP_PORT", { default: "587" });
const smtpUser = defineString("SMTP_USER", { default: "" });
const smtpPass = defineString("SMTP_PASS", { default: "" });
const fromEmail = defineString("FROM_EMAIL", { default: "noreply@nebula.app" });

/**
 * Генерация 6-значного кода
 */
function generateOtpCode(): string {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

/**
 * Отправка OTP кода на email
 */
export const sendEmailOtp = onCall(async (request) => {
  const email = request.data.email?.toLowerCase()?.trim();

  if (!email || !email.includes("@")) {
    throw new HttpsError("invalid-argument", "Некорректный email");
  }

  // Генерируем код
  const code = generateOtpCode();
  const now = Timestamp.now();
  const expiresAt = Timestamp.fromMillis(now.toMillis() + 5 * 60 * 1000); // 5 минут

  // Сохраняем в Firestore
  await db.collection("email_verifications").doc(email).set({
    email: email,
    code: code,
    createdAt: now,
    expiresAt: expiresAt,
    attempts: 0,
  });

  // Отправляем email через Nodemailer если настроено
  const host = smtpHost.value();
  if (host) {
    try {
      const transporter = nodemailer.createTransport({
        host: host,
        port: parseInt(smtpPort.value()),
        secure: false,
        auth: {
          user: smtpUser.value(),
          pass: smtpPass.value(),
        },
      });

      await transporter.sendMail({
        from: fromEmail.value(),
        to: email,
        subject: "Код подтверждения Nebula",
        text: `Ваш код подтверждения: ${code}\n\nКод действителен 5 минут.`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 400px; margin: 0 auto; padding: 20px;">
            <h2 style="color: #6B46C1;">Nebula Messenger</h2>
            <p>Ваш код подтверждения:</p>
            <div style="background: #1a1a2e; color: white; padding: 20px; border-radius: 10px; text-align: center; font-size: 32px; letter-spacing: 8px; font-weight: bold;">
              ${code}
            </div>
            <p style="color: #666; font-size: 12px; margin-top: 20px;">
              Код действителен 5 минут. Если вы не запрашивали этот код, проигнорируйте это письмо.
            </p>
          </div>
        `,
      });
    } catch (error) {
      console.error("Email error:", error);
      throw new HttpsError("internal", "Ошибка отправки email");
    }
  } else {
    // Для разработки — логируем код в консоль
    console.log(`[DEV] OTP code for ${email}: ${code}`);
  }

  return { success: true, message: "Код отправлен" };
});

/**
 * Проверка OTP кода
 */
export const verifyEmailOtp = onCall(async (request) => {
  const email = request.data.email?.toLowerCase()?.trim();
  const code = request.data.code?.trim();

  if (!email || !code) {
    throw new HttpsError("invalid-argument", "Email и код обязательны");
  }

  const docRef = db.collection("email_verifications").doc(email);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new HttpsError("not-found", "Код не найден. Запросите новый.");
  }

  const docData = doc.data()!;
  const now = Timestamp.now();

  // Проверяем срок действия
  if (docData.expiresAt.toMillis() < now.toMillis()) {
    await docRef.delete();
    throw new HttpsError("deadline-exceeded", "Код истёк. Запросите новый.");
  }

  // Проверяем количество попыток
  if (docData.attempts >= 5) {
    await docRef.delete();
    throw new HttpsError(
      "resource-exhausted",
      "Слишком много попыток. Запросите новый код."
    );
  }

  // Проверяем код
  if (docData.code !== code) {
    await docRef.update({
      attempts: FieldValue.increment(1),
    });
    throw new HttpsError("permission-denied", "Неверный код");
  }

  // Успех — удаляем документ
  await docRef.delete();

  return { verified: true, email: email };
});
