// Input vertex data
struct VertexInput {
  float2 position : POSITION;
  float3 particlePos : INSTANCE_POSITION;
  float4 particleColor : INSTANCE_COLOR;
  float particleSize : INSTANCE_SIZE;
};

// Output vertex data to fragment shader
struct VertexOutput {
  float4 position : SV_POSITION;
  float4 color : COLOR;
  float2 texCoord : TEXCOORD0;
};

// Uniform buffer for transformations
struct Transforms {
  float4x4 viewProj;
};

@uniform Transforms transforms;

@vertex VertexOutput vertexShader(VertexInput input) {
  VertexOutput output;
  
  // Calculate world position of the particle quad vertex
  float3 worldPos = input.particlePos + float3(input.position * input.particleSize, 0.0);
  
  // Transform to clip space
  output.position = mul(transforms.viewProj, float4(worldPos, 1.0));
  
  // Pass color to fragment shader
  output.color = input.particleColor;
  
  // Generate texture coordinates from vertex position
  output.texCoord = input.position * 0.5 + 0.5;
  
  return output;
}
