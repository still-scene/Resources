cbuffer ParamConstants : register(b0)
{
    float4 Fill;
    float4 Background;
    float2 Center;
    float Width;
    float Rotation;
    float PingPong;
    float Smooth;
}

cbuffer TimeConstants : register(b1)
{
    float globalTime;
    float time;
    float runTime;
    float beatTime;
}

struct vsOutput
{
    float4 position : SV_POSITION;
    float2 texCoord : TEXCOORD;
};

Texture2D<float4> ImageA : register(t0);
sampler texSampler : register(s0);

float4 psMain(vsOutput psInput) : SV_TARGET
{    
    float2 p = psInput.texCoord;

    float radians = Rotation / 180 *3.141578;
    float2 angle =  float2(sin(radians),cos(radians));

    float4 orgColor = ImageA.Sample(texSampler, psInput.texCoord);

    float c=  dot(p-Center, angle) / Width;
    if(PingPong > 0.5) {
        c = abs(-c);
    }
    else {
        c= c +0.5 * Width;
    }

    if(Smooth > 0.5) {
        c= smoothstep(0,1,c);
    }

    return lerp(Fill, Background, c);
}