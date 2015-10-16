//
//  Shaders.metal
//  HelloMetal
//
//  Created by Giovanni Sabella on 8/30/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct vertexIn {
    packed_float3 position;
    packed_float2 uv;
    packed_float4 color;
};

struct modelData {
    float4x4 modelViewMatrix;
    float4x4 projectionMatrix;
};

struct v2f {
    float4 position [[ position ]];
    float2 uv;
    float4 color;
};

vertex v2f basicVert(const device vertexIn* verts [[ buffer(0) ]],
                     const device modelData& uniforms [[ buffer(1) ]],
                     unsigned int vid [[ vertex_id ]])
{
    v2f out;
    
    float4x4 mv_matrix = uniforms.modelViewMatrix;
    float4x4 p_matrix = uniforms.projectionMatrix;
    
    vertexIn v = verts[vid];
    out.position = p_matrix * mv_matrix * float4(v.position, 1.0);
    out.uv = v.uv;
    out.color = v.color;
    return out;
}

fragment half4 basicFrag(v2f in [[ stage_in ]],
                         texture2d<float> mainTex [[ texture(0) ]],
                         sampler sampler2d [[ sampler(0) ]])
{
    float4 color = in.color;
    color *= mainTex.sample(sampler2d, in.uv);
    return half4(color);
}
