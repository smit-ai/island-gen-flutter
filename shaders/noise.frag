#version 320 es

precision highp float;

uniform vec2 uResolution;
uniform float uFrequency;
uniform float uPersistence;
uniform float uLacunarity;
uniform float uOctaves;
uniform float uSeed;
uniform float uNoiseType;

layout(location = 0) out vec4 fragColor;

// Hash function for random number generation
vec2 hash(vec2 p) {
    p = vec2(dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)));
    return -1.0 + 2.0 * fract(sin(p + uSeed) * 43758.5453123);
}

// Gradient noise (Perlin)
float gradientNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(dot(hash(i + vec2(0.0,0.0)), f - vec2(0.0,0.0)),
            dot(hash(i + vec2(1.0,0.0)), f - vec2(1.0,0.0)), u.x),
        mix(dot(hash(i + vec2(0.0,1.0)), f - vec2(0.0,1.0)),
            dot(hash(i + vec2(1.0,1.0)), f - vec2(1.0,1.0)), u.x),
        u.y
    );
}

// Simplex noise
float simplexNoise(vec2 p) {
    const float K1 = 0.366025404; // (sqrt(3)-1)/2
    const float K2 = 0.211324865; // (3-sqrt(3))/6

    vec2 i = floor(p + (p.x + p.y) * K1);
    vec2 a = p - i + (i.x + i.y) * K2;
    vec2 o = (a.x > a.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec2 b = a - o + K2;
    vec2 c = a - 1.0 + 2.0 * K2;

    vec3 h = max(0.5 - vec3(dot(a,a), dot(b,b), dot(c,c)), 0.0);
    vec3 n = h * h * h * h * vec3(
        dot(a, hash(i + 0.0)),
        dot(b, hash(i + o)),
        dot(c, hash(i + 1.0))
    );

    return dot(n, vec3(70.0));
}

// Voronoi noise
float voronoiNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float minDist = 1.0;
    
    for(int y = -1; y <= 1; y++) {
        for(int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = hash(i + neighbor);
            point = 0.5 + 0.5 * sin(uSeed + 6.2831 * point);
            vec2 diff = neighbor + point - f;
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    
    return minDist;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 1.0;
    float frequency = 1.0;
    float maxValue = 0.0;
    
    const int MAX_OCTAVES = 8;
    for(int i = 0; i < MAX_OCTAVES; i++) {
        if (float(i) >= uOctaves) break;
        
        float noiseValue;
        vec2 q = p * frequency;
        
        if (uNoiseType < 0.5) {
            noiseValue = gradientNoise(q);
        } else if (uNoiseType < 1.5) {
            noiseValue = simplexNoise(q);
        } else {
            noiseValue = voronoiNoise(q);
        }
        
        value += amplitude * noiseValue;
        maxValue += amplitude;
        amplitude *= uPersistence;
        frequency *= uLacunarity;
    }
    
    return value / maxValue;
}

void main() {
    vec2 pos = gl_FragCoord.xy / uResolution.xy;
    pos *= uFrequency;
    
    float noise = fbm(pos);
    noise = 0.5 + 0.5 * noise; // normalize to [0,1]
    
    fragColor = vec4(vec3(noise), 1.0);
} 