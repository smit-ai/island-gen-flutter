struct VertexOutput {
  float4 position : SV_POSITION;
  float2 texCoord : TEXCOORD0;
};

struct PhysicsParams {
  float deltaTime;
  float gravity;
  int numBodies;
};

@uniform PhysicsParams params;
@texture(0) sampler2D positionTexture;
@texture(1) sampler2D velocityTexture;
@texture(2) sampler2D forceTexture;
@texture(3) sampler2D bodyPropsTexture;  // mass, restitution, etc.

@fragment float4 fragmentShader(VertexOutput input) {
  // Read current position, velocity, and force
  float4 position = texture(positionTexture, input.texCoord);
  float4 velocity = texture(velocityTexture, input.texCoord);
  float4 force = texture(forceTexture, input.texCoord);
  float4 bodyProps = texture(bodyPropsTexture, input.texCoord);
  
  // Extract properties
  float mass = bodyProps.x;
  float invMass = (mass > 0.0) ? 1.0 / mass : 0.0;
  bool isStatic = (bodyProps.w > 0.5);
  
  // Skip if static
  if (isStatic) {
    return position;
  }
  
  // Apply gravity
  force.y += params.gravity * mass;
  
  // Update velocity
  velocity.xyz += force.xyz * invMass * params.deltaTime;
  
  // Update position
  position.xyz += velocity.xyz * params.deltaTime;
  
  // Return updated position
  return position;
}
