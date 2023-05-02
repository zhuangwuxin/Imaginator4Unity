Shader "Imaginator/Standard"
{
    Properties
    {
        _MainTex("Base Map", 2D) = "white" {}
        [NoScaleOffset]
        _BumpMap("Normal Map", 2D) = "bump" {}
        [NoScaleOffset]
        _ParallaxMap("Height Map", 2D) = "white" {}
        _Amplitude("Amplitude", Float) = 1
        [NoScaleOffset]
        _OcclusionMap("Occlusion Map", 2D) = "white" {}
        [NoScaleOffset]
        _SmoothnessMap("Smoothness Map", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 1
        _Metallic("Metallic", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _ParallaxMap;
        sampler2D _OcclusionMap;
        sampler2D _SmoothnessMap;
        float _Amplitude;
        float _Smoothness;
        float _Metallic;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float height = tex2D(_ParallaxMap, IN.uv_MainTex).r;
            IN.uv_MainTex += ParallaxOffset(height, _Amplitude * 0.01, IN.viewDir);

            // Sample base color
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;

            // Sample normal map
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));

            // Sample occlusion map
            o.Occlusion = tex2D(_OcclusionMap, IN.uv_MainTex).r;

            // Sample smoothness
            o.Smoothness = tex2D(_SmoothnessMap, IN.uv_MainTex).r * _Smoothness;

            o.Emission = 0.0;
            o.Metallic = _Metallic;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
