using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace KerbalKwality
{
    [KSPAddon(KSPAddon.Startup.EveryScene, false)]
    public class KerbalKwality : MonoBehaviour
    {
        public string identifier = "KerbalKwality";
        public decimal version = 0.2M;
        public string assetBundleName = "imageeffectshaders.bundle";

        public static Dictionary<string, Shader> effectShaders = new Dictionary<string, Shader>();
        public static Dictionary<string, Texture2D> effectTextures = new Dictionary<string, Texture2D>();
        public static ApplicationLauncherButton appButton;
        public static Texture2D appButtonIcon = new Texture2D(38, 38);
        public static bool _assetsLoaded = false;
        public static bool _isReady = false;

        public int IBL_cubemapSize = 128;
        public bool IBL_oneFacePerFrame = false;
        public RenderTexture IBL_renderTexture;
        public Camera IBL_camera;

        public int _lastCamCount = -1;

        public bool UseAA = true;
        public bool UseTonemap = true;
        public bool UseVignette = true;
        public bool UseBloom = true;

        public bool UseColorCorrection = true;
        public bool UseDOF = false;
        // these don't work correctly yet
        // transparency issues?
        // kerbal shaders not writing to the depth buffer correctly?
        public bool UseCrease = false;
        public bool UseEdgeDetect = false;
        public bool UseSSAO = false;

        public Camera mainCam;

        public void Update()
        {
            if(_isReady)
            {
                int camCount = Camera.allCamerasCount;
                if(camCount != _lastCamCount)
                {
                    SetupCameras();
                    AddPostEffects();
                    _lastCamCount = camCount;
                }

                if (HighLogic.LoadedScene == GameScenes.FLIGHT)
                {

                }
            }
             
        }

        public void LateUpdate()
        {
            /*
            if (_isReady)
            {
                // update the IBL cubemap texture

                if (IBL_oneFacePerFrame)
                {
                    int faceToRender = Time.frameCount % 6;
                    var faceMask = 1 << faceToRender;
                    UpdateCubemap(faceMask);
                }
                else
                {
                    UpdateCubemap(63);
                }
            }
             */
        }

        public void UpdateCubemap(int faceMask)
        {
            Vector3 center = Vector3.zero;
            if (FlightGlobals.ActiveVessel != null)
            {
                center = FlightGlobals.ActiveVessel.transform.position;
            }

            if (!IBL_camera)
            {
                Debug.Log("Creating IBL camera");
                GameObject go = new GameObject("IBL_CubemapCamera", typeof(Camera));
                go.hideFlags = HideFlags.HideAndDontSave;
                go.transform.position = center;
                go.transform.rotation = Quaternion.identity;
                IBL_camera = go.camera;
                IBL_camera.nearClipPlane = 50.0f;
                IBL_camera.farClipPlane = 100000.0f;
                IBL_camera.enabled = true;
            }

            if (!IBL_renderTexture)
            {
                Debug.Log("Creating IBL cubemap");
                IBL_renderTexture = new RenderTexture(IBL_cubemapSize, IBL_cubemapSize, 16);
                IBL_renderTexture.isCubemap = true;
                IBL_renderTexture.hideFlags = HideFlags.HideAndDontSave;
            }

            IBL_camera.enabled = true;
            IBL_camera.transform.position = center;
            IBL_camera.RenderToCubemap(IBL_renderTexture, faceMask);
            IBL_camera.enabled = false;
        }

        public void OnDisable()
        {
            DestroyImmediate(IBL_renderTexture);
            DestroyImmediate(IBL_camera);
        }

        public void Awake()
        {
            SetupQualitySettings();
            if (!_isReady)
            {
                if(!_assetsLoaded)
                {
                    StartCoroutine(LoadAssetBundle());
                }
                GameEvents.onGUIApplicationLauncherReady.Add(OnGUIAppLauncherReady);
            }
        }

        private void SetupQualitySettings()
        {
            Debug.Log("Setting QualitySettings");
            QualitySettings.antiAliasing = 0;
            QualitySettings.anisotropicFiltering = AnisotropicFiltering.Enable;
            QualitySettings.shadowProjection = ShadowProjection.StableFit;
        }

        private void SetupCameras()
        {
            Debug.Log("Setting up cameras");
            // Enable HDR and other necessary settings on the cameras
            Camera[] cams = Camera.allCameras;

            for (int i = 0; i < cams.Length; i++)
            {
                // leave the UI cameras alone
                if (
                    cams[i].name != "UI camera"
                    && cams[i].name != "UI mask camera"
                    && cams[i].name != "EZGUI Cam"
                    && cams[i].name != "UICamera"
                    )
                {
                    cams[i].hdr = true;
                }
            }
            mainCam = GetMainCamera();
        }

        public Camera GetMainCamera()
        {
            Camera cam = null;
            string cameraName = "";

            switch (HighLogic.LoadedScene)
            {
                case GameScenes.MAINMENU:
                    cameraName = "Landscape Camera";
                    break;
                case GameScenes.SPACECENTER:
                    cameraName = "Camera 00";
                    break;
                case GameScenes.TRACKSTATION:
                    //cameraName = "Camera ScaledSpace";
                    cameraName = "VectorCam";
                    break;
                case GameScenes.SPH: // space plane hanger;
                    cameraName = "Main Camera";
                    break;
                case GameScenes.EDITOR:
                    cameraName = "Main Camera";
                    break;
                case GameScenes.FLIGHT:
                    cameraName = "Camera 00";
                    if (CameraManager.Instance != null)
                    {
                        if (CameraManager.Instance.currentCameraMode == CameraManager.CameraMode.IVA)
                        {
                            Debug.Log("Current Camera Mode: Internal");
                            // decided not to apply filters to the internal view camera
                            // makes the controls look crisper
                            //cameraName = "InternalCamera";
                            cameraName = "Camera 00";
                        }
                        else if (CameraManager.Instance.currentCameraMode == CameraManager.CameraMode.Map)
                        {
                            Debug.Log("Current Camera Mode: Map");
                            cameraName = "VectorCam";
                        }
                    }
                    break;
            }

            GameObject go;
            go = GameObject.Find(cameraName);
            if (go)
            {
                cam = go.camera;
            }
            return cam;
        }

        public void SetupLights()
        {

        }

        public void AddPostEffects()
        {
            if (mainCam != null)
            {
                Debug.Log("Main Camera: " + mainCam.name);
                RemovePostEffects(mainCam);
                Debug.Log("Adding post effects");

                if (UseSSAO)
                {
                    SSAOEffect ssaoEffect = mainCam.GetComponent<SSAOEffect>();
                    if (!ssaoEffect)
                    {
                        Debug.Log("Adding SSAO");
                        ssaoEffect = mainCam.gameObject.AddComponent<SSAOEffect>();
                        ssaoEffect.m_SSAOShader = effectShaders["ScreenSpaceAmbientObscurance"];
                        ssaoEffect.m_RandomTexture = effectTextures["RandomVectors"];
                    }
                }

                if (UseColorCorrection)
                {
                    ColorCorrectionLUT ccEffect = mainCam.GetComponent<ColorCorrectionLUT>();
                    if (!ccEffect)
                    {
                        Debug.Log("Adding ColorCorrection");
                        ccEffect = mainCam.gameObject.AddComponent<ColorCorrectionLUT>();
                        ccEffect.shader = effectShaders["ColorCorrection3DLut"];
                        ccEffect.Convert(effectTextures["ContrastEnhanced3D16"], "");
                    }
                }

                if (UseAA)
                {
                    AntialiasingAsPostEffect AAeffect = mainCam.GetComponent<AntialiasingAsPostEffect>();
                    if (!AAeffect)
                    {
                        Debug.Log("Adding AA");
                        AAeffect = mainCam.gameObject.AddComponent<AntialiasingAsPostEffect>();
                        AAeffect.shader = effectShaders["AA_DLAA"];
                        AAeffect.dlaaShader = effectShaders["AA_DLAA"];
                        AAeffect.nfaaShader = effectShaders["AA_NFAA"];
                        AAeffect.shaderFXAAII = effectShaders["AA_FXAA2"];
                        AAeffect.shaderFXAAIII = effectShaders["AA_FXAA3Console"];
                        AAeffect.shaderFXAAPreset2 = effectShaders["AA_FXAAPreset2"];
                        AAeffect.shaderFXAAPreset3 = effectShaders["AA_FXAAPreset3"];
                        AAeffect.ssaaShader = effectShaders["AA_SSAA"];
                        //AAeffect.shader = effectShaders["AA_NFAA"];
                        AAeffect.mode = AAMode.NFAA;
                        AAeffect.dlaaSharp = true;
                    }
                }

                if (UseEdgeDetect)
                {
                    EdgeDetectEffectNormal EdgeEffect = mainCam.GetComponent<EdgeDetectEffectNormal>();
                    if (!EdgeEffect)
                    {
                        Debug.Log("Adding EdgeEffect");
                        EdgeEffect = mainCam.gameObject.AddComponent<EdgeDetectEffectNormal>();
                        EdgeEffect.shader = effectShaders["EdgeDetectNormals"];
                    }
                }

                if (UseCrease)
                {
                    Crease creaseEffect = mainCam.GetComponent<Crease>();
                    if (!creaseEffect)
                    {
                        Debug.Log("Adding Crease Effect");
                        creaseEffect = mainCam.gameObject.AddComponent<Crease>();
                        creaseEffect.blurShader = effectShaders["BLOOM_SeparableBlurPlus"];
                        creaseEffect.depthFetchShader = effectShaders["ConvertDepth"];
                        creaseEffect.shader = effectShaders["CreaseApply"];
                    }
                }

                if (UseDOF)
                {
                    DepthOfFieldScatter dofEffect = mainCam.GetComponent<DepthOfFieldScatter>();
                    if (!dofEffect)
                    {
                        Debug.Log("Adding DOF");
                        dofEffect = mainCam.gameObject.AddComponent<DepthOfFieldScatter>();
                        dofEffect.shader = effectShaders["DOF_DepthOfFieldScatter"];
                        dofEffect.nearBlur = false;
                        dofEffect.blurSampleCount = DepthOfFieldScatter.BlurSampleCount.High;
                        dofEffect.highResolution = true;
                        //dofEffect.blurType = DepthOfFieldScatter.BlurType.DX11;
                        dofEffect.aperture = 10f;
                    }
                }

                if (UseBloom)
                {
                    Bloom bloomEffect = mainCam.GetComponent<Bloom>();
                    if (!bloomEffect)
                    {
                        Debug.Log("Adding Bloom");
                        bloomEffect = mainCam.gameObject.AddComponent<Bloom>();
                        bloomEffect.hdr = Bloom.HDRBloomMode.Auto;
                        bloomEffect.supportHDRTextures = true;
                        bloomEffect.lensflareMode = Bloom.LensFlareStyle.Combined;
                        bloomEffect.quality = Bloom.BloomQuality.High;
                        bloomEffect.lensflareIntensity = 1.2f;
                        //bloomEffect.bloomThreshhold = 0.45f;

                        bloomEffect.shader = effectShaders["BLOOM_BlurAndFlares"];
                        bloomEffect.blurAndFlaresShader = effectShaders["BLOOM_BlurAndFlares"];
                        bloomEffect.lensFlareShader = effectShaders["BLOOM_LensFlareCreate"];
                        bloomEffect.screenBlendShader = effectShaders["BLOOM_BlendForBloom"];
                        bloomEffect.brightPassFilterShader = effectShaders["BLOOM_BrightPassFilter2"];
                        bloomEffect.lensFlareVignetteMask = effectTextures["VignetteMask"];
                    }
                }

                if (UseTonemap)
                {
                    ToneMapping toneEffect = mainCam.GetComponent<ToneMapping>();
                    if (!toneEffect)
                    {
                        Debug.Log("Adding Tonemapper");

                        toneEffect = mainCam.gameObject.AddComponent<ToneMapping>();
                        toneEffect.shader = effectShaders["Tonemapper"];
                        //toneEffect.type = ToneMapping.TonemapperType.Photographic;
                        toneEffect.type = ToneMapping.TonemapperType.AdaptiveReinhard;
                        toneEffect.exposureAdjustment = 1f;
                        toneEffect.white = 1.75f;
                    }
                }

                if (UseVignette)
                {
                    Vignetting vigEffect = mainCam.GetComponent<Vignetting>();
                    if (!vigEffect)
                    {
                        Debug.Log("Adding Vignette/Chromatic Aberration");

                        vigEffect = mainCam.gameObject.AddComponent<Vignetting>();
                        vigEffect.shader = effectShaders["VignettingShader"];
                        vigEffect.separableBlurShader = effectShaders["DOF_SeparableBlur"];
                        vigEffect.chromAberrationShader = effectShaders["ChromaticAberrationShader"];
                        vigEffect.mode = Vignetting.AberrationMode.Simple;
                        vigEffect.chromaticAberration = 1f;
                        vigEffect.intensity = 1f;
                    }

                }
            }
        }

        public void RemovePostEffects(Camera mainCam)
        {
            Debug.Log("Clearing existing post effects");
            Camera[] cams = Camera.allCameras;

            foreach (Camera c in cams)
            {
                if (c != mainCam)
                {
                    if (UseCrease)
                    {
                        Crease creaseEffect = c.GetComponent<Crease>();
                        if (creaseEffect)
                            Component.Destroy(creaseEffect);
                    }

                    if (UseSSAO)
                    {
                        SSAOEffect ssaoEffect = c.GetComponent<SSAOEffect>();
                        if(ssaoEffect)
                            Component.Destroy(ssaoEffect);
                    }

                    if (UseColorCorrection)
                    {
                        ColorCorrectionLUT ccEffect = c.GetComponent<ColorCorrectionLUT>();
                        if (ccEffect)
                            Component.DestroyImmediate(ccEffect);
                    }
                    if (UseDOF)
                    {
                        DepthOfFieldScatter dofEffect = c.GetComponent<DepthOfFieldScatter>();
                        if (dofEffect)
                            Component.Destroy(dofEffect);
                    }

                    if (UseAA)
                    {
                        AntialiasingAsPostEffect AAeffect = c.GetComponent<AntialiasingAsPostEffect>();
                        if (AAeffect)
                            Component.Destroy(AAeffect);
                    }

                    if (UseEdgeDetect)
                    {
                        EdgeDetectEffectNormal Edgeeffect = c.GetComponent<EdgeDetectEffectNormal>();
                        if (Edgeeffect)
                            Component.Destroy(Edgeeffect);
                    }

                    if (UseBloom)
                    {
                        Bloom bloomEffect = c.GetComponent<Bloom>();
                        if (bloomEffect)
                            Component.Destroy(bloomEffect);
                    }

                    if (UseTonemap)
                    {
                        ToneMapping toneEffect = c.GetComponent<ToneMapping>();
                        if (toneEffect)
                            Component.Destroy(toneEffect);
                    }

                    if (UseVignette)
                    {
                        Vignetting vigEffect = c.GetComponent<Vignetting>();
                        if (vigEffect)
                            Component.Destroy(vigEffect);
                    }
                }
            }
        }

        public void OnGUIAppLauncherReady()
        {
            if (appButton == null)
            {
                // load icon
                // There's probably a better way to do this?
                Texture2D appButtonIcon = new Texture2D(38, 38);
                string iconPath = KSPUtil.ApplicationRootPath.ToString() + "GameData/KerbalKwality/" + "kk_hd.png";
                byte[] texturebytes = File.ReadAllBytes(iconPath);
                appButtonIcon.LoadImage(texturebytes);

                appButton = ApplicationLauncher.Instance.AddModApplication(
                    onAppLaunchToggleOn,
                    onAppLaunchToggleOff,
                    onAppLaunchHoverOn,
                    onAppLaunchHoverOff,
                    onAppLaunchEnable,
                    onAppLaunchDisable,
                    ApplicationLauncher.AppScenes.ALWAYS, (Texture)appButtonIcon);
            }
        }

        void onAppLaunchToggleOn()  /*Your code goes in here to toggle display on regardless of hover*/ 
        {
            Debug.Log("Turning off HD effects");
            RemovePostEffects(null);
        }

        void onAppLaunchToggleOff() /*Your code goes in here to toggle display off regardless of hover*/
        {
            Debug.Log("Turning on HD effects");
            Camera[] cams = Camera.allCameras;
            foreach (Camera c in cams)
            {
                Debug.Log(c.name);
            }

            
            mainCam = GetMainCamera();
            AddPostEffects();
            Debug.Log("MainCamera is: " + mainCam.name);

        }
        void onAppLaunchHoverOn() /*Your code goes in here to show display on*/
        {

        }
        void onAppLaunchHoverOff() /*Your code goes in here to show display off*/
        {

        }
        void onAppLaunchEnable() /*Your code goes in here for if it gets enabled*/ 
        {
        
        }
        void onAppLaunchDisable() /*Your code goes in here for if it gets disabled*/
        {

        }


        public IEnumerator LoadAssetBundle(bool forceReload = false)
        {
            if (_assetsLoaded == false || forceReload == true)
            {
                // load shader from asset bundle
                Debug.Log(identifier + ": Loading assets");
                AssetBundle assetBundle;
                string assetPath = KSPUtil.ApplicationRootPath.ToString() + "GameData/KerbalKwality/" + assetBundleName;
                byte[] assetBytes = File.ReadAllBytes(assetPath);
                AssetBundleCreateRequest acr = AssetBundle.CreateFromMemory(assetBytes);

                //while (!acr.isDone)
                yield return acr;

                assetBundle = acr.assetBundle;

                if (assetBundle == null)
                    Debug.Log("Failed to load Asset Bundle");
                else
                    Debug.Log("Asset Bundle loaded!");

                string[] assetShaderNames = new string[] 
            { 
                "GrayscaleEffect", 
                "AA_DLAA", 
                "AA_FXAA2", 
                "AA_FXAA3Console",
                "AA_FXAAPreset2", 
                "AA_FXAAPreset3", 
                "AA_NFAA", 
                "AA_SSAA",
                "ScreenSpaceAmbientObscurance",
                "Tonemapper",
                "VignettingShader",
                "ChromaticAberrationShader",
                "DOF_SeparableBlur",
                "DOF_DepthOfFieldScatter",
                "BLOOM_Blend",
                "BLOOM_BlendForBloom",
                "BLOOM_BlendOneOne",
                "BLOOM_BlurAndFlares",
                "BLOOM_BrightPassFilter",
                "BLOOM_BrightPassFilter2",
                "BLOOM_LensFlareCreate",
                "BLOOM_MobileBloom",
                "BLOOM_MobileBlur",
                "BLOOM_MultiPassHollywoodFlares",
                "BLOOM_SeparableBlurPlus",
                "BLOOM_VignetteShader",
                "EdgeDetectNormals",
                "ColorCorrection3DLut",
                "CreaseApply",
                "",
                "ConvertDepth"
            };

                string[] assetTextureNames = new string[] 
            { 
                "RandomVectors",
                "VignetteMask",
                "ContrastEnhanced3D16"
            };

                foreach (string assetName in assetShaderNames)
                {
                    Debug.Log("Loading " + assetName);
                    Object shaderAsset = assetBundle.Load(assetName);
                    if (shaderAsset != null)
                    {
                        Debug.Log("Asset " + assetName + " has been loaded");
                        effectShaders.Add(assetName, (Shader)shaderAsset);
                    }
                }
                foreach (string assetName in assetTextureNames)
                {
                    Debug.Log("Loading " + assetName);
                    Object textureAsset = assetBundle.Load(assetName);
                    if (textureAsset != null)
                    {
                        Debug.Log("Asset " + assetName + " has been loaded");
                        effectTextures.Add(assetName, (Texture2D)textureAsset);
                    }
                }
                assetBundle.Unload(false);
                Debug.Log("Assets have been loaded");
                _assetsLoaded = true;
                Debug.Log(identifier + " is ready");
                _isReady = true;
            }
        }
    }
}
