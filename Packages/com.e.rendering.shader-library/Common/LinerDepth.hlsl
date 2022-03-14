#ifndef E_LINER_DEPTH_INCLUDED
#define E_LINER_DEPTH_INCLUDED

// x = 1 or -1 (-1 if projection is flipped)
// y = near plane
// z = far plane
// w = 1/far plane
//float4 projectionParams

// x = 1-far/near
// y = far/near
// z = x/far
// w = y/far
// or in case of a reversed depth buffer (UNITY_REVERSED_Z is 1)
// x = -1+far/near
// y = 1
// z = x/far
// w = 1/far
//float4 zBufferParams

float ReversedZBufferValue(float zBufferValue)
{
#if UNITY_REVERSED_Z
    return 1 - zBufferValue;
#else
    return zBufferValue;
#endif
}

//01 depth from orthographic camera near
float OrthoLinear01DepthFromNear(float rawDepth)
{
#if UNITY_REVERSED_Z
    return (1.0 - rawDepth);
#else
    return rawDepth;
#endif
}

//01 depth from orthographic camera position
float OrthoLinear01Depth(float rawDepth, float4 projectionParams)
{
#if UNITY_REVERSED_Z
    return ((projectionParams.z - projectionParams.y) * (1.0 - rawDepth) + projectionParams.y) * projectionParams.w;
#else
    return ((projectionParams.z - projectionParams.y) * rawDepth + projectionParams.y) * projectionParams.w;
#endif
}

//01 depth from perspective camera near
float PerspectiveLinear01DepthFromNear(float rawDepth, float4 zBufferParams)
{
    return 1.0 / (zBufferParams.x + zBufferParams.y / rawDepth);
}

//01 depth from perspective camera position
float PerspectiveLinear01Depth(float rawDepth, float4 zBufferParams)
{
    return 1.0 / (zBufferParams.x * rawDepth + zBufferParams.y);
}

//eye depth from orthographic camera near
float OrthoLinearEyeDepthFromNear(float rawDepth, float4 projectionParams)
{
#if UNITY_REVERSED_Z
    return ((projectionParams.z - projectionParams.y) * (1.0 - rawDepth));
#else
    return ((projectionParams.z - projectionParams.y) * rawDepth);
#endif
}

//eye depth from orthographic camera position
float OrthoLinearEyeDepth(float rawDepth, float4 projectionParams)
{
#if UNITY_REVERSED_Z
    return ((projectionParams.z - projectionParams.y) * (1.0 - rawDepth) + projectionParams.y);
#else
    return ((projectionParams.z - projectionParams.y) * rawDepth + projectionParams.y);
#endif
}

//eye depth from perspective camera near
float PerspectiveLinearEyeDepthFromNear(float rawDepth, float4 projectionParams, float4 zBufferParams)
{
    return 1.0 / (zBufferParams.z * rawDepth + zBufferParams.w) - projectionParams.y;
}

//eye depth from perspective camera position
float PerspectiveLinearEyeDepth(float rawDepth, float4 zBufferParams)
{
    return 1.0 / (zBufferParams.z * rawDepth + zBufferParams.w);
}

//01 depth from camera near use _ProjectionParams and _ZBufferParams
float CurrentLinear01DepthFromNear(float rawDepth)
{
    return unity_OrthoParams.w ?
    OrthoLinear01DepthFromNear(rawDepth) :
    PerspectiveLinear01DepthFromNear(rawDepth, _ZBufferParams);
}

//01 depth from camera position use _ProjectionParams and _ZBufferParams
float CurrentLinear01Depth(float rawDepth)
{
    return unity_OrthoParams.w ?
    OrthoLinear01Depth(rawDepth, _ProjectionParams) :
    PerspectiveLinear01Depth(rawDepth, _ZBufferParams);
}

//eye depth from camera near use _ProjectionParams and _ZBufferParams
float CurrentLinearEyeDepthFromNear(float rawDepth)
{
    return unity_OrthoParams.w ?
    OrthoLinearEyeDepthFromNear(rawDepth, _ProjectionParams) :
    PerspectiveLinearEyeDepthFromNear(rawDepth, _ProjectionParams, _ZBufferParams);
}

//eye depth from camera position use _ProjectionParams and _ZBufferParams
float CurrentLinearEyeDepth(float rawDepth)
{
    return unity_OrthoParams.w ?
    OrthoLinearEyeDepth(rawDepth, _ProjectionParams) :
    PerspectiveLinearEyeDepth(rawDepth, _ZBufferParams);
}

#endif