#version 460 core
precision highp float;

in vec3 v_rayOrigin;
in vec3 v_rayDirection;

uniform sampler2D heightmapTexture;
uniform TextureParams {
    int textureSize;   // texture size
};

out vec4 frag_color;

const int MAX_STEPS = 256;
const float MAX_DIST = 100.0;
const float EPSILON = 0.001;
const float MIN_STEP = 0.001;
const int REFINEMENT_STEPS = 6;

// Material IDs
const int MAT_SKY = 0;
const int MAT_TERRAIN = 1;
const int MAT_CHECKER = 2;

vec2 worldToUV(vec2 p) {
    const float TERRAIN_SIZE = 10.0;
    return (p + vec2(TERRAIN_SIZE * 0.5)) / TERRAIN_SIZE;
}


float getSmoothHeight(vec2 p) {
    vec2 uv = worldToUV(p);
    uv = clamp(uv, 0.0, 1.0);

    ivec2 texSize = ivec2(textureSize, textureSize);
    vec2 fTexSize = vec2(texSize);
    vec2 texCoord = uv * fTexSize - vec2(0.5, 0.5);
    vec2 iuv = floor(texCoord);
    vec2 fuv = fract(texCoord);

    vec2 uv00 = (iuv + vec2(0.5, 0.5)) / fTexSize;
    vec2 uv10 = (iuv + vec2(1.5, 0.5)) / fTexSize;
    vec2 uv01 = (iuv + vec2(0.5, 1.5)) / fTexSize;
    vec2 uv11 = (iuv + vec2(1.5, 1.5)) / fTexSize;
    
    float h00 = texture(heightmapTexture, uv00).r;
    float h10 = texture(heightmapTexture, uv10).r;
    float h01 = texture(heightmapTexture, uv01).r;
    float h11 = texture(heightmapTexture, uv11).r;

    float h0 = mix(h00, h10, fuv.x);
    float h1 = mix(h01, h11, fuv.x);
    float h = mix(h0, h1, fuv.y);
    return h * 2.0;
}

float getCheckerboard(vec2 p) {
    const float CHECKER_SCALE = 1.0;
    vec2 grid = floor(p * CHECKER_SCALE);
    return mod(grid.x + grid.y, 2.0);
}

float getTerrainSDF(vec3 p) {
    float h = getSmoothHeight(p.xz);
    return p.y - h;
}

vec3 calcTerrainNormal(vec3 p) {
    vec2 e = vec2(EPSILON, 0.0);
    float h = getSmoothHeight(p.xz);
    float hx = getSmoothHeight(p.xz + e.xy) - getSmoothHeight(p.xz - e.xy);
    float hz = getSmoothHeight(p.xz + e.yx) - getSmoothHeight(p.xz - e.yx);
    vec3 n = vec3(hx, 2.0 * e.x, hz);
    return normalize(n);
}

float refineIntersection(vec3 ro, vec3 rd, float tMin, float tMax) {
    for (int i = 0; i < REFINEMENT_STEPS; i++) {
        float tMid = 0.5 * (tMin + tMax);
        float dMid = getTerrainSDF(ro + rd * tMid);
        if (dMid > 0.0) {
            tMin = tMid;
        } else {
            tMax = tMid;
        }
    }
    return 0.5 * (tMin + tMax);
}

float intersectTerrain(vec3 ro, vec3 rd, out bool hit) {
    hit = false;
    if (rd.y > 0.0 && ro.y > 2.0) return MAX_DIST;

    float t = 0.0;
    float tPrev = 0.0;
    float sdfPrev = getTerrainSDF(ro);

    for (int i = 0; i < MAX_STEPS; i++) {
        if (t > MAX_DIST) break;
        
        vec3 p = ro + rd * t;
        float sdf = getTerrainSDF(p);

        if (abs(sdf) < EPSILON) {
            hit = true;
            return t;
        }

        // Check for sign change
        if (sdf < 0.0 && sdfPrev > 0.0) {
            hit = true;
            return refineIntersection(ro, rd, tPrev, t);
        }

        vec3 n = calcTerrainNormal(p);
        float stepSize = sdf * clamp(n.y, 0.25, 1.0);
        stepSize = max(stepSize, MIN_STEP);

        tPrev = t;
        sdfPrev = sdf;
        t += stepSize;
    }

    return MAX_DIST;
}

float intersectPlane(vec3 ro, vec3 rd, out bool hit) {
    hit = false;
    if (abs(rd.y) < EPSILON) return MAX_DIST;
    float t = -ro.y / rd.y;
    hit = (t > 0.0);
    return hit ? t : MAX_DIST;
}

void main() {
    bool hitPlane;
    float planeDist = intersectPlane(v_rayOrigin, v_rayDirection, hitPlane);

    bool hitTerrain;
    float terrainDist = intersectTerrain(v_rayOrigin, v_rayDirection, hitTerrain);

    // Decide which intersection to use
    float t;
    int material = MAT_SKY;

    if (!hitPlane && !hitTerrain) {
        // Hit nothing, sky
        float skyGradient = max(0.0, v_rayDirection.y);
        vec3 skyColor = mix(
            vec3(0.5, 0.7, 1.0),
            vec3(0.2, 0.4, 0.8),
            skyGradient
        );
        frag_color = vec4(skyColor, 1.0);
        return;
    }

    if (hitTerrain && hitPlane) {
        // If distances are very close, prefer the plane to avoid artifacts
        float epsilonCompare = 0.01; // Adjust as needed
        if (terrainDist < planeDist - epsilonCompare) {
            t = terrainDist;
            material = MAT_TERRAIN;
        } else {
            t = planeDist;
            material = MAT_CHECKER;
        }
    } else if (hitTerrain) {
        t = terrainDist;
        material = MAT_TERRAIN;
    } else {
        t = planeDist;
        material = MAT_CHECKER;
    }

    vec3 p = v_rayOrigin + v_rayDirection * t;
    vec3 n = (material == MAT_TERRAIN) ? calcTerrainNormal(p) : vec3(0.0, 1.0, 0.0);

    // Simple lighting
    vec3 lightDir = normalize(vec3(1.0, 1.0, 0.0));
    float diff = max(dot(n, lightDir), 0.0);

    vec3 color;
    if (material == MAT_TERRAIN) {
        float height = getSmoothHeight(p.xz);
        color = mix(
            vec3(0.2, 0.5, 0.2),  // Green low
            vec3(0.8, 0.8, 0.8),  // Gray high
            smoothstep(0.0, 2.0, height)
        );
    } else if (material == MAT_CHECKER) {
        float checker = getCheckerboard(p.xz);
        color = mix(vec3(0.2), vec3(0.8), checker);
    } else {
        // Just in case
        color = vec3(0.5, 0.7, 1.0);
    }

    float ambient = 0.2;
    vec3 finalColor = color * (ambient + diff);

    // Fog
    float fogAmount = 1.0 - exp(-t * 0.03);
    vec3 fogColor = vec3(0.7, 0.8, 0.9);
    finalColor = mix(finalColor, fogColor, fogAmount);

    frag_color = vec4(finalColor, 1.0);
}