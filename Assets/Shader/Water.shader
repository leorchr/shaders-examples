Shader"Unlit/Water"
{
   Properties
   {
        _BaseColor ("Base Color", Color) = (1,0,0,1)
        _SecondColor ("Secondary Color", Color) = (0,1,0,1)
        _NoiseTex("Main Texture", 2D) = "white"{}
        _Height("Height", float) = 1.0
        _Speed("Speed", float) = 1.0
        _Frequency("Frequency", float) = 1.0
        _Amplitude("Amplitude", float) = 1.0
   }
   SubShader
   {
    Tags{
       "Queue" = "Transparent"
       "RenderType" = "Transparent"
       "IgnoreProjector" = "True"
       }
       Pass
       {
            Blend SrcAlpha
            OneMinusSrcAlpha
            LOD 200
            CULL Off
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _BaseColor;
            uniform half4 _SecondColor;
            uniform sampler2D _NoiseTex;
            uniform float4 _NoiseTex_ST;
            uniform float _Height;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord : TEXCOORD0;
                float heightValue : DISPLACEMENT;
            };

            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                pos.y = sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude;
                return pos;
            }

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                float displacement = tex2Dlod(_NoiseTex, v.texcoord * _NoiseTex_ST);
                o.pos = UnityObjectToClipPos(v.vertex + (v.normal * displacement * 0.1f * _Height) + vertexAnimFlag(v.vertex, v.texcoord.xy));
                o.texcoord.xy = (v.texcoord.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw;
                o.heightValue = o.texcoord.x;
                return o;
            }

            half4 frag(VertexOutput i) : COLOR //half4 will be treated as a color
            { 
                half4 color = tex2D(_NoiseTex, i.texcoord).x * _SecondColor + (1 - tex2D(_NoiseTex, i.texcoord).x) * _BaseColor; // * DrawColor(i.texcoord);
                color.xyz *= i.heightValue;
                return color;
            }
            ENDCG
        }
    }
}
