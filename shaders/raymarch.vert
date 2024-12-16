in vec2 position;  // Full-screen quad positions

uniform Transforms {
    mat4 modelViewProjection;
    mat4 modelMatrix;
    vec4 cameraPosition;
};

out vec3 v_rayOrigin;
out vec3 v_rayDirection;

void main() {
    // Pass through the position for full-screen quad
    gl_Position = vec4(position, 0.0, 1.0);
    
    // Calculate ray origin and direction for this pixel
    v_rayOrigin = cameraPosition.xyz;
    
    // Transform screen position to world space
    vec4 farPoint = inverse(modelViewProjection) * vec4(position, 1.0, 1.0);
    farPoint.xyz /= farPoint.w;
    
    // Calculate ray direction
    v_rayDirection = normalize(farPoint.xyz - v_rayOrigin);
} 