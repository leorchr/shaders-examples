Shader"Unlit/Flag"
{
   Properties
   {    
       _MainTex("Main Texture", 2D) = "white"{}
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
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };

            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                pos.z = pos.z + (sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude) * uv.x;
                return pos;
            }

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.texcoord.xy = v.texcoord;
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                v.vertex = vertexAnimFlag(v.vertex, o.texcoord.xy);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR //half4 will be treated as a color
            {
                half4 color = tex2D(_MainTex, i.texcoord);
                return color;
            }

            ENDCG
        }
    }
}
