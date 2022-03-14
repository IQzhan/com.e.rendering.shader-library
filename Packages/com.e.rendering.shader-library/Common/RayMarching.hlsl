#ifndef E_RAY_MARCHING_INCLUDED
#define E_RAY_MARCHING_INCLUDED

void ComputeOrthoRay(float2 positionSS, out float3 origin, out float3 direction)
{
    direction = mul(unity_CameraToWorld, float4(0.0, 0.0, 1.0, 0.0)).xyz;
    origin = mul(unity_CameraToWorld, float4((positionSS * 2 - 1) * unity_OrthoParams.xy, _ProjectionParams.y, 1.0)).xyz;
}

void ComputePerspectiveRay(float2 positionSS, out float3 origin, out float3 direction)
{
    //ndc position of near
    float4 ndcPos = float4(positionSS * 2 - 1, 0, 1);
    float4 viewPos = mul(unity_CameraInvProjection, ndcPos);
    //normalize viewPos
    viewPos /= -viewPos.z;
    //unity_CameraToWorld is left hand
    viewPos.z *= -1;
    direction = mul(unity_CameraToWorld, float4(viewPos.xyz, 0.0)).xyz;
    origin = _WorldSpaceCameraPos + direction * _ProjectionParams.y;
}

void ComputeRay(float2 positionSS, out float3 origin, out float3 direction)
{
    if(unity_OrthoParams.w)
    {
        ComputeOrthoRay(positionSS, origin, direction);
    }
    else
    {
        ComputePerspectiveRay(positionSS, origin, direction);
    }
}

//z is from near
float3 ComputeRayPosition(float3 origin, float3 direction, float z)
{
    return origin + direction * z;
}

#endif