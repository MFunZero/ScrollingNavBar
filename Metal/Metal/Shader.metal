//
//  Shader.metal
//  Metal
//
//  Created by suze on 15/10/21.
//  Copyright © 2015年 suze. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertext(
const device packed_float3* vertex_array [[buffer(0)]],
                            unsigned int vid [[ vertex_id]]{
                                return float4(vertex_array[vid],1.0);
                            }
)

fragment half4 basic_fragment(){
    return half4(1.0);
}