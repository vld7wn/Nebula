"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.verifyEmailOtp = exports.sendEmailOtp = void 0;
const https_1 = require("firebase-functions/v2/https");
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
const nodemailer = __importStar(require("nodemailer"));
const params_1 = require("firebase-functions/params");
(0, app_1.initializeApp)();
const db = (0, firestore_1.getFirestore)();
// Параметры для email
const smtpHost = (0, params_1.defineString)("SMTP_HOST", { default: "" });
const smtpPort = (0, params_1.defineString)("SMTP_PORT", { default: "587" });
const smtpUser = (0, params_1.defineString)("SMTP_USER", { default: "" });
const smtpPass = (0, params_1.defineString)("SMTP_PASS", { default: "" });
const fromEmail = (0, params_1.defineString)("FROM_EMAIL", { default: "noreply@nebula.app" });
/**
 * Генерация 6-значного кода
 */
function generateOtpCode() {
    return Math.floor(100000 + Math.random() * 900000).toString();
}
/**
 * Отправка OTP кода на email
 */
exports.sendEmailOtp = (0, https_1.onCall)(async (request) => {
    const email = request.data.email?.toLowerCase()?.trim();
    if (!email || !email.includes("@")) {
        throw new https_1.HttpsError("invalid-argument", "Некорректный email");
    }
    // Генерируем код
    const code = generateOtpCode();
    const now = firestore_1.Timestamp.now();
    const expiresAt = firestore_1.Timestamp.fromMillis(now.toMillis() + 5 * 60 * 1000); // 5 минут
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
        }
        catch (error) {
            console.error("Email error:", error);
            throw new https_1.HttpsError("internal", "Ошибка отправки email");
        }
    }
    else {
        // Для разработки — логируем код в консоль
        console.log(`[DEV] OTP code for ${email}: ${code}`);
    }
    return { success: true, message: "Код отправлен" };
});
/**
 * Проверка OTP кода
 */
exports.verifyEmailOtp = (0, https_1.onCall)(async (request) => {
    const email = request.data.email?.toLowerCase()?.trim();
    const code = request.data.code?.trim();
    if (!email || !code) {
        throw new https_1.HttpsError("invalid-argument", "Email и код обязательны");
    }
    const docRef = db.collection("email_verifications").doc(email);
    const doc = await docRef.get();
    if (!doc.exists) {
        throw new https_1.HttpsError("not-found", "Код не найден. Запросите новый.");
    }
    const docData = doc.data();
    const now = firestore_1.Timestamp.now();
    // Проверяем срок действия
    if (docData.expiresAt.toMillis() < now.toMillis()) {
        await docRef.delete();
        throw new https_1.HttpsError("deadline-exceeded", "Код истёк. Запросите новый.");
    }
    // Проверяем количество попыток
    if (docData.attempts >= 5) {
        await docRef.delete();
        throw new https_1.HttpsError("resource-exhausted", "Слишком много попыток. Запросите новый код.");
    }
    // Проверяем код
    if (docData.code !== code) {
        await docRef.update({
            attempts: firestore_1.FieldValue.increment(1),
        });
        throw new https_1.HttpsError("permission-denied", "Неверный код");
    }
    // Успех — удаляем документ
    await docRef.delete();
    return { verified: true, email: email };
});
//# sourceMappingURL=index.js.map