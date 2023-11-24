#include "..\Inc\LocalChanges.h"

struct ModelViewProjection
{
    matrix MVP;
};

ConstantBuffer<ModelViewProjection> ModelViewProjectionCB : register(b0);

struct VertexPosColor
{
    float3 Position : POSITION;
    float3 Color    : COLOR;
};

#if STRUCTURED_BUFFER_AS_VB
StructuredBuffer<VertexPosColor> VertexBuffer : register(t0);
#endif

struct VertexShaderOutput
{
	float4 Color    : COLOR;
    float4 Position : SV_Position;
};

#if STRUCTURED_BUFFER_AS_VB
VertexShaderOutput main(uint VertexID : SV_VertexID)
{
    VertexShaderOutput OUT;

    float3 InPosition = VertexBuffer[VertexID].Position;
    float3 InColor = VertexBuffer[VertexID].Color;
    OUT.Position = mul(ModelViewProjectionCB.MVP, float4(InPosition, 1.0f));
    OUT.Color = float4(InColor, 1.0f);

    return OUT;
}
#else
VertexShaderOutput main(VertexPosColor IN, uint VertexID : SV_VertexID)
{
    VertexShaderOutput OUT;

    OUT.Position = mul(ModelViewProjectionCB.MVP, float4(IN.Position, 1.0f));
    OUT.Color = float4(IN.Color, 1.0f);

    return OUT;
}
#endif