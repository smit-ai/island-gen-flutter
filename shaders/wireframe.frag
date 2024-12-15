in vec3 v_normal;
in vec3 v_position;
in vec2 v_texcoord;

uniform Transforms {
    mat4 modelViewProjection;
    mat4 modelMatrix;
    vec4 lightPosition;
    vec4 lightColor;
    vec4 lightParams;
};

out vec4 frag_color;

void main() {
    // Output solid blue color for wireframe lines
    frag_color = vec4(0.0, 0.0, 1.0, 1.0);
} 