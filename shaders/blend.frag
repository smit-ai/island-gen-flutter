in vec2 v_texcoord;

uniform sampler2D baseTexture;   // Base heightmap
uniform sampler2D blendTexture;  // Layer to blend

uniform BlendParams {
    float blendMode;  // 0=Min, 1=Max, 2=Add, 3=Subtract
    float influence;  // Layer influence (0-1)
};

out vec4 frag_color;

float blendAdd(float base, float blend) {
    return clamp(base + blend, 0.0, 1.0);  // Direct addition with clamping to valid range
}

float blendSubtract(float base, float blend) {
    return max(base - blend, 0.0);
}

float blendMin(float base, float blend) {
    return min(base, blend);
}

float blendMax(float base, float blend) {
    return max(base, blend);
}

void main() {
    vec4 baseColor = texture(baseTexture, v_texcoord);
    vec4 blendColor = texture(blendTexture, v_texcoord);
    
    // Extract heightmap values (using red channel)
    float baseHeight = baseColor.r;
    float blendHeight = blendColor.r;
    float result;
    
    // Apply blend mode
    int mode = int(blendMode);
    switch(mode) {
        case 0:  // Min
            result = blendMin(baseHeight, blendHeight);
            break;
        case 1:  // Max
            result = blendMax(baseHeight, blendHeight);
            break;
        case 2:  // Add
            result = blendAdd(baseHeight, blendHeight);
            break;
        case 3:  // Subtract
            result = blendSubtract(baseHeight, blendHeight);
            break;
        default:  // Fallback to Add
            result = blendAdd(baseHeight, blendHeight);
    }
    
    // Apply influence
    result = mix(baseHeight, result, influence);
    
    // Output grayscale heightmap
    frag_color = vec4(vec3(result), 1.0);
} 