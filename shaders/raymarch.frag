in vec3 v_rayOrigin;
in vec3 v_rayDirection;

uniform sampler2D heightmapTexture;

out vec4 frag_color;

const int MAX_STEPS = 128;
const float MAX_DIST = 100.0;
const float EPSILON = 0.001;
const float MIN_STEP = 0.01;

// Convert world coordinates to UV coordinates
vec2 worldToUV(vec2 p) {
    const float TERRAIN_SIZE = 10.0;
    return (p + vec2(TERRAIN_SIZE * 0.5)) / TERRAIN_SIZE;
}

// Get height at a point using the heightmap texture
float getTerrainHeight(vec2 p) {
    vec2 uv = worldToUV(p);
    
    // Clamp UV coordinates to valid range
    uv = clamp(uv, 0.0, 1.0);
    
    // Sample heightmap
    float height = texture(heightmapTexture, uv).r;
    return (height - 0.5) * 2.0;  // Convert from 0-1 to -1 to 1 range
}

// Get terrain distance - includes slope in distance estimation
float getTerrainDistance(vec3 p) {
    float height = getTerrainHeight(p.xz);
    float dy = p.y - height;
    
    // Estimate local slope for better distance estimation
    vec2 e = vec2(0.01, 0.0);
    float dx = getTerrainHeight(p.xz + e.xy) - getTerrainHeight(p.xz - e.xy);
    float dz = getTerrainHeight(p.xz + e.yx) - getTerrainHeight(p.xz - e.yx);
    
    vec3 normal = normalize(vec3(dx, 2.0 * e.x, dz));
    return dy / normal.y;  // Adjust distance based on slope
}

// Raymarch the terrain with adaptive stepping
float raymarchTerrain(vec3 ro, vec3 rd) {
    float t = 0.0;
    float prevD = 1e10;  // Large initial value
    
    for(int i = 0; i < MAX_STEPS; i++) {
        vec3 p = ro + rd * t;
        float d = getTerrainDistance(p);
        
        // Hit terrain
        if(d < EPSILON) {
            // Binary search refinement
            float tMin = t - max(d, MIN_STEP);
            float tMax = t;
            
            // Refine hit point
            for(int j = 0; j < 4; j++) {
                float tMid = 0.5 * (tMin + tMax);
                p = ro + rd * tMid;
                d = getTerrainDistance(p);
                if(d < 0.0) tMax = tMid;
                else tMin = tMid;
            }
            return 0.5 * (tMin + tMax);
        }
        
        // Adaptive step size with safety checks
        float stepScale = 0.5;  // Conservative step scale
        if (d > prevD) stepScale = 0.25;  // Even more conservative when distance increases
        
        float stepSize = max(d * stepScale, MIN_STEP);
        
        // Prevent overshooting
        float maxStepSize = (MAX_DIST - t) * 0.5;
        stepSize = min(stepSize, maxStepSize);
        
        t += stepSize;
        prevD = d;
        
        // Too far, abort
        if(t > MAX_DIST) break;
    }
    
    return -1.0;
}

// Calculate normal using central differences
vec3 calcNormal(vec3 p) {
    vec2 e = vec2(EPSILON, 0.0);
    vec3 n = vec3(
        getTerrainHeight(p.xz + e.xy) - getTerrainHeight(p.xz - e.xy),
        2.0 * e.x,
        getTerrainHeight(p.xz + e.yx) - getTerrainHeight(p.xz - e.yx)
    );
    return normalize(n);
}

void main() {
    // Raymarch from camera
    float t = raymarchTerrain(v_rayOrigin, v_rayDirection);
    
    if(t < 0.0) {
        // Ray missed, show sky with gradient
        float skyGradient = max(0.0, v_rayDirection.y);
        vec3 skyColor = mix(
            vec3(0.5, 0.7, 1.0),  // Horizon color
            vec3(0.2, 0.4, 0.8),  // Zenith color
            skyGradient
        );
        frag_color = vec4(skyColor, 1.0);
        return;
    }
    
    // Hit point
    vec3 p = v_rayOrigin + v_rayDirection * t;
    
    // Calculate normal
    vec3 n = calcNormal(p);
    
    // Lighting parameters
    vec3 lightDir = normalize(vec3(1.0, 1.0, 0.0));
    vec3 viewDir = -v_rayDirection;
    
    // Calculate lighting
    float diff = max(dot(n, lightDir), 0.0);
    
    // Height-based coloring
    float height = getTerrainHeight(p.xz);
    vec3 color = mix(
        vec3(0.2, 0.5, 0.2),  // Green for low areas
        vec3(0.8, 0.8, 0.8),  // Gray for high areas
        smoothstep(-0.5, 0.5, height)
    );
    
    // Apply lighting
    float ambient = 0.2;
    vec3 finalColor = color * (ambient + diff);
    
    // Apply fog
    float fogAmount = 1.0 - exp(-t * 0.03);
    vec3 fogColor = vec3(0.7, 0.8, 0.9);
    finalColor = mix(finalColor, fogColor, fogAmount);
    
    frag_color = vec4(finalColor, 1.0);
} 