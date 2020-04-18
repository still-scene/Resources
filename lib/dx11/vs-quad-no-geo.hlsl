
static const float3 Quad[] = 
{
  float3(-1, -1, 0),
  float3( 1, -1, 0), 
  float3( 1,  1, 0), 
  float3( 1,  1, 0), 
  float3(-1,  1, 0), 
  float3(-1, -1, 0), 
};


cbuffer Transforms : register(b0)
{
    float4x4 clipSpaceTcamera;
    float4x4 cameraTclipSpace;
    float4x4 cameraTworld;
    float4x4 worldTcamera;
    float4x4 clipSpaceTworld;
    float4x4 worldTclipSpace;
    float4x4 worldTobject;
    float4x4 objectTworld;
    float4x4 cameraTobject;
    float4x4 clipSpaceTobject;
};

cbuffer Params : register(b1)
{
    float4 Color;
    float Width;
    float Height;
};

Texture2D<float4> InputTexture : register(t0);
sampler texSampler : register(s0);


struct vsOutput
{
    float4 position : SV_POSITION;
    float2 texCoord : TEXCOORD;
};

// struct vsOutputOnlyColor
// {
//     float4 position : SV_POSITION;
//     float4 color : COLOR0;
// };

vsOutput vsMain(uint vertexId: SV_VertexID)
{
    vsOutput output;
    float2 quadVertex = Quad[vertexId].xy;
    float2 object_P_quadVertex = quadVertex * float2(Width, Height);
    output.position = mul(clipSpaceTobject, float4(object_P_quadVertex, 0, 1));
    output.texCoord = quadVertex*float2(0.5, -0.5) + 0.5;

    return output;
}

// vsOutput vsMainOnlyColor(uint vertexId: SV_VertexID)
// {
//     vsOutputOnlyColor output;
//     float4 quadPos = float4(Quad[vertexId], 1) ;
//     float4 size = float4(Width,Height,1,1);
//     output.position = mul(clipSpaceTobject, float4(Quad[vertexId]*1,1) * size);
//     output.color = Color; 

//     return output;
// }

float4 psMain(vsOutput input) : SV_TARGET
{
    float4 c = InputTexture.Sample(texSampler, input.texCoord);
    return clamp(float4(1,1,1,1) * Color * c, 0, float4(1000,1000,1000,1));
}


float4 psMainOnlyColor(vsOutput input) : SV_TARGET
{
    return float4(1,1,0,1); //saturate(Color);
}
