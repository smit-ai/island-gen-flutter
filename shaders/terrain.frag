in vec3 v_normal;
in vec3 v_position;  // This is in view space
in vec2 v_texcoord;  // This is world space UV (x=0to1 along X axis, y=0to1 along Z axis)

uniform Transforms {
    mat4 modelViewProjection;
    mat4 modelMatrix;    // This is actually modelView matrix now
    vec4 lightPosition;    // Light position in view space
    vec4 lightColor;
    vec4 lightParams;     // ambientStrength in x, specularStrength in y, gridSize in z
};

out vec4 frag_color;

vec3 getTerrainColor(vec2 uv, float height) {
    // Get grid size from uniform (passed in lightParams.z)
    float gridSize = lightParams.z;
    
    // Transform UVs to world grid coordinates
    vec2 worldGrid = uv * (gridSize - 1.0);
    vec2 checker = floor(worldGrid);
    float pattern = mod(checker.x + checker.y, 2.0);
    
    // Define colors for the checkerboard
    vec3 color1 = vec3(0.7, 0.7, 0.7); // Light gray
    vec3 color2 = vec3(0.4, 0.4, 0.4); // Darker gray
    
    // Simple checkerboard pattern without height-based coloring
    return mix(color1, color2, pattern);
}

void main() {
    // Normalize the interpolated normal
    vec3 normal = normalize(v_normal);
    
    // Transform position back to world space for height
    vec4 worldPos = inverse(modelMatrix) * vec4(v_position, 1.0);
    float worldHeight = worldPos.y;
    
    // Get terrain color using world-space coordinates
    vec3 baseColor = getTerrainColor(v_texcoord, worldHeight);
    
    // View direction in view space (camera is at origin)
    vec3 viewDir = normalize(-v_position);
    
    // Calculate ambient light
    float ambientStrength = lightParams.x;
    vec3 ambient = ambientStrength * lightColor.xyz;
    
    // Calculate diffuse light with softer falloff
    vec3 lightDir = normalize(lightPosition.xyz - v_position);
    float NdotL = max(dot(normal, lightDir), 0.0);
    float diffuseFalloff = smoothstep(0.0, 1.0, NdotL);
    vec3 diffuse = diffuseFalloff * lightColor.xyz;
    
    // Calculate specular light with roughness-based shininess
    vec3 halfwayDir = normalize(lightDir + viewDir);
    float NdotH = max(dot(normal, halfwayDir), 0.0);
    float specularStrength = lightParams.y;
    float shininess = mix(64.0, 4.0, baseColor.g); // Vary shininess based on terrain type
    float spec = pow(NdotH, shininess);
    vec3 specular = specularStrength * spec * lightColor.xyz;
    
    // Apply distance-based attenuation
    float distance = length(lightPosition.xyz - v_position);
    float attenuation = 1.0 / (1.0 + 0.1 * distance + 0.01 * distance * distance);
    
    // Combine all lighting components with physically-based mixing
    vec3 result = (ambient + (diffuse + specular) * attenuation) * baseColor;
    
    // Apply gamma correction
    result = pow(result, vec3(1.0/2.2));
    
    frag_color = vec4(result, 1.0);
} 