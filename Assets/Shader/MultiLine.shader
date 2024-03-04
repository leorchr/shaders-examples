Shader"Unlit/MultiLineShader"
{
   Properties
   {
       _BaseColor ("Base Color", Color) = (1,0,0,1)
       _SecondColor ("Secondary Color", Color) = (0,1,0,1)
       _MainTex("Texture", 2D) = "white"{}
       _LinesCount("Lines Count", int) = 5
       _Width("Width", float) = 0.5
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
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _BaseColor;
            uniform half4 _SecondColor;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _LinesCount;
            uniform float _Width;

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

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;
                return o;
            }

            half4 DrawLine(float2 uv, float lineWidth)
            {
                float pattern = 2 * lineWidth;
                if (uv.x % pattern < lineWidth || uv.y % pattern < lineWidth)
                {
                                            //Stripe 1
                    return _BaseColor;
                }
    
                return _SecondColor;
            }

            half4 frag(VertexOutput i) : COLOR //half4 will be treated as a color
            {
                float lineWidth = (_Width / _LinesCount);
    
                half4 color = tex2D(_MainTex, i.texcoord) * DrawLine(i.texcoord, lineWidth);
    
                return color;
            }
          
            ENDCG
        }
    }
}
