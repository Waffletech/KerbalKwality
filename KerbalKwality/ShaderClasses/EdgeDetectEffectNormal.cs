using UnityEngine;

namespace KerbalKwality
{
    class EdgeDetectEffectNormal : ImageEffectBase
    {
        public enum EdgeDetectMode
        {
            TriangleDepthNormals = 0,
            RobertsCrossDepthNormals = 1,
            SobelDepth = 2,
            SobelDepthThin = 3,
            TriangleLuminance = 4,
        }

        public EdgeDetectMode mode = EdgeDetectMode.SobelDepthThin;
        public float sensitivityDepth = 1.0f;
        public float sensitivityNormals = 1.0f;
        public float lumThreshhold = 0.2f;
        public float edgeExp = 1.0f;
        public float sampleDist = 1.0f;
        public float edgesOnly = 0.0f;
        public Color edgesOnlyBgColor = Color.white;

        //public Shader shader;
        private Material edgeDetectMaterial = null;
        private EdgeDetectMode oldMode = EdgeDetectMode.SobelDepthThin;

        private bool CheckSupport(bool needDepth, bool needHDR)
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

        public bool CheckResources()
        {
            CheckSupport(true);

            edgeDetectMaterial = CheckShaderAndCreateMaterial(shader, edgeDetectMaterial);
            if (mode != oldMode)
                SetCameraFlag();

            oldMode = mode;

            //if (!isSupported)
            //ReportAutoDisable ();
            return isSupported;
        }

        public void Start()
        {
            oldMode = mode;
        }

        public void SetCameraFlag()
        {
            if (mode == EdgeDetectMode.SobelDepth || mode == EdgeDetectMode.SobelDepthThin)
                camera.depthTextureMode |= DepthTextureMode.Depth;
            else if (mode == EdgeDetectMode.TriangleDepthNormals || mode == EdgeDetectMode.RobertsCrossDepthNormals)
                camera.depthTextureMode |= DepthTextureMode.DepthNormals;
        }

        public void OnEnable()
        {
            SetCameraFlag();
        }

        [ImageEffectOpaque]
        public void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (CheckResources() == false)
            {
                Graphics.Blit(source, destination);
                return;
            }

            Vector2 sensitivity = new Vector2(sensitivityDepth, sensitivityNormals);
            edgeDetectMaterial.SetVector("_Sensitivity", new Vector4(sensitivity.x, sensitivity.y, 1.0f, sensitivity.y));
            edgeDetectMaterial.SetFloat("_BgFade", edgesOnly);
            edgeDetectMaterial.SetFloat("_SampleDistance", sampleDist);
            edgeDetectMaterial.SetVector("_BgColor", edgesOnlyBgColor);
            edgeDetectMaterial.SetFloat("_Exponent", edgeExp);
            edgeDetectMaterial.SetFloat("_Threshold", lumThreshhold);

            Graphics.Blit(source, destination, edgeDetectMaterial, (int)mode);
        }
    }
}

