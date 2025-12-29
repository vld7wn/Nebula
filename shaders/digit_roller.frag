#version 460 core

#include <flutter/runtime_effect.glsl>

// Параметры
uniform vec2 uResolution;      // Размер
uniform float uTime;           // Время анимации
uniform float uDigit;          // Целевая цифра (0-9)
uniform float uProgress;       // Прогресс анимации (0-1)
uniform float uIsRevealed;     // 1 = цифра открыта

out vec4 fragColor;

// Константы
const float PI = 3.14159265359;
const vec3 digitColor = vec3(1.0, 1.0, 1.0);
const vec3 bgColor = vec3(0.1, 0.08, 0.15);
const vec3 glowColor = vec3(0.6, 0.4, 1.0);

// Функция для рисования цифры
float sdDigit(vec2 uv, float digit) {
    // Сегментный дисплей
    // 7-сегментная логика
    float d = floor(mod(digit, 10.0));
    
    vec2 p = uv * 2.0 - 1.0;
    p.x *= 0.6;
    
    float seg = 0.0;
    float w = 0.15;  // Ширина сегмента
    float h = 0.08;  // Высота сегмента
    
    // Горизонтальные сегменты (a, g, d)
    // a - верхний
    if (d == 0.0 || d == 2.0 || d == 3.0 || d == 5.0 || d == 6.0 || d == 7.0 || d == 8.0 || d == 9.0) {
        seg += smoothstep(h, 0.0, abs(p.y - 0.7)) * smoothstep(w + 0.1, w, abs(p.x));
    }
    // g - средний
    if (d == 2.0 || d == 3.0 || d == 4.0 || d == 5.0 || d == 6.0 || d == 8.0 || d == 9.0) {
        seg += smoothstep(h, 0.0, abs(p.y)) * smoothstep(w + 0.1, w, abs(p.x));
    }
    // d - нижний
    if (d == 0.0 || d == 2.0 || d == 3.0 || d == 5.0 || d == 6.0 || d == 8.0 || d == 9.0) {
        seg += smoothstep(h, 0.0, abs(p.y + 0.7)) * smoothstep(w + 0.1, w, abs(p.x));
    }
    
    // Вертикальные сегменты (b, c, e, f)
    // b - правый верхний
    if (d == 0.0 || d == 1.0 || d == 2.0 || d == 3.0 || d == 4.0 || d == 7.0 || d == 8.0 || d == 9.0) {
        seg += smoothstep(h, 0.0, abs(p.x - 0.25)) * smoothstep(w + 0.2, w, abs(p.y - 0.35));
    }
    // c - правый нижний
    if (d == 0.0 || d == 1.0 || d == 3.0 || d == 4.0 || d == 5.0 || d == 6.0 || d == 7.0 || d == 8.0 || d == 9.0) {
        seg += smoothstep(h, 0.0, abs(p.x - 0.25)) * smoothstep(w + 0.2, w, abs(p.y + 0.35));
    }
    // e - левый нижний
    if (d == 0.0 || d == 2.0 || d == 6.0 || d == 8.0) {
        seg += smoothstep(h, 0.0, abs(p.x + 0.25)) * smoothstep(w + 0.2, w, abs(p.y + 0.35));
    }
    // f - левый верхний
    if (d == 0.0 || d == 4.0 || d == 5.0 || d == 6.0 || d == 8.0 || d == 9.0) {
        seg += smoothstep(h, 0.0, abs(p.x + 0.25)) * smoothstep(w + 0.2, w, abs(p.y - 0.35));
    }
    
    return clamp(seg, 0.0, 1.0);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    
    // Анимация прокрутки
    float scrollSpeed = 8.0;
    float currentDigit;
    
    if (uIsRevealed > 0.5) {
        // Цифра открыта - показываем финальное значение
        currentDigit = uDigit;
    } else {
        // Прокрутка цифр
        float scrollOffset = uTime * scrollSpeed;
        
        // Замедление к концу
        float easing = 1.0 - pow(1.0 - uProgress, 3.0);
        
        // Интерполяция к целевой цифре
        currentDigit = mod(scrollOffset + uDigit * easing, 10.0);
        
        if (uProgress > 0.9) {
            currentDigit = mix(currentDigit, uDigit, (uProgress - 0.9) * 10.0);
        }
    }
    
    // Рисуем цифру
    float digit = sdDigit(uv, floor(currentDigit));
    
    // Glow эффект
    float glow = digit * 0.5;
    
    // Смешиваем
    vec3 color = bgColor;
    color = mix(color, glowColor * 0.3, glow);
    color = mix(color, digitColor, digit * 0.9);
    
    // Блюр при прокрутке (motion blur эффект)
    if (uIsRevealed < 0.5 && uProgress < 0.8) {
        float blur = (1.0 - uProgress) * 0.3;
        color = mix(color, glowColor * 0.5, blur);
    }
    
    fragColor = vec4(color, 1.0);
}
