#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uTime;
uniform float uPullStrength; // 0.0 = нормально, 1.0 = максимальное засасывание

out vec4 fragColor;

// Шум для добавления глубины
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uResolution;
    
    vec2 center = vec2(0.5, 0.5);
    float aspect = uResolution.x / uResolution.y;
    
    vec2 p = uv - center;
    p.x *= aspect;
    
    float dist = length(p);
    float angle = atan(p.y, p.x);
    
    // === ЦВЕТА ===
    vec3 haiti = vec3(27.0, 9.0, 39.0) / 255.0;
    vec3 valentino = vec3(44.0, 14.0, 58.0) / 255.0;
    vec3 grape = vec3(63.0, 23.0, 85.0) / 255.0;
    vec3 honeyFlower = vec3(84.0, 31.0, 104.0) / 255.0;
    vec3 wineBerry = vec3(88.0, 22.0, 82.0) / 255.0;
    vec3 eminence = vec3(102.0, 42.0, 131.0) / 255.0;
    vec3 plum = vec3(125.0, 40.0, 119.0) / 255.0;
    vec3 vividViolet = vec3(132.0, 55.0, 167.0) / 255.0;
    vec3 trendyPink = vec3(142.0, 95.0, 158.0) / 255.0;
    
    // Фон с градиентом глубины (тёмнее)
    vec3 color = mix(valentino, haiti, smoothstep(0.1, 0.6, dist));
    
    // Добавляем шумовую текстуру для глубины
    float noiseValue = noise(uv * 8.0 + uTime * 0.1);
    color += haiti * noiseValue * 0.1;
    
    // === ЦЕНТР ЧЁРНОЙ ДЫРЫ ===
    float core = smoothstep(0.05, 0.01, dist);
    color *= (1.0 - core);
    
    // Пульсирующее свечение ядра (яркие цвета как на референсе)
    float pulse = 0.8 + 0.2 * sin(uTime * 2.0);
    float glow = 0.025 / (dist + 0.06);
    glow *= smoothstep(0.0, 0.1, dist);
    glow *= pulse;
    color += mix(trendyPink, vividViolet, sin(uTime) * 0.5 + 0.5) * glow * 0.7;
    
    // === СПИРАЛЬНЫЕ ЛИНИИ ===
    // Скорость вращения увеличивается при pullStrength
    float rotationSpeed = 0.3 + uPullStrength * 2.0;
    float spiralAngle = angle + uTime * rotationSpeed;
    float spiralBase = spiralAngle - log(dist + 0.01) * 2.5;
    
    float totalLines = 0.0;
    
    // 5 основных спиральных линий
    for (int i = 0; i < 5; i++) {
        float offset = float(i) * 6.2832 / 5.0;
        float spiral = spiralBase + offset;
        
        // Линии расширяются от центра к краю
        float lineWidth = mix(12.0, 2.0, dist / 0.5);
        float line = sin(spiral) * 0.5 + 0.5;
        line = pow(line, lineWidth);
        
        // Пульсация каждой линии
        float linePulse = 0.85 + 0.15 * sin(uTime * 1.5 + float(i) * 1.2);
        line *= linePulse;
        
        totalLines += line;
    }
    
    // Вторичные тонкие спирали для глубины
    for (int i = 0; i < 5; i++) {
        float offset = float(i) * 6.2832 / 5.0 + 0.5;
        float spiral = spiralBase * 1.5 + offset;
        
        float line = sin(spiral) * 0.5 + 0.5;
        line = pow(line, 10.0);
        
        totalLines += line * 0.3;
    }
    
    totalLines *= smoothstep(0.03, 0.1, dist);
    totalLines *= smoothstep(0.6, 0.12, dist);
    
    // Градиент цвета спиралей: 4 ступени (яркие → тёмные)
    float t = smoothstep(0.06, 0.55, dist);
    vec3 spiralColor1 = mix(trendyPink, plum, 0.3);
    vec3 spiralColor2 = mix(plum, eminence, 0.5);
    vec3 spiralColor3 = mix(eminence, honeyFlower, 0.5);
    vec3 spiralColor4 = mix(honeyFlower, valentino, 0.6);
    
    vec3 spiralColor;
    if (t < 0.33) {
        spiralColor = mix(spiralColor1, spiralColor2, t * 3.0);
    } else if (t < 0.66) {
        spiralColor = mix(spiralColor2, spiralColor3, (t - 0.33) * 3.0);
    } else {
        spiralColor = mix(spiralColor3, spiralColor4, (t - 0.66) * 3.0);
    }
    
    color += spiralColor * totalLines * 0.55;
    
    // === ТЁМНЫЕ МЕСТА МЕЖДУ СПИРАЛЯМИ ===
    float darkAreas = 0.0;
    for (int i = 0; i < 5; i++) {
        float offset = float(i) * 6.2832 / 5.0 + 3.14159 / 5.0;
        float spiral = spiralBase + offset;
        
        float dark = sin(spiral) * 0.5 + 0.5;
        dark = pow(dark, 3.0);
        darkAreas += dark;
    }
    darkAreas = clamp(darkAreas / 5.0, 0.0, 1.0);
    darkAreas *= smoothstep(0.05, 0.15, dist);
    darkAreas *= smoothstep(0.55, 0.2, dist);
    
    // Затемняем области между спиралями цветом haiti
    color = mix(color, haiti, darkAreas * (1.0 - totalLines * 0.5) * 0.7);
    
    // Свечение между спиралями (пульсирующее)
    float bgGlow = smoothstep(0.5, 0.08, dist) * 0.12;
    bgGlow *= 0.9 + 0.1 * sin(uTime * 0.8 + dist * 10.0);
    color += mix(grape, honeyFlower, 0.3) * bgGlow * (1.0 - totalLines * 0.3);
    
    // Внешнее кольцо свечения
    float outerRing = smoothstep(0.55, 0.45, dist) * smoothstep(0.35, 0.45, dist);
    color += eminence * outerRing * 0.08;
    
    // === ЗВЁЗДЫ (смещаются к центру по спирали) ===
    float stars = 0.0;
    for (int i = 0; i < 30; i++) {
        float fi = float(i);
        float baseAngle = hash(vec2(fi, fi * 0.7)) * 6.2832;
        float baseDist = hash(vec2(fi * 1.3, fi * 0.3)) * 0.5 + 0.15;
        
        // Прогресс засасывания (ускоряется при pullStrength)
        float pullSpeed = 0.05 + uPullStrength * 0.3;
        float pull = fract(uTime * pullSpeed + hash(vec2(fi, 0.0)));
        
        // Расстояние уменьшается (ближе к центру при pullStrength)
        float targetDist = mix(0.02, 0.0, uPullStrength);
        float starDist = mix(baseDist, targetDist, pull);
        
        // Угол вращается по спирали (в другую сторону)
        float spiralRotation = -pull * 4.0; // Минус = обратное вращение
        float starAngle = baseAngle + spiralRotation;
        
        // Позиция звезды
        vec2 starPos = vec2(cos(starAngle), sin(starAngle)) * starDist;
        starPos.x /= aspect;
        
        float d = length(p / vec2(aspect, 1.0) - starPos);
        
        // Размер звезды: БОЛЬШИЕ по краям, маленькие к центру
        float starSize = mix(0.005, 0.001, pull);
        float star = smoothstep(starSize, 0.0, d);
        
        // Яркость: ЯРКИЕ по краям, тусклые к центру
        float brightness = mix(1.0, 0.2, pull);
        star *= brightness;
        
        // Затухание при приближении к центру
        star *= smoothstep(0.02, 0.08, starDist);
        
        // Мерцание
        star *= 0.7 + 0.3 * sin(uTime * 3.0 + fi * 5.0);
        
        stars += star;
    }
    
    // Белые звёзды
    color += vec3(1.0, 0.98, 0.95) * stars * 0.8;
    
    fragColor = vec4(color, 1.0);
}
