using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderControl : MonoBehaviour
{
    [SerializeField] private Material shader;
    [Range(0.0001f, 0.01f)] [SerializeField] private float speed;

    // Update is called once per frame
    void Update()
    {
        shader.SetFloat("_Start", shader.GetFloat("_Start") + speed);
        if(shader.GetFloat("_Start") > 1)
        {
            shader.SetFloat("_Start", 0 - shader.GetFloat("_Width"));
        }
        shader.SetVector("_Color", shader.GetVector("_Color") + new Vector4(0,speed,0,1));
        if (shader.GetVector("_Color").y > 0.9)
        {
            shader.SetVector("_Color", new Vector4(0, 0, 0, 1));
        }
    }
}
