in vec3 v_rayOrigin;
in vec3 v_rayDirection;

uniform sampler2D heightmapTexture;

out vec4 frag_color;

const int MAX_STEPS = 128;
const float MAX_DIST = 100.0;
const float EPSILON = 0.001;
const float MIN_STEP = 0.01;

// Material IDs
const int MAT_SKY = 0;
const int MAT_TERRAIN = 1;
const int MAT_CHECKER = 2;

// Convert world coordinates to UV coordinates
vec2 worldToUV(vec2 p) {
    const float TERRAIN_SIZE = 10.0;
    return (p + vec2(TERRAIN_SIZE * 0.5)) / TERRAIN_SIZE;
}

// Get height at a point using the heightmap texture
float getTerrainHeight(vec2 p) {
    vec2 uv = worldToUV(p);
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        return 0.0;
    }
    float height = texture(heightmapTexture, uv).r;
    return height * 2.0; // Scale height to 0-2 range
}

// Get checkerboard pattern
float getCheckerboard(vec2 p) {
    const float CHECKER_SCALE = 1.0;
    vec2 grid = floor(p * CHECKER_SCALE);
    return mod(grid.x + grid.y, 2.0);
}

// Intersect ray with terrain
float intersectTerrain(vec3 ro, vec3 rd, out bool hit) {
    hit = false;
    float t = 0.0;
    
    // Only process if ray points downward
    if (rd.y > 0.0 && ro.y > 2.0) return MAX_DIST;
    
    for(int i = 0; i < MAX_STEPS && t < MAX_DIST; i++) {
        vec3 p = ro + rd * t;
        float h = getTerrainHeight(p.xz);
        float dh = p.y - h;
        
        if (dh < EPSILON && h > 0.0) {
            hit = true;
            return t;
        }
        
        t += max(dh * 0.5, MIN_STEP);
    }
    return MAX_DIST;
}

// Intersect ray with plane at y=0
float intersectPlane(vec3 ro, vec3 rd, out bool hit) {
    hit = false;
    if (abs(rd.y) < EPSILON) return MAX_DIST;
    
    float t = -ro.y / rd.y;
    hit = t > 0.0;
    return hit ? t : MAX_DIST;
}

// Calculate terrain normal
vec3 calcTerrainNormal(vec3 p) {
    vec2 e = vec2(EPSILON, 0.0);
    float h = getTerrainHeight(p.xz);
    vec3 n = vec3(
        getTerrainHeight(p.xz + e.xy) - getTerrainHeight(p.xz - e.xy),
        2.0 * e.x,
        getTerrainHeight(p.xz + e.yx) - getTerrainHeight(p.xz - e.yx)
    );
    return normalize(n);
}

void main() {
    // Check plane intersection first
    bool hitPlane;
    float planeDist = intersectPlane(v_rayOrigin, v_rayDirection, hitPlane);
    
    // Check terrain intersection
    bool hitTerrain;
    float terrainDist = intersectTerrain(v_rayOrigin, v_rayDirection, hitTerrain);
    
    // Determine which surface was hit
    float t;
    int material;
    if (!hitPlane && !hitTerrain) {
        // Hit nothing - show sky
        float skyGradient = max(0.0, v_rayDirection.y);
        vec3 skyColor = mix(
            vec3(0.5, 0.7, 1.0),
            vec3(0.2, 0.4, 0.8),
            skyGradient
        );
        frag_color = vec4(skyColor, 1.0);
        return;
    }
    
    if (hitTerrain && (!hitPlane || terrainDist < planeDist)) {
        // Hit terrain
        t = terrainDist;
        material = MAT_TERRAIN;
    } else {
        // Hit plane
        t = planeDist;
        material = MAT_CHECKER;
    }
    
    // Calculate hit point and normal
    vec3 p = v_rayOrigin + v_rayDirection * t;
    vec3 n = (material == MAT_TERRAIN) ? calcTerrainNormal(p) : vec3(0.0, 1.0, 0.0);
    
    // Calculate lighting
    vec3 lightDir = normalize(vec3(1.0, 1.0, 0.0));
    float diff = max(dot(n, lightDir), 0.0);
    
    // Get material color
    vec3 color;
    if (material == MAT_TERRAIN) {
        float height = getTerrainHeight(p.xz);
        color = mix(
            vec3(0.2, 0.5, 0.2),  // Green for low areas
            vec3(0.8, 0.8, 0.8),  // Gray for high areas
            smoothstep(0.0, 2.0, height)
        );
    } else {
        float checker = getCheckerboard(p.xz);
        color = mix(vec3(0.2), vec3(0.8), checker);
    }
    
    // Apply lighting
    float ambient = 0.2;
    vec3 finalColor = color * (ambient + diff);
    
    // Apply fog
    float fogAmount = 1.0 - exp(-t * 0.03);
    vec3 fogColor = vec3(0.7, 0.8, 0.9);
    finalColor = mix(finalColor, fogColor, fogAmount);
    
    frag_color = vec4(finalColor, 1.0);
} 