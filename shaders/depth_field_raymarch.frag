// Input from vertex shader (full-screen quad)
struct VertexOutput {
  float4 position : SV_POSITION;
  float2 texCoord : TEXCOORD0;
  float3 rayOrigin : TEXCOORD1;
  float3 rayDir : TEXCOORD2;
};

// Scene data buffer
struct SceneData {
  int numSpheres;
  int numBoxes;
  float4x4 invViewProj;
  float3 cameraPos;
};

// Sphere data
struct Sphere {
  float3 position;
  float radius;
  float4 color;
};

// Box data
struct Box {
  float3 position;
  float3 dimensions;
  float4x4 rotation;
  float4 color;
};

@uniform SceneData scene;
@storage Spheres {
  Sphere spheres[];
};
@storage Boxes {
  Box boxes[];
};

#define MAX_STEPS 128
#define MAX_DIST 100.0
#define SURF_DIST 0.01

// Signed distance function for a sphere
float sphereSDF(float3 p, float3 center, float radius) {
  return length(p - center) - radius;
}

// Signed distance function for a box
float boxSDF(float3 p, float3 pos, float3 dimensions, float4x4 rot) {
  // Rotate point
  float3 q = mul(float3x3(rot), p - pos);
  // Box SDF
  float3 d = abs(q) - dimensions * 0.5;
  return length(max(d, 0.0)) + min(max(d.x, max(d.y, d.z)), 0.0);
}

// Combined scene SDF
float sceneSDF(float3 p, out float4 color) {
  float minDist = MAX_DIST;
  color = float4(0.5, 0.5, 0.5, 1.0); // Default color
  
  // Check all spheres
  for (int i = 0; i < scene.numSpheres; i++) {
    float dist = sphereSDF(p, spheres[i].position, spheres[i].radius);
    if (dist < minDist) {
      minDist = dist;
      color = spheres[i].color;
    }
  }
  
  // Check all boxes
  for (int i = 0; i < scene.numBoxes; i++) {
    float dist = boxSDF(p, boxes[i].position, boxes[i].dimensions, boxes[i].rotation);
    if (dist < minDist) {
      minDist = dist;
      color = boxes[i].color;
    }
  }
  
  // Ground plane
  float groundDist = p.y + 1.0;
  if (groundDist < minDist) {
    minDist = groundDist;
    // Checkerboard pattern for ground
    float check = fmod(floor(p.x) + floor(p.z), 2.0);
    color = check < 0.5 ? float4(0.3, 0.3, 0.3, 1.0) : float4(0.7, 0.7, 0.7, 1.0);
  }
  
  return minDist;
}

// Calculate normal using SDF gradient
float3 getNormal(float3 p) {
  float4 dummy;
  float2 e = float2(0.01, 0.0);
  
  return normalize(float3(
    sceneSDF(p + e.xyy, dummy) - sceneSDF(p - e.xyy, dummy),
    sceneSDF(p + e.yxy, dummy) - sceneSDF(p - e.yxy, dummy),
    sceneSDF(p + e.yyx, dummy) - sceneSDF(p - e.yyx, dummy)
  ));
}

// Ray marching function
float4 raymarch(float3 ro, float3 rd) {
  float dist = 0.0;
  float4 color;
  
  for (int i = 0; i < MAX_STEPS; i++) {
    float3 p = ro + rd * dist;
    float4 objColor;
    float ds = sceneSDF(p, objColor);
    
    dist += ds;
    
    if (ds < SURF_DIST) {
      // Calculate normal and lighting
      float3 normal = getNormal(p);
      float3 lightDir = normalize(float3(1.0, 1.0, 1.0));
      
      // Basic Phong lighting
      float ambient = 0.1;
      float diffuse = max(dot(normal, lightDir), 0.0);
      float3 final = (ambient + diffuse) * objColor.rgb;
      
      return float4(final, 1.0);
    }
    
    if (dist > MAX_DIST) {
      break;
    }
  }
  
  // Sky gradient if no hit
  float t = rd.y * 0.5 + 0.5;
  float3 skyColor = mix(float3(0.5, 0.7, 1.0), float3(0.2, 0.3, 0.8), t);
  return float4(skyColor, 1.0);
}

@fragment float4 fragmentShader(VertexOutput input) {
  // Use ray direction and origin from vertex shader
  return raymarch(input.rayOrigin, input.rayDir);
}
