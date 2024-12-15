in vec2 v_texcoord;

uniform NoiseParams {
    float scale;
    float octaves;
    float persistence;
    float seed;
    float baseFrequency;
    float offsetX;
    float offsetY;
    float rotation;
    float invert;  // 0 = normal, 1 = inverted
    float clampMin;
    float clampMax;
};

out vec4 frag_color;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float valueNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x),
             mix(c, d, u.x), u.y);
}

vec2 rotate2D(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    mat2 rotationMatrix = mat2(c, -s, s, c);
    return rotationMatrix * p;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 1.0;
    float octaveFreq = 1.0;
    float total_amplitude = 0.0;
    
    int num_octaves = int(octaves);
    
    // Apply rotation and offset to the base coordinates
    // Convert degrees (0-360) to radians (0-2π)
    float rotationRadians = rotation * 3.14159265359 / 180.0;
    p = rotate2D(p, rotationRadians);
    
    // Scale offsets to be less sensitive (divide by 10 to make movement more gradual)
    p += vec2(offsetX, offsetY) * 0.1;
    
    for (int i = 0; i < num_octaves; i++) {
        value += amplitude * valueNoise(p * octaveFreq * baseFrequency + seed);
        total_amplitude += amplitude;
        amplitude *= persistence;
        octaveFreq *= 2.0;
    }
    
    // Normalize and apply inversion if needed
    float normalizedValue = value / total_amplitude;
    if (invert > 0.5) {
        normalizedValue = 1.0 - normalizedValue;
    }
    
    // Apply clamping
    if (normalizedValue < clampMin) {
        normalizedValue = 0.0;
    } else if (normalizedValue > clampMax) {
        normalizedValue = 1.0;
    } else {
        // Remap the value between clampMin and clampMax to 0-1
        normalizedValue = (normalizedValue - clampMin) / (clampMax - clampMin);
    }
    
    return normalizedValue;
}

void main() {
    vec2 uv = v_texcoord / scale;
    float noise = fbm(uv);
    frag_color = vec4(vec3(noise), 1.0);
}
