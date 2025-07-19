// Input from vertex shader
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

@fragment float4 fragmentShader(VertexOutput input) {
  // Base color from input
  float4 baseColor = input.color;
  
  // Ambient light
  float3 ambient = transforms.ambientStrength * transforms.lightColor.xyz;
  
  // Diffuse light
  float3 lightDir = normalize(transforms.lightPosition.xyz - input.worldPos);
  float diff = max(dot(input.normal, lightDir), 0.0);
  float3 diffuse = diff * transforms.lightColor.xyz;
  
  // Specular light (Blinn-Phong)
  float3 viewDir = normalize(transforms.lightPosition.xyz - input.worldPos);
  float3 halfDir = normalize(lightDir + viewDir);
  float spec = pow(max(dot(input.normal, halfDir), 0.0), 32.0);
  float3 specular = transforms.specularStrength * spec * transforms.lightColor.xyz;
  
  // Final lighting calculation
  float3 finalColor = (ambient + diffuse) * baseColor.xyz + specular;
  
  return float4(finalColor, baseColor.a);
}
