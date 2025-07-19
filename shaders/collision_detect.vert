struct VertexOutput {
  float4 position : SV_POSITION;
  float2 texCoord : TEXCOORD0;
};

@vertex VertexOutput vertexShader(float2 position : POSITION) {
  VertexOutput output;
  output.position = float4(position, 0.0, 1.0);
  output.texCoord = position * 0.5 + 0.5;
  return output;
}
