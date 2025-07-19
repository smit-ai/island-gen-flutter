struct VertexOutput {
  float4 position : SV_POSITION;
  float2 texCoord : TEXCOORD0;
};

@texture(0) sampler2D positionTexture;
@texture(1) sampler2D velocityTexture;
@texture(2) sampler2D bodyPropsTexture;  // mass, restitution, etc.

@fragment float4 fragmentShader(VertexOutput input) {
  // Read current velocity
  float4 velocity = texture(velocityTexture, input.texCoord);
  float4 position = texture(positionTexture, input.texCoord);
  float4 bodyProps = texture(bodyPropsTexture, input.texCoord);
  
  // Extract properties
  float restitution = bodyProps.y;
  
  // Simple ground collision detection (at y=0)
  if (position.y < 0.0) {
    velocity.y = abs(velocity.y) * restitution;
    position.y = 0.0;
  }
  
  // Return updated velocity after collision response
  return velocity;
}
