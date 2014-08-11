using UnityEngine;

namespace KerbalKwality
{
    public class ImageEffectBase : MonoBehaviour
    {
        /// Provides a shader property that is set in the inspector
        /// and a material instantiated from the shader
        public Shader shader;
        protected Material m_Material;
        public bool isSupported = true;

        protected void Start()
        {
            // Disable if we don't support image effects
            if (!SystemInfo.supportsImageEffects)
            {
                isSupported = false;
                enabled = false;
                return;
            }

            // Disable the image effect if the shader can't
            // run on the users graphics card
            if (!shader || !shader.isSupported)
                enabled = false;
        }

        protected Material material
        {
            get
            {
                if (m_Material == null)
                {
                    m_Material = new Material(shader);
                    m_Material.hideFlags = HideFlags.HideAndDontSave;
                }
                return m_Material;
            }
        }

        protected void OnDisable()
        {
            if (m_Material)
            {
                DestroyImmediate(m_Material);
            }
        }

        protected bool CheckSupport(bool needDepth, bool needHDR=false)
        {
            isSupported = true;
            bool supportHDRTextures = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBHalf);
            bool supportDX11 = SystemInfo.graphicsShaderLevel >= 50 && SystemInfo.supportsComputeShaders;

            if (!SystemInfo.supportsImageEffects || !SystemInfo.supportsRenderTextures)
            {
                //NotSupported ();
                isSupported = false;
                return false;
            }

            if (needDepth && !SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.Depth))
            {
                //NotSupported ();
                isSupported = false;
                return false;
            }

            if (needDepth)
                camera.depthTextureMode |= DepthTextureMode.Depth;

            return true;
        }

        protected Material CheckShaderAndCreateMaterial(Shader s, Material m2Create)
        {
            if (!s)
            {
                Debug.Log("Missing shader in " + this.ToString());
                enabled = false;
                return null;
            }

            if (s.isSupported && m2Create && m2Create.shader == s)
                return m2Create;

            if (!s.isSupported)
            {
                enabled = false;
                isSupported = false;
                Debug.Log("The shader " + s.ToString() + " on effect " + this.ToString() + " is not supported on this platform!");
                return null;
            }
            else
            {
                //Debug.Log("Creating material");
                m2Create = new Material(s);
                m2Create.hideFlags = HideFlags.DontSave;
                if (m2Create)
                {
                    return m2Create;
                }
                else 
                    return null;
            }
        }

        protected Material CreateMaterial(Shader s, Material m)
        {
            if (m != null && m.shader == m && s.isSupported)
            {
                return m;
            }

            if (!s.isSupported)
            {
                return null;
            }
            else
            {
                m = new Material(s);
                m.hideFlags = HideFlags.DontSave;
                return m;
            }
        }

    }
}