// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Imaginator/BlitSwizzle"
{
    SubShader
    {
        ZWrite Off
        ZTest Always
        Blend Off
        Cull Off
        ColorMask [_ColorWriteMask]

        Pass
        {
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv         : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 texcoord   : TEXCOORD0;
            };

            sampler2D _MainTex;

            float4 _ColorMixR;
            float4 _ColorMixG;
            float4 _ColorMixB;
            float4 _ColorMixA;

            Varyings Vert(Attributes i)
            {
                Varyings o;
                o.positionCS = UnityObjectToClipPos(i.positionOS);
                o.texcoord = i.uv;
                return o;
            }

            float4 Frag(Varyings i) : SV_Target
            {
                float4 inputColor = tex2D(_MainTex, i.texcoord);
                float4 outputColor = inputColor;
                outputColor.r = dot(inputColor, _ColorMixR);
                outputColor.g = dot(inputColor, _ColorMixG);
                outputColor.b = dot(inputColor, _ColorMixB);
                outputColor.a = dot(inputColor, _ColorMixA);
                return outputColor;
            }
            ENDCG
        }
    }
}
