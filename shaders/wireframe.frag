in vec3 v_normal;
in vec3 v_position;
in vec2 v_texcoord;

uniform Transforms {
    mat4 modelViewProjection;
    mat4 modelMatrix;
    vec4 lightPosition;
    vec4 lightColor;
    vec4 lightParams;     // ambientStrength in x, specularStrength in y, gridSize in z, mode in w
};

out vec4 frag_color;

void main() {
    // Use black for solid mode, white for wireframe mode
    if (lightParams.w > 0.5) {
        frag_color = vec4(1.0, 1.0, 1.0, 0.8); // White for wireframe mode
    } else {
        frag_color = vec4(0.0, 0.0, 0.0, 0.8); // Black for solid mode
    }
} 