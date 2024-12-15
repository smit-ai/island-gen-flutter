in vec2 v_texcoord;

uniform NoiseParams {
    float scale;
    float octaves;
    float persistence;
    float seed;
    float baseFrequency;
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

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 1.0;
    float octaveFreq = 1.0;
    float total_amplitude = 0.0;
    
    int num_octaves = int(octaves);
    
    for (int i = 0; i < num_octaves; i++) {
        value += amplitude * valueNoise(p * octaveFreq * baseFrequency + seed);
        total_amplitude += amplitude;
        amplitude *= persistence;
        octaveFreq *= 2.0;
    }
    
    return value / total_amplitude;
}

void main() {
    vec2 uv = v_texcoord / scale;
    float noise = fbm(uv);
    frag_color = vec4(vec3(noise), 1.0);
}
