// Input vertex data
struct VertexInput {
  float3 position : POSITION;
  float3 normal : NORMAL;
  float2 texCoord : TEXCOORD0;
  float4 color : COLOR;
  float4x4 modelMatrix : MATRIX0;
};

// Output vertex data to fragment shader
struct VertexOutput {
  float4 position : SV_POSITION;
  float3 worldPos : TEXCOORD0;
  float3 normal : TEXCOORD1;
  float2 texCoord : TEXCOORD2;
  float4 color : COLOR;
};

// Uniform buffer for transformations
struct Transforms {
  float4x4 viewProj;
  float4 lightPosition;
  float4 lightColor;
  float ambientStrength;
  float specularStrength;
};

@uniform Transforms transforms;

@vertex VertexOutput vertexShader(VertexInput input) {
  VertexOutput output;
  
  // Apply model transform to get world position
  float4 worldPos = mul(input.modelMatrix, float4(input.position, 1.0));
  
  // Apply view-projection transform to get clip space position
  output.position = mul(transforms.viewProj, worldPos);
  
  // Pass world position to fragment shader
  output.worldPos = worldPos.xyz;
  
  // Transform normal to world space
  output.normal = normalize(mul(float3x3(input.modelMatrix), input.normal));
  
  // Pass texture coordinates and color
  output.texCoord = input.texCoord;
  output.color = input.color;
  
  return output;
}
