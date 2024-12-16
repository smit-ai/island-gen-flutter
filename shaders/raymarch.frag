in vec3 v_rayOrigin;
in vec3 v_rayDirection;

uniform Transforms {
    mat4 modelViewProjection;
    mat4 modelMatrix;
    vec4 cameraPosition;
};

out vec4 frag_color;

const int MAX_STEPS = 100;
const float MAX_DIST = 100.0;
const float EPSILON = 0.001;

// Get height at a point (temporary simple function)
float getTerrainHeight(vec2 p) {
    // Simple sine wave terrain for testing
    return sin(p.x) * cos(p.y) * 0.5;
}

// Raymarch the terrain
float raymarchTerrain(vec3 ro, vec3 rd) {
    float t = 0.0;
    
    for(int i = 0; i < MAX_STEPS; i++) {
        vec3 p = ro + rd * t;
        float h = getTerrainHeight(p.xz);
        float d = p.y - h;
        
        // Hit terrain
        if(d < EPSILON) {
            return t;
        }
        
        // Safe distance to march
        t += d * 0.5;
        
        // Too far, abort
        if(t > MAX_DIST) {
            break;
        }
    }
    
    return -1.0;
}

// Calculate normal at a point
vec3 calcNormal(vec3 p) {
    vec2 e = vec2(EPSILON, 0.0);
    float h = getTerrainHeight(p.xz);
    vec3 n = vec3(
        getTerrainHeight(p.xz + e.xy) - h,
        e.x,
        getTerrainHeight(p.xz + e.yx) - h
    );
    return normalize(n);
}

void main() {
    // Raymarch from camera
    float t = raymarchTerrain(v_rayOrigin, v_rayDirection);
    
    if(t < 0.0) {
        // Ray missed, show sky
        frag_color = vec4(0.5, 0.7, 1.0, 1.0);
        return;
    }
    
    // Hit point
    vec3 p = v_rayOrigin + v_rayDirection * t;
    
    // Calculate normal
    vec3 n = calcNormal(p);
    
    // Simple lighting
    vec3 lightDir = normalize(vec3(1.0, 1.0, 0.0));
    float diff = max(dot(n, lightDir), 0.0);
    
    // Height-based coloring
    float height = getTerrainHeight(p.xz);
    vec3 color = mix(
        vec3(0.2, 0.5, 0.2),  // Green for low areas
        vec3(0.8, 0.8, 0.8),  // Gray for high areas
        smoothstep(-0.5, 0.5, height)
    );
    
    // Apply lighting
    color *= mix(0.3, 1.0, diff);  // Ambient + diffuse
    
    frag_color = vec4(color, 1.0);
} 