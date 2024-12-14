in vec2 v_texcoord;

uniform sampler2D baseTexture;   // Base heightmap
uniform sampler2D blendTexture;  // Layer to blend

uniform BlendParams {
    float blendMode;  // 0=Add, 1=Subtract, 2=Min, 3=Max
    float opacity;
};

out vec4 frag_color;

float blendAdd(float base, float blend) {
    return min(base + blend, 1.0);
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
        case 0:  // Add
            result = blendAdd(baseHeight, blendHeight);
            break;
        case 1:  // Subtract
            result = blendSubtract(baseHeight, blendHeight);
            break;
        case 2:  // Min
            result = blendMin(baseHeight, blendHeight);
            break;
        case 3:  // Max
            result = blendMax(baseHeight, blendHeight);
            break;
        default:  // Fallback to Add
            result = blendAdd(baseHeight, blendHeight);
    }
    
    // Apply opacity
    result = mix(baseHeight, result, opacity);
    
    // Output grayscale heightmap
    frag_color = vec4(vec3(result), 1.0);
} 