// Input from vertex shader
struct VertexOutput {
  float4 position : SV_POSITION;
  float3 worldPos : TEXCOORD0;
  float3 normal : TEXCOORD1;
  float2 texCoord : TEXCOORD2;
  float4 color : COLOR;
};

@fragment float4 fragmentShader(VertexOutput input) {
  return input.color;
}
