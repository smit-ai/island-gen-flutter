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
const float EPSILON = 0.0001;
const float MIN_STEP = 0.001;
const int REFINEMENT_STEPS = 6;

// Material IDs
const int MAT_SKY = 0;
const int MAT_TERRAIN = 1;
const int MAT_CHECKER = 2;
const int MAT_CUTOFF = 3;
vec2 worldToUV(vec2 p) {
    const float TERRAIN_SIZE = 10.0;
    vec2 uv = (p + vec2(TERRAIN_SIZE * 0.5)) / TERRAIN_SIZE;
    return clamp(uv, 0.0, 1.0);
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
    if (isnan(h00)) h00 = 0.0; // Fallback for invalid samples
    float h10 = texture(heightmapTexture, uv10).r;
    if (isnan(h10)) h10 = 0.0; // Fallback for invalid samples
    float h01 = texture(heightmapTexture, uv01).r;
    if (isnan(h01)) h01 = 0.0; // Fallback for invalid samples
    float h11 = texture(heightmapTexture, uv11).r;
    if (isnan(h11)) h11 = 0.0; // Fallback for invalid samples

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


float getTerrainSDF(vec3 p, out int materialID) {
    const float BOUNDS = 5.0; // Half-size of the terrain bounds
    float terrainHeight = getSmoothHeight(clamp(p.xz, -BOUNDS, BOUNDS)); // Clamp p.xz within bounds

    // Check if we're at the terrain edges
    bool onEdge = (abs(p.x) >= BOUNDS - 0.005 || abs(p.z) >= BOUNDS - 0.005);

    if (onEdge) {
        // Sides capped at the terrain height
        float wallHeight = terrainHeight;
        float sideSDF = max(abs(p.y) - wallHeight, max(abs(p.x) - BOUNDS, abs(p.z) - BOUNDS));
        materialID = MAT_CUTOFF; // Sides material
        return sideSDF;
    }

    // Default terrain surface
    materialID = MAT_TERRAIN;
    return p.y - terrainHeight;
}





vec3 calcTerrainNormal(vec3 p) {
    vec2 e = vec2(EPSILON, 0.0);
    float h = getSmoothHeight(p.xz);
    float hx = getSmoothHeight(p.xz + e.xy) - getSmoothHeight(p.xz - e.xy);
    float hz = getSmoothHeight(p.xz + e.yx) - getSmoothHeight(p.xz - e.yx);
    vec3 n = vec3(hx, 2.0 * e.x, hz);
    return normalize(n);
}

vec3 calcSideNormal(vec3 p) {
    const float BOUNDS = 5.0;

    // Check which boundary we're near and point the normal outward
    if (abs(p.x) >= BOUNDS - 0.005) {
        return normalize(vec3(sign(p.x), 0.0, 0.0)); // Normal points along X
    }
    if (abs(p.z) >= BOUNDS - 0.005) {
        return normalize(vec3(0.0, 0.0, sign(p.z))); // Normal points along Z
    }

    return vec3(0.0, 1.0, 0.0); // Fallback (should not happen)
}




float refineIntersection(vec3 ro, vec3 rd, float tMin, float tMax) {
    int tempMaterialID;
    for (int i = 0; i < REFINEMENT_STEPS; i++) {
        float tMid = 0.5 * (tMin + tMax);
        float dMid = getTerrainSDF(ro + rd * tMid, tempMaterialID);
        if (dMid > 0.0) {
            tMin = tMid;
        } else {
            tMax = tMid;
        }
    }
    return 0.5 * (tMin + tMax);
}

float intersectTerrain(vec3 ro, vec3 rd, out bool hit, out int materialID) {
    hit = false;
    materialID = MAT_SKY;

    float t = 0.0;
    float tPrev = 0.0;
    float sdfPrev;
    int tempMaterialID;

    sdfPrev = getTerrainSDF(ro, tempMaterialID);

    for (int i = 0; i < MAX_STEPS; i++) {
        if (t > MAX_DIST) break;

        vec3 p = ro + rd * t;
        float sdf = getTerrainSDF(p, tempMaterialID);

        if (abs(sdf) < EPSILON) {
            hit = true;
            materialID = tempMaterialID;
            return t;
        }

        // Check for sign change
        if (sdf < 0.0 && sdfPrev > 0.0) {
            hit = true;
            materialID = tempMaterialID;
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
    int materialID;
    float terrainDist = intersectTerrain(v_rayOrigin, v_rayDirection, hitTerrain, materialID);

    float t;
    int material = MAT_SKY;

    if (!hitPlane && !hitTerrain) {
        float skyGradient = max(0.0, v_rayDirection.y);
        vec3 skyColor = mix(vec3(0.5, 0.7, 1.0), vec3(0.2, 0.4, 0.8), skyGradient);
        frag_color = vec4(skyColor, 1.0);
        return;
    }

    if (hitTerrain && hitPlane) {
        if (terrainDist < planeDist) {
            t = terrainDist;
            material = materialID;
        } else {
            t = planeDist;
            material = MAT_CHECKER;
        }
    } else if (hitTerrain) {
        t = terrainDist;
        material = materialID;
    } else {
        t = planeDist;
        material = MAT_CHECKER;
    }

    vec3 p = v_rayOrigin + v_rayDirection * t;
    vec3 n;

    if (material == MAT_TERRAIN) {
        n = calcTerrainNormal(p);
    } else if (material == MAT_CUTOFF) { // Side material
        n = calcSideNormal(p);
    } else {
        n = vec3(0.0, 1.0, 0.0); // Default upward normal for ground plane
    }


    vec3 lightDir = normalize(vec3(1.0, 1.0, 0.0));
    float diff = max(dot(n, lightDir), 0.0);

    vec3 color;

    if (material == MAT_TERRAIN) {
        float height = getSmoothHeight(p.xz);
        color = mix(vec3(0.2, 0.5, 0.2), vec3(0.8, 0.8, 0.8), smoothstep(0.0, 2.0, height));
    } else if (material == MAT_CUTOFF) {
        color = vec3(0.4, 0.3, 0.2); // Brown for terrain sides
    } else if (material == MAT_CHECKER) {
        float checker = getCheckerboard(p.xz);
        color = mix(vec3(0.2), vec3(0.8), checker);
    } else {
        color = vec3(0.5, 0.7, 1.0);
    }

    float ambient = 0.2;
    vec3 finalColor = color * (ambient + diff);

    float fogAmount = 1.0 - exp(-t * 0.03);
    vec3 fogColor = vec3(0.7, 0.8, 0.9);
    finalColor = mix(finalColor, fogColor, fogAmount);

    frag_color = vec4(finalColor, 1.0);
}
