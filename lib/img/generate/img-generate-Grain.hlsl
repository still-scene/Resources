#include "hash-functions.hlsl"

cbuffer ParamConstants : register(b0)
{
    float Amount;
    float Color;
    float Exponent;
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

#define mod(x, y) (x - y * floor(x / y))
float IsBetween( float value, float low, float high) {
    return (value >= low && value <= high) ? 1:0;
}

float4 psMain(vsOutput psInput) : SV_TARGET
{   
    float subHashX = hash12(psInput.texCoord * 10 + (beatTime * 0.01 % 113.1)); 
    float subHashY = hash12(psInput.texCoord * 12 + (beatTime * 0.013 % 10.1)); 
    float4 hash = hash42((psInput.texCoord + float2(subHashX,subHashY)) 
        + float2( 1233+ (beatTime * 0.001 % 13.1), 
            3000+ (beatTime * 0.001 % 13.1) )); 


    
    float4 grayScale = (hash.r+hash.g+hash.b)/3;
    float4 noise = lerp(grayScale, hash, Color);
    noise = pow(noise, Exponent);

    float4 orgColor = ImageA.Sample(texSampler, psInput.texCoord);
    float4 color = float4( lerp( orgColor.rgb, noise.rgb, Amount), 1);
    return color;
}