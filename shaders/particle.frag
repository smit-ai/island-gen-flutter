// Input from vertex shader
struct VertexOutput {
  float4 position : SV_POSITION;
  float4 color : COLOR;
  float2 texCoord : TEXCOORD0;
};

@fragment float4 fragmentShader(VertexOutput input) {
  // Calculate distance from center (0.5, 0.5)
  float2 center = input.texCoord - float2(0.5, 0.5);
  float dist = length(center);
  
  // Create a soft circular particle
  float alpha = smoothstep(0.5, 0.4, dist);
  
  return float4(input.color.rgb, input.color.a * alpha);
}
