#include "hash-functions.hlsl"

cbuffer TimeConstants : register(b0)
{
    float GlobalTime;
    float Time;
    float RunTime;
    float BeatTime;
    float LastFrameDuration;
}

cbuffer Transforms : register(b1)
{
    float4x4 CameraToClipSpace;
    float4x4 ClipSpaceToCamera;
    float4x4 WorldToCamera;
    float4x4 CameraToWorld;
    float4x4 WorldToClipSpace;
    float4x4 ClipSpaceToWorld;
    float4x4 ObjectToWorld;
    float4x4 WorldToObject;
    float4x4 ObjectToCamera;
    float4x4 ObjectToClipSpace;
};

cbuffer CountConstants : register(b2)
{
    int4 BufferCount;
}

cbuffer Params : register(b3)
{
    float LifeTime;
    float LifeTimeScatter;

    float Size;
    float SizeScatter;
    float EmitterId;
    float3 Velocity;
    float MaxEmitCount;
}

struct Point {
    float3 Position;
    float W;
};

//Texture2D<float4> inputTexture : register(t0);
//SamplerState linearSampler : register(s0);
StructuredBuffer<Point> Points : t0;         // input
StructuredBuffer<Point> Points2 : t0;         // input
RWStructuredBuffer<Point> ResultPoints : u0;    // output
//ConsumeStructuredBuffer<ParticleIndex> DeadParticles : u1;

// uint wang_hash(in out uint seed)
// {
//     seed = (seed ^ 61) ^ (seed >> 16);
//     seed *= 9;
//     seed = seed ^ (seed >> 4);
//     seed *= 0x27d4eb2d;
//     seed = seed ^ (seed >> 15);
//     return seed;
// }

[numthreads(64,1,1)]
void main(uint3 i : SV_DispatchThreadID)
{
    ResultPoints[i.x].Position = (Points[i.x].Position + Points2[i.x].Position)*0.5;
    ResultPoints[i.x].W = (Points[i.x].W + Points2[i.x].W)*0.5;

    // if ((uint)i.x >= (uint)BufferCount.x)
    //    return; // no particles available


    // if (i.x >= (uint)MaxEmitCount)
    //    return; // no particles available

    // ParticleIndex pi = DeadParticles.Consume();
        
    // Particle particle = Particles[pi.index];
    // particle.emitterId = EmitterId;
    // //uint rng_state = uint((RunTime + 123)*1123023.4)*10 + i.x;
    // float4 hash = hash41(BeatTime + (float)i.x);
    // float u = hash.x;// float(wang_hash(rng_state)) * (1.0 / 4294967296.0)+ hash.x;
    // float v = hash.y; //float(wang_hash(rng_state)) * (1.0 / 4294967296.0)+ hash.y;



    // float2 emitterSize = float2(1.0, 1.0);
    // float4 posInObject = float4((u - 0.5)*emitterSize.x, -(v - 0.5)*emitterSize.y, 0, 1);
    // particle.position = mul(posInObject, ObjectToWorld).xyz;
    // //particle.velocity = float3(0,0,0);
    // particle.size = Size;
    // particle.velocity = Velocity;
    // float u_mass = hash.x;
    // particle.mass = 1.0 + step(0.05, u_mass)*999.0; // 5% with small mass
    // //particle.lifetime = particle.mass > 5.0 ? 5.0 : 50.0;
    // particle.lifetime = LifeTime + u * LifeTimeScatter; 
    // particle.emitTime = BeatTime;

    // //float s = 25.0;
    // //u = fmod(abs(particle.position.x), s)/s;
    // //v = fmod(abs(particle.position.z), s)/s;
    // float4 color = inputTexture.SampleLevel(linearSampler, float2(u, v), 0);
    // particle.color = color * float4(1,1,1,1);//float4(1,0,0,1);

    // Particles[pi.index] = particle;
}

