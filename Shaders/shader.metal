#include <metal_stdlib>

using namespace metal;

struct VertexOutput
{
  float4 position [[position]];
  float4 color;
};

vertex VertexOutput render_vertex(uint vid [[vertex_id]])
{
  VertexOutput vertexOut;
  // Clockwise winding order
  if (vid == 0)
  {
    // Middle top of screen.
    vertexOut.position = float4(0.0, 1.0, 0.0, 1.0);
    vertexOut.color = float4(1.0, 0.3, 0.3, 1.0);
  }
  else if (vid == 1)
  {
    // Bottom right
    vertexOut.position = float4(1.0, -1.0, 0.0, 1.0);
    vertexOut.color = float4(0.3, 1.0, 0.3, 1.0);
  }
  else if (vid == 2)
  {
    // Bottom left
    vertexOut.position = float4(-1.0, -1.0, 0.0, 1.0);
    vertexOut.color = float4(0.3, 0.3, 1.0, 1.0);
  }
  return vertexOut;
}

fragment float4 render_fragment(VertexOutput vertexIn [[stage_in]])
{
  return vertexIn.color;
}