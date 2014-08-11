// Compiled shader for all platforms, uncompressed size: 667.7KB

Shader "KSP/Kerbal Physically Based Shader" {
Properties {
 _Diffuse ("Diffuse", Color) = (0.501961,0.501961,0.501961,1)
 _MetRoughLum ("MetRoughLum", 2D) = "white" {}
 _MainTex ("MainTex", 2D) = "gray" {}
 _IBL ("IBL", CUBE) = "_Skybox" {}
 _Reflection ("Reflection", CUBE) = "_Skybox" {}
 _BumpTex ("BumpTex", 2D) = "bump" {}
[MaterialToggle]  _DiffuseHasAlphaclip ("DiffuseHasAlphaclip", Float) = 1
[MaterialToggle]  _DiffuseHasRoughness ("DiffuseHasRoughness", Float) = 0.407843
 _RimFalloff ("RimFalloff", Range(0,5)) = 4
 _RimColor ("RimColor", Color) = (0,0,0,1)
 _ReflectionAmt ("ReflectionAmt", Range(0,1)) = 0.5
 _IBLAmt ("IBLAmt", Range(0,1)) = 0.5
 _Opacity ("Opacity", Range(0,1)) = 0
[HideInInspector]  _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}
SubShader { 
 Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }


 // Stats for Vertex shader:
 //       d3d11 : 23 math
 //        d3d9 : 29 math
 // Stats for Fragment shader:
 //       d3d11 : 110 math, 4 texture
 //        d3d9 : 121 math, 7 texture
 Pass {
  Name "FORWARDBASE"
  Tags { "LIGHTMODE"="ForwardBase" "SHADOWSUPPORT"="true" "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
  ZWrite Off
  Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;

uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform samplerCube _IBL;
uniform samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _RimFalloff;
uniform vec4 _RimColor;
uniform float _ReflectionAmt;
uniform float _IBLAmt;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec3 tmpvar_6;
  vec3 i_7;
  i_7 = -(tmpvar_3);
  tmpvar_6 = (i_7 - (2.0 * (dot (tmpvar_5, i_7) * tmpvar_5)));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_9;
  x_9 = (mix (1.0, tmpvar_8.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec3 tmpvar_10;
  tmpvar_10 = normalize(_WorldSpaceLightPos0.xyz);
  vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_3 + tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, tmpvar_10);
  vec3 tmpvar_13;
  tmpvar_13 = (((max (0.0, tmpvar_12) * 0.31831) * _LightColor0.xyz) + (gl_LightModel.ambient.xyz * 2.0));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  bvec3 tmpvar_15;
  tmpvar_15 = greaterThan ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz), vec3(0.5, 0.5, 0.5));
  vec3 b_16;
  b_16 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - tmpvar_14.z)));
  vec3 c_17;
  c_17 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_5, tmpvar_3))), _RimFalloff) * _RimColor.xyz)) * tmpvar_14.z);
  float tmpvar_18;
  if (tmpvar_15.x) {
    tmpvar_18 = b_16.x;
  } else {
    tmpvar_18 = c_17.x;
  };
  float tmpvar_19;
  if (tmpvar_15.y) {
    tmpvar_19 = b_16.y;
  } else {
    tmpvar_19 = c_17.y;
  };
  float tmpvar_20;
  if (tmpvar_15.z) {
    tmpvar_20 = b_16.z;
  } else {
    tmpvar_20 = c_17.z;
  };
  vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_18;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_20;
  vec3 tmpvar_22;
  tmpvar_22 = clamp (tmpvar_21, 0.0, 1.0);
  float tmpvar_23;
  tmpvar_23 = mix (((tmpvar_14.y * -1.0) + 1.0), tmpvar_8.w, _DiffuseHasRoughness);
  float tmpvar_24;
  tmpvar_24 = exp2(((tmpvar_23 * 10.0) + 1.0));
  float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_12);
  float tmpvar_26;
  tmpvar_26 = ((tmpvar_14.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_8.xyz)));
  vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * tmpvar_8.xyz);
  float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * tmpvar_14.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_36;
  tmpvar_36 = max (0.0, dot (tmpvar_5, tmpvar_3));
  float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  vec4 tmpvar_38;
  tmpvar_38.xyz = ((((tmpvar_13 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + ((((((_LightColor0.xyz * tmpvar_25) * pow (max (0.0, dot (tmpvar_11, tmpvar_5)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_10))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_37)) + tmpvar_37) * ((tmpvar_36 * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_24 + 8.0) / 25.1327)) + (clamp (((textureCubeLod (_IBL, tmpvar_5, 2.0).xyz * _IBLAmt) + (textureCube (_Reflection, tmpvar_6).xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_35 + ((1.0 - tmpvar_35) * (pow ((1.0 - tmpvar_36), 5.0) / (4.0 - (3.0 * tmpvar_23)))))))) + tmpvar_22);
  tmpvar_38.w = ((_Opacity * -1.0) + 1.0);
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture2D (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureCubeLodEXT (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = textureCube (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp samplerCube _IBL;
uniform lowp samplerCube _Reflection;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _RimFalloff;
uniform highp vec4 _RimColor;
uniform highp float _ReflectionAmt;
uniform highp float _IBLAmt;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec3 lightDirection_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  highp vec3 tmpvar_12;
  highp vec3 i_13;
  i_13 = -(tmpvar_8);
  tmpvar_12 = (i_13 - (2.0 * (dot (tmpvar_11, i_13) * tmpvar_11)));
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_14 = texture (_MainTex, P_15);
  node_335_4 = tmpvar_14;
  highp float x_16;
  x_16 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_16 < 0.0)) {
    discard;
  };
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize(_WorldSpaceLightPos0.xyz);
  lightDirection_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_8 + lightDirection_3));
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, lightDirection_3);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((max (0.0, tmpvar_19) * 0.31831) * _LightColor0.xyz) + (glstate_lightmodel_ambient.xyz * 2.0));
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  bvec3 tmpvar_23;
  highp vec3 arg0_24;
  arg0_24 = (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz);
  tmpvar_23 = greaterThan (arg0_24, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * ((pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz) - 0.5))) * (1.0 - node_42_2.z)));
  highp vec3 c_26;
  c_26 = ((2.0 * (pow ((1.0 - max (0.0, dot (tmpvar_11, tmpvar_8))), _RimFalloff) * _RimColor.xyz)) * node_42_2.z);
  highp float tmpvar_27;
  if (tmpvar_23.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_23.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_23.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp float tmpvar_32;
  tmpvar_32 = mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness);
  highp float tmpvar_33;
  tmpvar_33 = exp2(((tmpvar_32 * 10.0) + 1.0));
  highp float tmpvar_34;
  tmpvar_34 = max (0.0, tmpvar_19);
  highp float tmpvar_35;
  tmpvar_35 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_36;
  tmpvar_36 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_37;
  b_37 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_38;
  c_38 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_39;
  if (tmpvar_36.x) {
    tmpvar_39 = b_37.x;
  } else {
    tmpvar_39 = c_38.x;
  };
  highp float tmpvar_40;
  if (tmpvar_36.y) {
    tmpvar_40 = b_37.y;
  } else {
    tmpvar_40 = c_38.y;
  };
  highp float tmpvar_41;
  if (tmpvar_36.z) {
    tmpvar_41 = b_37.z;
  } else {
    tmpvar_41 = c_38.z;
  };
  highp vec3 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = tmpvar_40;
  tmpvar_42.z = tmpvar_41;
  highp vec3 tmpvar_43;
  tmpvar_43 = clamp (tmpvar_42, 0.0, 1.0);
  highp vec3 tmpvar_44;
  tmpvar_44 = clamp (((tmpvar_35 * 0.2) + clamp ((tmpvar_43 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_45;
  tmpvar_45 = max (0.0, dot (tmpvar_11, tmpvar_8));
  highp float tmpvar_46;
  tmpvar_46 = inversesqrt(((0.785398 * tmpvar_33) + 1.5708));
  lowp vec4 tmpvar_47;
  tmpvar_47 = textureLod (_IBL, tmpvar_11, 2.0);
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_Reflection, tmpvar_12);
  highp vec4 tmpvar_49;
  tmpvar_49.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_44, vec3(0.3, 0.59, 0.11)))) * (tmpvar_43 * tmpvar_35)) + ((((((_LightColor0.xyz * tmpvar_34) * pow (max (0.0, dot (tmpvar_18, tmpvar_11)), tmpvar_33)) * (tmpvar_44 + ((1.0 - tmpvar_44) * pow ((1.0 - max (0.0, dot (tmpvar_18, lightDirection_3))), 5.0)))) * (1.0/((((tmpvar_34 * (1.0 - tmpvar_46)) + tmpvar_46) * ((tmpvar_45 * (1.0 - tmpvar_46)) + tmpvar_46))))) * ((tmpvar_33 + 8.0) / 25.1327)) + (clamp (((tmpvar_47.xyz * _IBLAmt) + (tmpvar_48.xyz * _ReflectionAmt)), 0.0, 1.0) * (tmpvar_44 + ((1.0 - tmpvar_44) * (pow ((1.0 - tmpvar_45), 5.0) / (4.0 - (3.0 * tmpvar_32)))))))) + tmpvar_31);
  tmpvar_49.w = ((_Opacity * -1.0) + 1.0);
  tmpvar_1 = tmpvar_49;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 121 math, 7 textures
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_LightColor0]
Vector 4 [_Diffuse]
Vector 5 [_MetRoughLum_ST]
Vector 6 [_MainTex_ST]
Vector 7 [_BumpTex_ST]
Float 8 [_DiffuseHasAlphaclip]
Float 9 [_DiffuseHasRoughness]
Float 10 [_RimFalloff]
Vector 11 [_RimColor]
Float 12 [_ReflectionAmt]
Float 13 [_IBLAmt]
Float 14 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 2
SetTexture 3 [_IBL] CUBE 3
SetTexture 4 [_Reflection] CUBE 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c15, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c16, 2.00000000, -1.00000000, 0.31830987, -0.50000000
def c17, 2.00000000, 1.00000000, 0.20000000, 10.00000000
def c18, 0.30000001, 0.58999997, 0.11000000, 8.00000000
def c19, 5.00000000, 0.78539819, 1.57079637, 0.03978873
def c20, 3.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r2, r0, s1
mul r1.xyz, r2, c4
mov r0.xyz, c4
add r0.xyz, c16.w, r0
add r3.xyz, -r2, c15.w
mad r2.xyz, -r0, c17.x, c17.y
mad_sat r2.xyz, -r2, r3, c15.w
mul_sat r1.xyz, r1, c16.x
cmp r3.xyz, -r0, r1, r2
mad r0.xy, v0, c7, c7.zwzw
texld r0.yw, r0, s0
mad_pp r2.xy, r0.wyzw, c16.x, c16.y
mad r1.xy, v0, c5, c5.zwzw
texld r9.xyz, r1, s2
mul r0.xyz, r2.y, v4
mul_sat r1.xyz, r9.x, r3
add r3.w, -r9.x, c15
mad_sat r4.xyz, r3.w, c17.z, r1
mad r1.xyz, r2.x, v3, r0
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c15.w
rsq_pp r0.w, r0.x
dp3 r0.y, v2, v2
rsq r0.y, r0.y
mul r0.xyz, r0.y, v2
rcp_pp r0.w, r0.w
mad r1.xyz, r0.w, r0, r1
add r2.xyz, -v1, c1
dp3 r0.y, r2, r2
dp3 r0.x, r1, r1
rsq r0.w, r0.x
rsq r0.y, r0.y
mul r1.xyz, r0.w, r1
mul r0.xyz, r0.y, r2
dp3 r0.w, r1, r0
add r1.w, -r9.y, c15
max r4.w, r0, c15.z
add r2.x, r2.w, -r1.w
mad r7.w, r2.x, c9.x, r1
add r6.w, -r4, c15
pow r5, r6.w, c19.x
mov r2.x, r5
mad r1.w, -r7, c20.x, c20.y
rcp r1.w, r1.w
mul r1.w, r2.x, r1
mul r2.xyz, r1, -r0.w
add r5.xyz, -r4, c15.w
mad r8.xyz, r5, r1.w, r4
mad r6.xyz, -r2, c16.x, -r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, c2
add r0.xyz, r2, r0
texld r6.xyz, r6, s4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r2, r0
dp3 r0.x, r1, r0
mul r7.xyz, r6, c12.x
mov r1.w, c16.x
texldl r6.xyz, r1, s3
mad_sat r6.xyz, r6, c13.x, r7
max r0.w, r0, c15.z
add r1.w, -r0, c15
max r5.w, r0.x, c15.z
pow r0, r1.w, c19.x
mad r0.y, r7.w, c17.w, c17
mov r7.x, r0
exp r1.w, r0.y
pow r0, r5.w, r1.w
mov r0.w, r0.x
dp3 r0.x, r1, r2
mad r0.y, r1.w, c19, c19.z
rsq r0.y, r0.y
add r0.z, -r0.y, c15.w
mad r1.x, r0.z, r4.w, r0.y
max r0.x, r0, c15.z
mad r0.y, r0.x, r0.z, r0
mul r2.x, r0.y, r1
mul r0.xyz, r0.x, c3
mul r1.xyz, r0, r0.w
rcp r0.w, r2.x
mad r5.xyz, r5, r7.x, r4
mul r1.xyz, r1, r5
mul r1.xyz, r1, r0.w
add r0.w, r1, c18
mul r1.xyz, r0.w, r1
dp3 r0.w, r4, c18
mul r6.xyz, r6, r8
mad r4.xyz, r1, c19.w, r6
pow r1, r6.w, c10.x
mov r2.xyz, c0
mul r2.xyz, c16.x, r2
mad r0.xyz, r0, c16.z, r2
add r0.w, -r0, c15
mul r0.xyz, r0, r0.w
mov r0.w, r1.x
mul r2.xyz, r3.w, r3
mul r1.xyz, r0.w, c11
mad r0.xyz, r0, r2, r4
mul r2.xyz, r9.z, r1
add r1.xyz, r1, c16.w
add r0.w, r2, c15.x
mul r0.w, r0, c8.x
add r0.w, r0, c15.y
mad r3.xyz, -r1, c17.x, c17.y
add r1.w, -r9.z, c15
mul_sat r2.xyz, r2, c16.x
mad_sat r3.xyz, -r3, r1.w, c15.w
cmp r1.xyz, -r1, r2, r3
add oC0.xyz, r0, r1
cmp r0.w, r0, c15.z, c15
mov_pp r0, -r0.w
mov r1.x, c14
texkill r0.xyzw
add oC0.w, c15, -r1.x
"
}
SubProgram "d3d11 " {
// Stats: 110 math, 4 textures
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 0
SetTexture 3 [_IBL] CUBE 2
SetTexture 4 [_Reflection] CUBE 3
ConstBuffer "$Globals" 144
Vector 16 [_LightColor0]
Vector 32 [_Diffuse]
Vector 48 [_MetRoughLum_ST]
Vector 64 [_MainTex_ST]
Vector 80 [_BumpTex_ST]
Float 96 [_DiffuseHasAlphaclip]
Float 100 [_DiffuseHasRoughness]
Float 104 [_RimFalloff]
Vector 112 [_RimColor]
Float 128 [_ReflectionAmt]
Float 132 [_IBLAmt]
Float 136 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerFrame" 208
Vector 64 [glstate_lightmodel_ambient]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerFrame" 3
"ps_4_0
eefiecedhaihpmlfdajnnpmgableflmkbpodfehfabaaaaaagmbbaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcembaaaaa
eaaaaaaabdaeaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaaafaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
alaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaajbcaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhcaabaaa
acaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaa
acaaaaaaaaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaia
ebaaaaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaia
ebaaaaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaan
hcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaaegiccaaaaaaaaaaaacaaaaaadhcaaaajhcaabaaa
aaaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
dcaabaaaaeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaa
aaaaaaaaadaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaa
acaaaaaaaagabaaaaaaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaa
agaabaaaaeaaaaaaaaaaaaallcaabaaaaeaaaaaaggacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaiadpdccaaaamhcaabaaaafaaaaaa
pgapbaaaaeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaa
afaaaaaaaaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaahaaaaaaegacbaaa
agaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaaegbcbaaaadaaaaaa
dcaaaaaldcaabaaaajaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaajaaaaaaegaabaaaajaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaajaaaaaahgapbaaa
ajaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadiaaaaahhcaabaaaakaaaaaafgafbaaaajaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaakaaaaaaagaabaaaajaaaaaaegbcbaaa
aeaaaaaaegacbaaaakaaaaaaapaaaaahicaabaaaabaaaaaaegaabaaaajaaaaaa
egaabaaaajaaaaaaddaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaa
aiaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaakaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaaiaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaa
egacbaaaaiaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
aiaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaabkaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaaaaaaaaabkaabaaaaeaaaaaadcaaaaaj
icaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
dcaaaaakicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaeaea
abeaaaaaaaaaiaeabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaiaaaaaa
egacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahocaabaaaabaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaa
diaaaaahocaabaaaabaaaaaaagajbaaaahaaaaaafgaobaaaabaaaaaabaaaaaah
bcaabaaaadaaaaaaegacbaaaaiaaaaaaegacbaaaacaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaidpjccdnelaaaaafccaabaaaadaaaaaabkaabaaa
adaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkaabaaaadaaaaaaaaaaaaaiecaabaaaadaaaaaabkaabaiaebaaaaaa
adaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaadaaaaaaakaabaaaadaaaaaa
ckaabaaaadaaaaaabkaabaaaadaaaaaaaaaaaaaibcaabaaaadaaaaaaakaabaia
ebaaaaaaadaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaadaaaaaaakaabaaa
abaaaaaackaabaaaadaaaaaabkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahccaabaaaadaaaaaadkaabaaa
adaaaaaabkaabaaaadaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkaabaaaadaaaaaadiaaaaahocaabaaaabaaaaaa
fgaobaaaabaaaaaafgafbaaaadaaaaaabaaaaaaiccaabaaaadaaaaaaegacbaia
ebaaaaaaacaaaaaaegacbaaaaiaaaaaaaaaaaaahccaabaaaadaaaaaabkaabaaa
adaaaaaabkaabaaaadaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaaiaaaaaa
fgafbaiaebaaaaaaadaaaaaaegacbaiaebaaaaaaacaaaaaaeiaaaaalpcaabaaa
ahaaaaaaegacbaaaaiaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaeaefaaaaajpcaabaaaaiaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaa
aagabaaaadaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaiaaaaaaagiacaaa
aaaaaaaaaiaaaaaadccaaaakhcaabaaaacaaaaaaegacbaaaahaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegacbaaaacaaaaaadiaaaaahccaabaaaadaaaaaaakaabaaa
adaaaaaaakaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaa
bkaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaaakaabaaa
adaaaaaacpaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaadaaaaaackiacaaaaaaaaaaaagaaaaaabjaaaaafbcaabaaa
adaaaaaaakaabaaaadaaaaaaaoaaaaahicaabaaaaaaaaaaabkaabaaaadaaaaaa
dkaabaaaaaaaaaaadcaaaaajocaabaaaadaaaaaaagajbaaaagaaaaaapgapbaaa
aaaaaaaaagajbaaaafaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaajgahbaaaadaaaaaadcaaaaajocaabaaaabaaaaaafgaobaaa
abaaaaaapgapbaaaacaaaaaaagajbaaaacaaaaaaaaaaaaajhcaabaaaacaaaaaa
egiccaaaadaaaaaaaeaaaaaaegiccaaaadaaaaaaaeaaaaaadcaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaabaaaaaadcaaaaan
hcaabaaaabaaaaaaagaabaaaadaaaaaaegiccaaaaaaaaaaaahaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaa
adaaaaaaegiccaaaaaaaaaaaahaaaaaadcaaaabahcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaagaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaakgakbaaaaeaaaaaa
dbaaaaakhcaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadhcaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaaaaaaaajiccabaaaaaaaaaaackiacaiaebaaaaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 121 math, 7 textures
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_LightColor0]
Vector 4 [_Diffuse]
Vector 5 [_MetRoughLum_ST]
Vector 6 [_MainTex_ST]
Vector 7 [_BumpTex_ST]
Float 8 [_DiffuseHasAlphaclip]
Float 9 [_DiffuseHasRoughness]
Float 10 [_RimFalloff]
Vector 11 [_RimColor]
Float 12 [_ReflectionAmt]
Float 13 [_IBLAmt]
Float 14 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 2
SetTexture 3 [_IBL] CUBE 3
SetTexture 4 [_Reflection] CUBE 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c15, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c16, 2.00000000, -1.00000000, 0.31830987, -0.50000000
def c17, 2.00000000, 1.00000000, 0.20000000, 10.00000000
def c18, 0.30000001, 0.58999997, 0.11000000, 8.00000000
def c19, 5.00000000, 0.78539819, 1.57079637, 0.03978873
def c20, 3.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r2, r0, s1
mul r1.xyz, r2, c4
mov r0.xyz, c4
add r0.xyz, c16.w, r0
add r3.xyz, -r2, c15.w
mad r2.xyz, -r0, c17.x, c17.y
mad_sat r2.xyz, -r2, r3, c15.w
mul_sat r1.xyz, r1, c16.x
cmp r3.xyz, -r0, r1, r2
mad r0.xy, v0, c7, c7.zwzw
texld r0.yw, r0, s0
mad_pp r2.xy, r0.wyzw, c16.x, c16.y
mad r1.xy, v0, c5, c5.zwzw
texld r9.xyz, r1, s2
mul r0.xyz, r2.y, v4
mul_sat r1.xyz, r9.x, r3
add r3.w, -r9.x, c15
mad_sat r4.xyz, r3.w, c17.z, r1
mad r1.xyz, r2.x, v3, r0
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c15.w
rsq_pp r0.w, r0.x
dp3 r0.y, v2, v2
rsq r0.y, r0.y
mul r0.xyz, r0.y, v2
rcp_pp r0.w, r0.w
mad r1.xyz, r0.w, r0, r1
add r2.xyz, -v1, c1
dp3 r0.y, r2, r2
dp3 r0.x, r1, r1
rsq r0.w, r0.x
rsq r0.y, r0.y
mul r1.xyz, r0.w, r1
mul r0.xyz, r0.y, r2
dp3 r0.w, r1, r0
add r1.w, -r9.y, c15
max r4.w, r0, c15.z
add r2.x, r2.w, -r1.w
mad r7.w, r2.x, c9.x, r1
add r6.w, -r4, c15
pow r5, r6.w, c19.x
mov r2.x, r5
mad r1.w, -r7, c20.x, c20.y
rcp r1.w, r1.w
mul r1.w, r2.x, r1
mul r2.xyz, r1, -r0.w
add r5.xyz, -r4, c15.w
mad r8.xyz, r5, r1.w, r4
mad r6.xyz, -r2, c16.x, -r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, c2
add r0.xyz, r2, r0
texld r6.xyz, r6, s4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r2, r0
dp3 r0.x, r1, r0
mul r7.xyz, r6, c12.x
mov r1.w, c16.x
texldl r6.xyz, r1, s3
mad_sat r6.xyz, r6, c13.x, r7
max r0.w, r0, c15.z
add r1.w, -r0, c15
max r5.w, r0.x, c15.z
pow r0, r1.w, c19.x
mad r0.y, r7.w, c17.w, c17
mov r7.x, r0
exp r1.w, r0.y
pow r0, r5.w, r1.w
mov r0.w, r0.x
dp3 r0.x, r1, r2
mad r0.y, r1.w, c19, c19.z
rsq r0.y, r0.y
add r0.z, -r0.y, c15.w
mad r1.x, r0.z, r4.w, r0.y
max r0.x, r0, c15.z
mad r0.y, r0.x, r0.z, r0
mul r2.x, r0.y, r1
mul r0.xyz, r0.x, c3
mul r1.xyz, r0, r0.w
rcp r0.w, r2.x
mad r5.xyz, r5, r7.x, r4
mul r1.xyz, r1, r5
mul r1.xyz, r1, r0.w
add r0.w, r1, c18
mul r1.xyz, r0.w, r1
dp3 r0.w, r4, c18
mul r6.xyz, r6, r8
mad r4.xyz, r1, c19.w, r6
pow r1, r6.w, c10.x
mov r2.xyz, c0
mul r2.xyz, c16.x, r2
mad r0.xyz, r0, c16.z, r2
add r0.w, -r0, c15
mul r0.xyz, r0, r0.w
mov r0.w, r1.x
mul r2.xyz, r3.w, r3
mul r1.xyz, r0.w, c11
mad r0.xyz, r0, r2, r4
mul r2.xyz, r9.z, r1
add r1.xyz, r1, c16.w
add r0.w, r2, c15.x
mul r0.w, r0, c8.x
add r0.w, r0, c15.y
mad r3.xyz, -r1, c17.x, c17.y
add r1.w, -r9.z, c15
mul_sat r2.xyz, r2, c16.x
mad_sat r3.xyz, -r3, r1.w, c15.w
cmp r1.xyz, -r1, r2, r3
add oC0.xyz, r0, r1
cmp r0.w, r0, c15.z, c15
mov_pp r0, -r0.w
mov r1.x, c14
texkill r0.xyzw
add oC0.w, c15, -r1.x
"
}
SubProgram "d3d11 " {
// Stats: 110 math, 4 textures
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 0
SetTexture 3 [_IBL] CUBE 2
SetTexture 4 [_Reflection] CUBE 3
ConstBuffer "$Globals" 144
Vector 16 [_LightColor0]
Vector 32 [_Diffuse]
Vector 48 [_MetRoughLum_ST]
Vector 64 [_MainTex_ST]
Vector 80 [_BumpTex_ST]
Float 96 [_DiffuseHasAlphaclip]
Float 100 [_DiffuseHasRoughness]
Float 104 [_RimFalloff]
Vector 112 [_RimColor]
Float 128 [_ReflectionAmt]
Float 132 [_IBLAmt]
Float 136 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerFrame" 208
Vector 64 [glstate_lightmodel_ambient]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerFrame" 3
"ps_4_0
eefiecedhaihpmlfdajnnpmgableflmkbpodfehfabaaaaaagmbbaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcembaaaaa
eaaaaaaabdaeaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaaafaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
alaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaajbcaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhcaabaaa
acaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaa
acaaaaaaaaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaia
ebaaaaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaia
ebaaaaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaan
hcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaaegiccaaaaaaaaaaaacaaaaaadhcaaaajhcaabaaa
aaaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
dcaabaaaaeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaa
aaaaaaaaadaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaa
acaaaaaaaagabaaaaaaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaa
agaabaaaaeaaaaaaaaaaaaallcaabaaaaeaaaaaaggacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaiadpdccaaaamhcaabaaaafaaaaaa
pgapbaaaaeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaa
afaaaaaaaaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaahaaaaaaegacbaaa
agaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaaegbcbaaaadaaaaaa
dcaaaaaldcaabaaaajaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaajaaaaaaegaabaaaajaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaajaaaaaahgapbaaa
ajaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadiaaaaahhcaabaaaakaaaaaafgafbaaaajaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaakaaaaaaagaabaaaajaaaaaaegbcbaaa
aeaaaaaaegacbaaaakaaaaaaapaaaaahicaabaaaabaaaaaaegaabaaaajaaaaaa
egaabaaaajaaaaaaddaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaa
aiaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaakaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaaiaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaa
egacbaaaaiaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
aiaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaabkaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaaaaaaaaabkaabaaaaeaaaaaadcaaaaaj
icaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
dcaaaaakicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaeaea
abeaaaaaaaaaiaeabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaiaaaaaa
egacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahocaabaaaabaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaa
diaaaaahocaabaaaabaaaaaaagajbaaaahaaaaaafgaobaaaabaaaaaabaaaaaah
bcaabaaaadaaaaaaegacbaaaaiaaaaaaegacbaaaacaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaidpjccdnelaaaaafccaabaaaadaaaaaabkaabaaa
adaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkaabaaaadaaaaaaaaaaaaaiecaabaaaadaaaaaabkaabaiaebaaaaaa
adaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaadaaaaaaakaabaaaadaaaaaa
ckaabaaaadaaaaaabkaabaaaadaaaaaaaaaaaaaibcaabaaaadaaaaaaakaabaia
ebaaaaaaadaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaadaaaaaaakaabaaa
abaaaaaackaabaaaadaaaaaabkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahccaabaaaadaaaaaadkaabaaa
adaaaaaabkaabaaaadaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkaabaaaadaaaaaadiaaaaahocaabaaaabaaaaaa
fgaobaaaabaaaaaafgafbaaaadaaaaaabaaaaaaiccaabaaaadaaaaaaegacbaia
ebaaaaaaacaaaaaaegacbaaaaiaaaaaaaaaaaaahccaabaaaadaaaaaabkaabaaa
adaaaaaabkaabaaaadaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaaiaaaaaa
fgafbaiaebaaaaaaadaaaaaaegacbaiaebaaaaaaacaaaaaaeiaaaaalpcaabaaa
ahaaaaaaegacbaaaaiaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaeaefaaaaajpcaabaaaaiaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaa
aagabaaaadaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaiaaaaaaagiacaaa
aaaaaaaaaiaaaaaadccaaaakhcaabaaaacaaaaaaegacbaaaahaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegacbaaaacaaaaaadiaaaaahccaabaaaadaaaaaaakaabaaa
adaaaaaaakaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaa
bkaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaaakaabaaa
adaaaaaacpaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaadaaaaaackiacaaaaaaaaaaaagaaaaaabjaaaaafbcaabaaa
adaaaaaaakaabaaaadaaaaaaaoaaaaahicaabaaaaaaaaaaabkaabaaaadaaaaaa
dkaabaaaaaaaaaaadcaaaaajocaabaaaadaaaaaaagajbaaaagaaaaaapgapbaaa
aaaaaaaaagajbaaaafaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaajgahbaaaadaaaaaadcaaaaajocaabaaaabaaaaaafgaobaaa
abaaaaaapgapbaaaacaaaaaaagajbaaaacaaaaaaaaaaaaajhcaabaaaacaaaaaa
egiccaaaadaaaaaaaeaaaaaaegiccaaaadaaaaaaaeaaaaaadcaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaabaaaaaadcaaaaan
hcaabaaaabaaaaaaagaabaaaadaaaaaaegiccaaaaaaaaaaaahaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaa
adaaaaaaegiccaaaaaaaaaaaahaaaaaadcaaaabahcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaagaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaakgakbaaaaeaaaaaa
dbaaaaakhcaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadhcaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaaaaaaaajiccabaaaaaaaaaaackiacaiaebaaaaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 121 math, 7 textures
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_LightColor0]
Vector 4 [_Diffuse]
Vector 5 [_MetRoughLum_ST]
Vector 6 [_MainTex_ST]
Vector 7 [_BumpTex_ST]
Float 8 [_DiffuseHasAlphaclip]
Float 9 [_DiffuseHasRoughness]
Float 10 [_RimFalloff]
Vector 11 [_RimColor]
Float 12 [_ReflectionAmt]
Float 13 [_IBLAmt]
Float 14 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 2
SetTexture 3 [_IBL] CUBE 3
SetTexture 4 [_Reflection] CUBE 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c15, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c16, 2.00000000, -1.00000000, 0.31830987, -0.50000000
def c17, 2.00000000, 1.00000000, 0.20000000, 10.00000000
def c18, 0.30000001, 0.58999997, 0.11000000, 8.00000000
def c19, 5.00000000, 0.78539819, 1.57079637, 0.03978873
def c20, 3.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r2, r0, s1
mul r1.xyz, r2, c4
mov r0.xyz, c4
add r0.xyz, c16.w, r0
add r3.xyz, -r2, c15.w
mad r2.xyz, -r0, c17.x, c17.y
mad_sat r2.xyz, -r2, r3, c15.w
mul_sat r1.xyz, r1, c16.x
cmp r3.xyz, -r0, r1, r2
mad r0.xy, v0, c7, c7.zwzw
texld r0.yw, r0, s0
mad_pp r2.xy, r0.wyzw, c16.x, c16.y
mad r1.xy, v0, c5, c5.zwzw
texld r9.xyz, r1, s2
mul r0.xyz, r2.y, v4
mul_sat r1.xyz, r9.x, r3
add r3.w, -r9.x, c15
mad_sat r4.xyz, r3.w, c17.z, r1
mad r1.xyz, r2.x, v3, r0
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c15.w
rsq_pp r0.w, r0.x
dp3 r0.y, v2, v2
rsq r0.y, r0.y
mul r0.xyz, r0.y, v2
rcp_pp r0.w, r0.w
mad r1.xyz, r0.w, r0, r1
add r2.xyz, -v1, c1
dp3 r0.y, r2, r2
dp3 r0.x, r1, r1
rsq r0.w, r0.x
rsq r0.y, r0.y
mul r1.xyz, r0.w, r1
mul r0.xyz, r0.y, r2
dp3 r0.w, r1, r0
add r1.w, -r9.y, c15
max r4.w, r0, c15.z
add r2.x, r2.w, -r1.w
mad r7.w, r2.x, c9.x, r1
add r6.w, -r4, c15
pow r5, r6.w, c19.x
mov r2.x, r5
mad r1.w, -r7, c20.x, c20.y
rcp r1.w, r1.w
mul r1.w, r2.x, r1
mul r2.xyz, r1, -r0.w
add r5.xyz, -r4, c15.w
mad r8.xyz, r5, r1.w, r4
mad r6.xyz, -r2, c16.x, -r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, c2
add r0.xyz, r2, r0
texld r6.xyz, r6, s4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r2, r0
dp3 r0.x, r1, r0
mul r7.xyz, r6, c12.x
mov r1.w, c16.x
texldl r6.xyz, r1, s3
mad_sat r6.xyz, r6, c13.x, r7
max r0.w, r0, c15.z
add r1.w, -r0, c15
max r5.w, r0.x, c15.z
pow r0, r1.w, c19.x
mad r0.y, r7.w, c17.w, c17
mov r7.x, r0
exp r1.w, r0.y
pow r0, r5.w, r1.w
mov r0.w, r0.x
dp3 r0.x, r1, r2
mad r0.y, r1.w, c19, c19.z
rsq r0.y, r0.y
add r0.z, -r0.y, c15.w
mad r1.x, r0.z, r4.w, r0.y
max r0.x, r0, c15.z
mad r0.y, r0.x, r0.z, r0
mul r2.x, r0.y, r1
mul r0.xyz, r0.x, c3
mul r1.xyz, r0, r0.w
rcp r0.w, r2.x
mad r5.xyz, r5, r7.x, r4
mul r1.xyz, r1, r5
mul r1.xyz, r1, r0.w
add r0.w, r1, c18
mul r1.xyz, r0.w, r1
dp3 r0.w, r4, c18
mul r6.xyz, r6, r8
mad r4.xyz, r1, c19.w, r6
pow r1, r6.w, c10.x
mov r2.xyz, c0
mul r2.xyz, c16.x, r2
mad r0.xyz, r0, c16.z, r2
add r0.w, -r0, c15
mul r0.xyz, r0, r0.w
mov r0.w, r1.x
mul r2.xyz, r3.w, r3
mul r1.xyz, r0.w, c11
mad r0.xyz, r0, r2, r4
mul r2.xyz, r9.z, r1
add r1.xyz, r1, c16.w
add r0.w, r2, c15.x
mul r0.w, r0, c8.x
add r0.w, r0, c15.y
mad r3.xyz, -r1, c17.x, c17.y
add r1.w, -r9.z, c15
mul_sat r2.xyz, r2, c16.x
mad_sat r3.xyz, -r3, r1.w, c15.w
cmp r1.xyz, -r1, r2, r3
add oC0.xyz, r0, r1
cmp r0.w, r0, c15.z, c15
mov_pp r0, -r0.w
mov r1.x, c14
texkill r0.xyzw
add oC0.w, c15, -r1.x
"
}
SubProgram "d3d11 " {
// Stats: 110 math, 4 textures
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 0
SetTexture 3 [_IBL] CUBE 2
SetTexture 4 [_Reflection] CUBE 3
ConstBuffer "$Globals" 144
Vector 16 [_LightColor0]
Vector 32 [_Diffuse]
Vector 48 [_MetRoughLum_ST]
Vector 64 [_MainTex_ST]
Vector 80 [_BumpTex_ST]
Float 96 [_DiffuseHasAlphaclip]
Float 100 [_DiffuseHasRoughness]
Float 104 [_RimFalloff]
Vector 112 [_RimColor]
Float 128 [_ReflectionAmt]
Float 132 [_IBLAmt]
Float 136 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerFrame" 208
Vector 64 [glstate_lightmodel_ambient]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerFrame" 3
"ps_4_0
eefiecedhaihpmlfdajnnpmgableflmkbpodfehfabaaaaaagmbbaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcembaaaaa
eaaaaaaabdaeaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaaafaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
alaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaajbcaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhcaabaaa
acaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaa
acaaaaaaaaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaia
ebaaaaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaia
ebaaaaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaan
hcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaaegiccaaaaaaaaaaaacaaaaaadhcaaaajhcaabaaa
aaaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
dcaabaaaaeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaa
aaaaaaaaadaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaa
acaaaaaaaagabaaaaaaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaa
agaabaaaaeaaaaaaaaaaaaallcaabaaaaeaaaaaaggacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaiadpdccaaaamhcaabaaaafaaaaaa
pgapbaaaaeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaa
afaaaaaaaaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaahaaaaaaegacbaaa
agaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaaegbcbaaaadaaaaaa
dcaaaaaldcaabaaaajaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaajaaaaaaegaabaaaajaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaajaaaaaahgapbaaa
ajaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadiaaaaahhcaabaaaakaaaaaafgafbaaaajaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaakaaaaaaagaabaaaajaaaaaaegbcbaaa
aeaaaaaaegacbaaaakaaaaaaapaaaaahicaabaaaabaaaaaaegaabaaaajaaaaaa
egaabaaaajaaaaaaddaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaa
aiaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaakaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaaiaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaa
egacbaaaaiaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
aiaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaabkaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaaaaaaaaabkaabaaaaeaaaaaadcaaaaaj
icaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
dcaaaaakicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaeaea
abeaaaaaaaaaiaeabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaiaaaaaa
egacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahocaabaaaabaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaa
diaaaaahocaabaaaabaaaaaaagajbaaaahaaaaaafgaobaaaabaaaaaabaaaaaah
bcaabaaaadaaaaaaegacbaaaaiaaaaaaegacbaaaacaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaidpjccdnelaaaaafccaabaaaadaaaaaabkaabaaa
adaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkaabaaaadaaaaaaaaaaaaaiecaabaaaadaaaaaabkaabaiaebaaaaaa
adaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaadaaaaaaakaabaaaadaaaaaa
ckaabaaaadaaaaaabkaabaaaadaaaaaaaaaaaaaibcaabaaaadaaaaaaakaabaia
ebaaaaaaadaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaadaaaaaaakaabaaa
abaaaaaackaabaaaadaaaaaabkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahccaabaaaadaaaaaadkaabaaa
adaaaaaabkaabaaaadaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkaabaaaadaaaaaadiaaaaahocaabaaaabaaaaaa
fgaobaaaabaaaaaafgafbaaaadaaaaaabaaaaaaiccaabaaaadaaaaaaegacbaia
ebaaaaaaacaaaaaaegacbaaaaiaaaaaaaaaaaaahccaabaaaadaaaaaabkaabaaa
adaaaaaabkaabaaaadaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaaiaaaaaa
fgafbaiaebaaaaaaadaaaaaaegacbaiaebaaaaaaacaaaaaaeiaaaaalpcaabaaa
ahaaaaaaegacbaaaaiaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaeaefaaaaajpcaabaaaaiaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaa
aagabaaaadaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaiaaaaaaagiacaaa
aaaaaaaaaiaaaaaadccaaaakhcaabaaaacaaaaaaegacbaaaahaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegacbaaaacaaaaaadiaaaaahccaabaaaadaaaaaaakaabaaa
adaaaaaaakaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaa
bkaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaaakaabaaa
adaaaaaacpaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaadaaaaaackiacaaaaaaaaaaaagaaaaaabjaaaaafbcaabaaa
adaaaaaaakaabaaaadaaaaaaaoaaaaahicaabaaaaaaaaaaabkaabaaaadaaaaaa
dkaabaaaaaaaaaaadcaaaaajocaabaaaadaaaaaaagajbaaaagaaaaaapgapbaaa
aaaaaaaaagajbaaaafaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaajgahbaaaadaaaaaadcaaaaajocaabaaaabaaaaaafgaobaaa
abaaaaaapgapbaaaacaaaaaaagajbaaaacaaaaaaaaaaaaajhcaabaaaacaaaaaa
egiccaaaadaaaaaaaeaaaaaaegiccaaaadaaaaaaaeaaaaaadcaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaabaaaaaadcaaaaan
hcaabaaaabaaaaaaagaabaaaadaaaaaaegiccaaaaaaaaaaaahaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaa
adaaaaaaegiccaaaaaaaaaaaahaaaaaadcaaaabahcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaagaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaakgakbaaaaeaaaaaa
dbaaaaakhcaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadhcaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaaaaaaaajiccabaaaaaaaaaaackiacaiaebaaaaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 121 math, 7 textures
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_LightColor0]
Vector 4 [_Diffuse]
Vector 5 [_MetRoughLum_ST]
Vector 6 [_MainTex_ST]
Vector 7 [_BumpTex_ST]
Float 8 [_DiffuseHasAlphaclip]
Float 9 [_DiffuseHasRoughness]
Float 10 [_RimFalloff]
Vector 11 [_RimColor]
Float 12 [_ReflectionAmt]
Float 13 [_IBLAmt]
Float 14 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 2
SetTexture 3 [_IBL] CUBE 3
SetTexture 4 [_Reflection] CUBE 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c15, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c16, 2.00000000, -1.00000000, 0.31830987, -0.50000000
def c17, 2.00000000, 1.00000000, 0.20000000, 10.00000000
def c18, 0.30000001, 0.58999997, 0.11000000, 8.00000000
def c19, 5.00000000, 0.78539819, 1.57079637, 0.03978873
def c20, 3.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r2, r0, s1
mul r1.xyz, r2, c4
mov r0.xyz, c4
add r0.xyz, c16.w, r0
add r3.xyz, -r2, c15.w
mad r2.xyz, -r0, c17.x, c17.y
mad_sat r2.xyz, -r2, r3, c15.w
mul_sat r1.xyz, r1, c16.x
cmp r3.xyz, -r0, r1, r2
mad r0.xy, v0, c7, c7.zwzw
texld r0.yw, r0, s0
mad_pp r2.xy, r0.wyzw, c16.x, c16.y
mad r1.xy, v0, c5, c5.zwzw
texld r9.xyz, r1, s2
mul r0.xyz, r2.y, v4
mul_sat r1.xyz, r9.x, r3
add r3.w, -r9.x, c15
mad_sat r4.xyz, r3.w, c17.z, r1
mad r1.xyz, r2.x, v3, r0
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c15.w
rsq_pp r0.w, r0.x
dp3 r0.y, v2, v2
rsq r0.y, r0.y
mul r0.xyz, r0.y, v2
rcp_pp r0.w, r0.w
mad r1.xyz, r0.w, r0, r1
add r2.xyz, -v1, c1
dp3 r0.y, r2, r2
dp3 r0.x, r1, r1
rsq r0.w, r0.x
rsq r0.y, r0.y
mul r1.xyz, r0.w, r1
mul r0.xyz, r0.y, r2
dp3 r0.w, r1, r0
add r1.w, -r9.y, c15
max r4.w, r0, c15.z
add r2.x, r2.w, -r1.w
mad r7.w, r2.x, c9.x, r1
add r6.w, -r4, c15
pow r5, r6.w, c19.x
mov r2.x, r5
mad r1.w, -r7, c20.x, c20.y
rcp r1.w, r1.w
mul r1.w, r2.x, r1
mul r2.xyz, r1, -r0.w
add r5.xyz, -r4, c15.w
mad r8.xyz, r5, r1.w, r4
mad r6.xyz, -r2, c16.x, -r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, c2
add r0.xyz, r2, r0
texld r6.xyz, r6, s4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r2, r0
dp3 r0.x, r1, r0
mul r7.xyz, r6, c12.x
mov r1.w, c16.x
texldl r6.xyz, r1, s3
mad_sat r6.xyz, r6, c13.x, r7
max r0.w, r0, c15.z
add r1.w, -r0, c15
max r5.w, r0.x, c15.z
pow r0, r1.w, c19.x
mad r0.y, r7.w, c17.w, c17
mov r7.x, r0
exp r1.w, r0.y
pow r0, r5.w, r1.w
mov r0.w, r0.x
dp3 r0.x, r1, r2
mad r0.y, r1.w, c19, c19.z
rsq r0.y, r0.y
add r0.z, -r0.y, c15.w
mad r1.x, r0.z, r4.w, r0.y
max r0.x, r0, c15.z
mad r0.y, r0.x, r0.z, r0
mul r2.x, r0.y, r1
mul r0.xyz, r0.x, c3
mul r1.xyz, r0, r0.w
rcp r0.w, r2.x
mad r5.xyz, r5, r7.x, r4
mul r1.xyz, r1, r5
mul r1.xyz, r1, r0.w
add r0.w, r1, c18
mul r1.xyz, r0.w, r1
dp3 r0.w, r4, c18
mul r6.xyz, r6, r8
mad r4.xyz, r1, c19.w, r6
pow r1, r6.w, c10.x
mov r2.xyz, c0
mul r2.xyz, c16.x, r2
mad r0.xyz, r0, c16.z, r2
add r0.w, -r0, c15
mul r0.xyz, r0, r0.w
mov r0.w, r1.x
mul r2.xyz, r3.w, r3
mul r1.xyz, r0.w, c11
mad r0.xyz, r0, r2, r4
mul r2.xyz, r9.z, r1
add r1.xyz, r1, c16.w
add r0.w, r2, c15.x
mul r0.w, r0, c8.x
add r0.w, r0, c15.y
mad r3.xyz, -r1, c17.x, c17.y
add r1.w, -r9.z, c15
mul_sat r2.xyz, r2, c16.x
mad_sat r3.xyz, -r3, r1.w, c15.w
cmp r1.xyz, -r1, r2, r3
add oC0.xyz, r0, r1
cmp r0.w, r0, c15.z, c15
mov_pp r0, -r0.w
mov r1.x, c14
texkill r0.xyzw
add oC0.w, c15, -r1.x
"
}
SubProgram "d3d11 " {
// Stats: 110 math, 4 textures
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 0
SetTexture 3 [_IBL] CUBE 2
SetTexture 4 [_Reflection] CUBE 3
ConstBuffer "$Globals" 144
Vector 16 [_LightColor0]
Vector 32 [_Diffuse]
Vector 48 [_MetRoughLum_ST]
Vector 64 [_MainTex_ST]
Vector 80 [_BumpTex_ST]
Float 96 [_DiffuseHasAlphaclip]
Float 100 [_DiffuseHasRoughness]
Float 104 [_RimFalloff]
Vector 112 [_RimColor]
Float 128 [_ReflectionAmt]
Float 132 [_IBLAmt]
Float 136 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerFrame" 208
Vector 64 [glstate_lightmodel_ambient]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerFrame" 3
"ps_4_0
eefiecedhaihpmlfdajnnpmgableflmkbpodfehfabaaaaaagmbbaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcembaaaaa
eaaaaaaabdaeaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaaafaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
alaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaajbcaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhcaabaaa
acaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaa
acaaaaaaaaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaia
ebaaaaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaia
ebaaaaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaan
hcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaaegiccaaaaaaaaaaaacaaaaaadhcaaaajhcaabaaa
aaaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
dcaabaaaaeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaa
aaaaaaaaadaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaa
acaaaaaaaagabaaaaaaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaa
agaabaaaaeaaaaaaaaaaaaallcaabaaaaeaaaaaaggacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaiadpdccaaaamhcaabaaaafaaaaaa
pgapbaaaaeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaa
afaaaaaaaaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaahaaaaaaegacbaaa
agaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaaegbcbaaaadaaaaaa
dcaaaaaldcaabaaaajaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaajaaaaaaegaabaaaajaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaajaaaaaahgapbaaa
ajaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadiaaaaahhcaabaaaakaaaaaafgafbaaaajaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaakaaaaaaagaabaaaajaaaaaaegbcbaaa
aeaaaaaaegacbaaaakaaaaaaapaaaaahicaabaaaabaaaaaaegaabaaaajaaaaaa
egaabaaaajaaaaaaddaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaa
aiaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaakaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaaiaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaa
egacbaaaaiaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
aiaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaabkaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaaaaaaaaabkaabaaaaeaaaaaadcaaaaaj
icaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
dcaaaaakicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaeaea
abeaaaaaaaaaiaeabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaiaaaaaa
egacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahocaabaaaabaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaa
diaaaaahocaabaaaabaaaaaaagajbaaaahaaaaaafgaobaaaabaaaaaabaaaaaah
bcaabaaaadaaaaaaegacbaaaaiaaaaaaegacbaaaacaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaidpjccdnelaaaaafccaabaaaadaaaaaabkaabaaa
adaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkaabaaaadaaaaaaaaaaaaaiecaabaaaadaaaaaabkaabaiaebaaaaaa
adaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaadaaaaaaakaabaaaadaaaaaa
ckaabaaaadaaaaaabkaabaaaadaaaaaaaaaaaaaibcaabaaaadaaaaaaakaabaia
ebaaaaaaadaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaadaaaaaaakaabaaa
abaaaaaackaabaaaadaaaaaabkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahccaabaaaadaaaaaadkaabaaa
adaaaaaabkaabaaaadaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkaabaaaadaaaaaadiaaaaahocaabaaaabaaaaaa
fgaobaaaabaaaaaafgafbaaaadaaaaaabaaaaaaiccaabaaaadaaaaaaegacbaia
ebaaaaaaacaaaaaaegacbaaaaiaaaaaaaaaaaaahccaabaaaadaaaaaabkaabaaa
adaaaaaabkaabaaaadaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaaiaaaaaa
fgafbaiaebaaaaaaadaaaaaaegacbaiaebaaaaaaacaaaaaaeiaaaaalpcaabaaa
ahaaaaaaegacbaaaaiaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaeaefaaaaajpcaabaaaaiaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaa
aagabaaaadaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaiaaaaaaagiacaaa
aaaaaaaaaiaaaaaadccaaaakhcaabaaaacaaaaaaegacbaaaahaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegacbaaaacaaaaaadiaaaaahccaabaaaadaaaaaaakaabaaa
adaaaaaaakaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaa
bkaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaaakaabaaa
adaaaaaacpaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaadaaaaaackiacaaaaaaaaaaaagaaaaaabjaaaaafbcaabaaa
adaaaaaaakaabaaaadaaaaaaaoaaaaahicaabaaaaaaaaaaabkaabaaaadaaaaaa
dkaabaaaaaaaaaaadcaaaaajocaabaaaadaaaaaaagajbaaaagaaaaaapgapbaaa
aaaaaaaaagajbaaaafaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaajgahbaaaadaaaaaadcaaaaajocaabaaaabaaaaaafgaobaaa
abaaaaaapgapbaaaacaaaaaaagajbaaaacaaaaaaaaaaaaajhcaabaaaacaaaaaa
egiccaaaadaaaaaaaeaaaaaaegiccaaaadaaaaaaaeaaaaaadcaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaabaaaaaadcaaaaan
hcaabaaaabaaaaaaagaabaaaadaaaaaaegiccaaaaaaaaaaaahaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaa
adaaaaaaegiccaaaaaaaaaaaahaaaaaadcaaaabahcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaagaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaakgakbaaaaeaaaaaa
dbaaaaakhcaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadhcaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaaaaaaaajiccabaaaaaaaaaaackiacaiaebaaaaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 121 math, 7 textures
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_LightColor0]
Vector 4 [_Diffuse]
Vector 5 [_MetRoughLum_ST]
Vector 6 [_MainTex_ST]
Vector 7 [_BumpTex_ST]
Float 8 [_DiffuseHasAlphaclip]
Float 9 [_DiffuseHasRoughness]
Float 10 [_RimFalloff]
Vector 11 [_RimColor]
Float 12 [_ReflectionAmt]
Float 13 [_IBLAmt]
Float 14 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 2
SetTexture 3 [_IBL] CUBE 3
SetTexture 4 [_Reflection] CUBE 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c15, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c16, 2.00000000, -1.00000000, 0.31830987, -0.50000000
def c17, 2.00000000, 1.00000000, 0.20000000, 10.00000000
def c18, 0.30000001, 0.58999997, 0.11000000, 8.00000000
def c19, 5.00000000, 0.78539819, 1.57079637, 0.03978873
def c20, 3.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r2, r0, s1
mul r1.xyz, r2, c4
mov r0.xyz, c4
add r0.xyz, c16.w, r0
add r3.xyz, -r2, c15.w
mad r2.xyz, -r0, c17.x, c17.y
mad_sat r2.xyz, -r2, r3, c15.w
mul_sat r1.xyz, r1, c16.x
cmp r3.xyz, -r0, r1, r2
mad r0.xy, v0, c7, c7.zwzw
texld r0.yw, r0, s0
mad_pp r2.xy, r0.wyzw, c16.x, c16.y
mad r1.xy, v0, c5, c5.zwzw
texld r9.xyz, r1, s2
mul r0.xyz, r2.y, v4
mul_sat r1.xyz, r9.x, r3
add r3.w, -r9.x, c15
mad_sat r4.xyz, r3.w, c17.z, r1
mad r1.xyz, r2.x, v3, r0
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c15.w
rsq_pp r0.w, r0.x
dp3 r0.y, v2, v2
rsq r0.y, r0.y
mul r0.xyz, r0.y, v2
rcp_pp r0.w, r0.w
mad r1.xyz, r0.w, r0, r1
add r2.xyz, -v1, c1
dp3 r0.y, r2, r2
dp3 r0.x, r1, r1
rsq r0.w, r0.x
rsq r0.y, r0.y
mul r1.xyz, r0.w, r1
mul r0.xyz, r0.y, r2
dp3 r0.w, r1, r0
add r1.w, -r9.y, c15
max r4.w, r0, c15.z
add r2.x, r2.w, -r1.w
mad r7.w, r2.x, c9.x, r1
add r6.w, -r4, c15
pow r5, r6.w, c19.x
mov r2.x, r5
mad r1.w, -r7, c20.x, c20.y
rcp r1.w, r1.w
mul r1.w, r2.x, r1
mul r2.xyz, r1, -r0.w
add r5.xyz, -r4, c15.w
mad r8.xyz, r5, r1.w, r4
mad r6.xyz, -r2, c16.x, -r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, c2
add r0.xyz, r2, r0
texld r6.xyz, r6, s4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r2, r0
dp3 r0.x, r1, r0
mul r7.xyz, r6, c12.x
mov r1.w, c16.x
texldl r6.xyz, r1, s3
mad_sat r6.xyz, r6, c13.x, r7
max r0.w, r0, c15.z
add r1.w, -r0, c15
max r5.w, r0.x, c15.z
pow r0, r1.w, c19.x
mad r0.y, r7.w, c17.w, c17
mov r7.x, r0
exp r1.w, r0.y
pow r0, r5.w, r1.w
mov r0.w, r0.x
dp3 r0.x, r1, r2
mad r0.y, r1.w, c19, c19.z
rsq r0.y, r0.y
add r0.z, -r0.y, c15.w
mad r1.x, r0.z, r4.w, r0.y
max r0.x, r0, c15.z
mad r0.y, r0.x, r0.z, r0
mul r2.x, r0.y, r1
mul r0.xyz, r0.x, c3
mul r1.xyz, r0, r0.w
rcp r0.w, r2.x
mad r5.xyz, r5, r7.x, r4
mul r1.xyz, r1, r5
mul r1.xyz, r1, r0.w
add r0.w, r1, c18
mul r1.xyz, r0.w, r1
dp3 r0.w, r4, c18
mul r6.xyz, r6, r8
mad r4.xyz, r1, c19.w, r6
pow r1, r6.w, c10.x
mov r2.xyz, c0
mul r2.xyz, c16.x, r2
mad r0.xyz, r0, c16.z, r2
add r0.w, -r0, c15
mul r0.xyz, r0, r0.w
mov r0.w, r1.x
mul r2.xyz, r3.w, r3
mul r1.xyz, r0.w, c11
mad r0.xyz, r0, r2, r4
mul r2.xyz, r9.z, r1
add r1.xyz, r1, c16.w
add r0.w, r2, c15.x
mul r0.w, r0, c8.x
add r0.w, r0, c15.y
mad r3.xyz, -r1, c17.x, c17.y
add r1.w, -r9.z, c15
mul_sat r2.xyz, r2, c16.x
mad_sat r3.xyz, -r3, r1.w, c15.w
cmp r1.xyz, -r1, r2, r3
add oC0.xyz, r0, r1
cmp r0.w, r0, c15.z, c15
mov_pp r0, -r0.w
mov r1.x, c14
texkill r0.xyzw
add oC0.w, c15, -r1.x
"
}
SubProgram "d3d11 " {
// Stats: 110 math, 4 textures
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 0
SetTexture 3 [_IBL] CUBE 2
SetTexture 4 [_Reflection] CUBE 3
ConstBuffer "$Globals" 144
Vector 16 [_LightColor0]
Vector 32 [_Diffuse]
Vector 48 [_MetRoughLum_ST]
Vector 64 [_MainTex_ST]
Vector 80 [_BumpTex_ST]
Float 96 [_DiffuseHasAlphaclip]
Float 100 [_DiffuseHasRoughness]
Float 104 [_RimFalloff]
Vector 112 [_RimColor]
Float 128 [_ReflectionAmt]
Float 132 [_IBLAmt]
Float 136 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerFrame" 208
Vector 64 [glstate_lightmodel_ambient]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerFrame" 3
"ps_4_0
eefiecedhaihpmlfdajnnpmgableflmkbpodfehfabaaaaaagmbbaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcembaaaaa
eaaaaaaabdaeaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaaafaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
alaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaajbcaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhcaabaaa
acaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaa
acaaaaaaaaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaia
ebaaaaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaia
ebaaaaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaan
hcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaaegiccaaaaaaaaaaaacaaaaaadhcaaaajhcaabaaa
aaaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
dcaabaaaaeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaa
aaaaaaaaadaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaa
acaaaaaaaagabaaaaaaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaa
agaabaaaaeaaaaaaaaaaaaallcaabaaaaeaaaaaaggacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaiadpdccaaaamhcaabaaaafaaaaaa
pgapbaaaaeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaa
afaaaaaaaaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaahaaaaaaegacbaaa
agaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaaegbcbaaaadaaaaaa
dcaaaaaldcaabaaaajaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaajaaaaaaegaabaaaajaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaajaaaaaahgapbaaa
ajaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadiaaaaahhcaabaaaakaaaaaafgafbaaaajaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaakaaaaaaagaabaaaajaaaaaaegbcbaaa
aeaaaaaaegacbaaaakaaaaaaapaaaaahicaabaaaabaaaaaaegaabaaaajaaaaaa
egaabaaaajaaaaaaddaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaa
aiaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaakaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaaiaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaa
egacbaaaaiaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
aiaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaabkaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaaaaaaaaabkaabaaaaeaaaaaadcaaaaaj
icaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
dcaaaaakicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaeaea
abeaaaaaaaaaiaeabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaiaaaaaa
egacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahocaabaaaabaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaa
diaaaaahocaabaaaabaaaaaaagajbaaaahaaaaaafgaobaaaabaaaaaabaaaaaah
bcaabaaaadaaaaaaegacbaaaaiaaaaaaegacbaaaacaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaidpjccdnelaaaaafccaabaaaadaaaaaabkaabaaa
adaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkaabaaaadaaaaaaaaaaaaaiecaabaaaadaaaaaabkaabaiaebaaaaaa
adaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaadaaaaaaakaabaaaadaaaaaa
ckaabaaaadaaaaaabkaabaaaadaaaaaaaaaaaaaibcaabaaaadaaaaaaakaabaia
ebaaaaaaadaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaadaaaaaaakaabaaa
abaaaaaackaabaaaadaaaaaabkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahccaabaaaadaaaaaadkaabaaa
adaaaaaabkaabaaaadaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkaabaaaadaaaaaadiaaaaahocaabaaaabaaaaaa
fgaobaaaabaaaaaafgafbaaaadaaaaaabaaaaaaiccaabaaaadaaaaaaegacbaia
ebaaaaaaacaaaaaaegacbaaaaiaaaaaaaaaaaaahccaabaaaadaaaaaabkaabaaa
adaaaaaabkaabaaaadaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaaiaaaaaa
fgafbaiaebaaaaaaadaaaaaaegacbaiaebaaaaaaacaaaaaaeiaaaaalpcaabaaa
ahaaaaaaegacbaaaaiaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaeaefaaaaajpcaabaaaaiaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaa
aagabaaaadaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaiaaaaaaagiacaaa
aaaaaaaaaiaaaaaadccaaaakhcaabaaaacaaaaaaegacbaaaahaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegacbaaaacaaaaaadiaaaaahccaabaaaadaaaaaaakaabaaa
adaaaaaaakaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaa
bkaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaaakaabaaa
adaaaaaacpaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaadaaaaaackiacaaaaaaaaaaaagaaaaaabjaaaaafbcaabaaa
adaaaaaaakaabaaaadaaaaaaaoaaaaahicaabaaaaaaaaaaabkaabaaaadaaaaaa
dkaabaaaaaaaaaaadcaaaaajocaabaaaadaaaaaaagajbaaaagaaaaaapgapbaaa
aaaaaaaaagajbaaaafaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaajgahbaaaadaaaaaadcaaaaajocaabaaaabaaaaaafgaobaaa
abaaaaaapgapbaaaacaaaaaaagajbaaaacaaaaaaaaaaaaajhcaabaaaacaaaaaa
egiccaaaadaaaaaaaeaaaaaaegiccaaaadaaaaaaaeaaaaaadcaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaabaaaaaadcaaaaan
hcaabaaaabaaaaaaagaabaaaadaaaaaaegiccaaaaaaaaaaaahaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaa
adaaaaaaegiccaaaaaaaaaaaahaaaaaadcaaaabahcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaagaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaakgakbaaaaeaaaaaa
dbaaaaakhcaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadhcaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaaaaaaaajiccabaaaaaaaaaaackiacaiaebaaaaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 121 math, 7 textures
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_LightColor0]
Vector 4 [_Diffuse]
Vector 5 [_MetRoughLum_ST]
Vector 6 [_MainTex_ST]
Vector 7 [_BumpTex_ST]
Float 8 [_DiffuseHasAlphaclip]
Float 9 [_DiffuseHasRoughness]
Float 10 [_RimFalloff]
Vector 11 [_RimColor]
Float 12 [_ReflectionAmt]
Float 13 [_IBLAmt]
Float 14 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 2
SetTexture 3 [_IBL] CUBE 3
SetTexture 4 [_Reflection] CUBE 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c15, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c16, 2.00000000, -1.00000000, 0.31830987, -0.50000000
def c17, 2.00000000, 1.00000000, 0.20000000, 10.00000000
def c18, 0.30000001, 0.58999997, 0.11000000, 8.00000000
def c19, 5.00000000, 0.78539819, 1.57079637, 0.03978873
def c20, 3.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r2, r0, s1
mul r1.xyz, r2, c4
mov r0.xyz, c4
add r0.xyz, c16.w, r0
add r3.xyz, -r2, c15.w
mad r2.xyz, -r0, c17.x, c17.y
mad_sat r2.xyz, -r2, r3, c15.w
mul_sat r1.xyz, r1, c16.x
cmp r3.xyz, -r0, r1, r2
mad r0.xy, v0, c7, c7.zwzw
texld r0.yw, r0, s0
mad_pp r2.xy, r0.wyzw, c16.x, c16.y
mad r1.xy, v0, c5, c5.zwzw
texld r9.xyz, r1, s2
mul r0.xyz, r2.y, v4
mul_sat r1.xyz, r9.x, r3
add r3.w, -r9.x, c15
mad_sat r4.xyz, r3.w, c17.z, r1
mad r1.xyz, r2.x, v3, r0
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c15.w
rsq_pp r0.w, r0.x
dp3 r0.y, v2, v2
rsq r0.y, r0.y
mul r0.xyz, r0.y, v2
rcp_pp r0.w, r0.w
mad r1.xyz, r0.w, r0, r1
add r2.xyz, -v1, c1
dp3 r0.y, r2, r2
dp3 r0.x, r1, r1
rsq r0.w, r0.x
rsq r0.y, r0.y
mul r1.xyz, r0.w, r1
mul r0.xyz, r0.y, r2
dp3 r0.w, r1, r0
add r1.w, -r9.y, c15
max r4.w, r0, c15.z
add r2.x, r2.w, -r1.w
mad r7.w, r2.x, c9.x, r1
add r6.w, -r4, c15
pow r5, r6.w, c19.x
mov r2.x, r5
mad r1.w, -r7, c20.x, c20.y
rcp r1.w, r1.w
mul r1.w, r2.x, r1
mul r2.xyz, r1, -r0.w
add r5.xyz, -r4, c15.w
mad r8.xyz, r5, r1.w, r4
mad r6.xyz, -r2, c16.x, -r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, c2
add r0.xyz, r2, r0
texld r6.xyz, r6, s4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r2, r0
dp3 r0.x, r1, r0
mul r7.xyz, r6, c12.x
mov r1.w, c16.x
texldl r6.xyz, r1, s3
mad_sat r6.xyz, r6, c13.x, r7
max r0.w, r0, c15.z
add r1.w, -r0, c15
max r5.w, r0.x, c15.z
pow r0, r1.w, c19.x
mad r0.y, r7.w, c17.w, c17
mov r7.x, r0
exp r1.w, r0.y
pow r0, r5.w, r1.w
mov r0.w, r0.x
dp3 r0.x, r1, r2
mad r0.y, r1.w, c19, c19.z
rsq r0.y, r0.y
add r0.z, -r0.y, c15.w
mad r1.x, r0.z, r4.w, r0.y
max r0.x, r0, c15.z
mad r0.y, r0.x, r0.z, r0
mul r2.x, r0.y, r1
mul r0.xyz, r0.x, c3
mul r1.xyz, r0, r0.w
rcp r0.w, r2.x
mad r5.xyz, r5, r7.x, r4
mul r1.xyz, r1, r5
mul r1.xyz, r1, r0.w
add r0.w, r1, c18
mul r1.xyz, r0.w, r1
dp3 r0.w, r4, c18
mul r6.xyz, r6, r8
mad r4.xyz, r1, c19.w, r6
pow r1, r6.w, c10.x
mov r2.xyz, c0
mul r2.xyz, c16.x, r2
mad r0.xyz, r0, c16.z, r2
add r0.w, -r0, c15
mul r0.xyz, r0, r0.w
mov r0.w, r1.x
mul r2.xyz, r3.w, r3
mul r1.xyz, r0.w, c11
mad r0.xyz, r0, r2, r4
mul r2.xyz, r9.z, r1
add r1.xyz, r1, c16.w
add r0.w, r2, c15.x
mul r0.w, r0, c8.x
add r0.w, r0, c15.y
mad r3.xyz, -r1, c17.x, c17.y
add r1.w, -r9.z, c15
mul_sat r2.xyz, r2, c16.x
mad_sat r3.xyz, -r3, r1.w, c15.w
cmp r1.xyz, -r1, r2, r3
add oC0.xyz, r0, r1
cmp r0.w, r0, c15.z, c15
mov_pp r0, -r0.w
mov r1.x, c14
texkill r0.xyzw
add oC0.w, c15, -r1.x
"
}
SubProgram "d3d11 " {
// Stats: 110 math, 4 textures
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 0
SetTexture 3 [_IBL] CUBE 2
SetTexture 4 [_Reflection] CUBE 3
ConstBuffer "$Globals" 144
Vector 16 [_LightColor0]
Vector 32 [_Diffuse]
Vector 48 [_MetRoughLum_ST]
Vector 64 [_MainTex_ST]
Vector 80 [_BumpTex_ST]
Float 96 [_DiffuseHasAlphaclip]
Float 100 [_DiffuseHasRoughness]
Float 104 [_RimFalloff]
Vector 112 [_RimColor]
Float 128 [_ReflectionAmt]
Float 132 [_IBLAmt]
Float 136 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerFrame" 208
Vector 64 [glstate_lightmodel_ambient]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerFrame" 3
"ps_4_0
eefiecedhaihpmlfdajnnpmgableflmkbpodfehfabaaaaaagmbbaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcembaaaaa
eaaaaaaabdaeaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaaafaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
alaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaa
aeaaaaaaogikcaaaaaaaaaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaajbcaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhcaabaaa
acaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaa
acaaaaaaaaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaia
ebaaaaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaia
ebaaaaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaan
hcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaaegiccaaaaaaaaaaaacaaaaaadhcaaaajhcaabaaa
aaaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
dcaabaaaaeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaa
aaaaaaaaadaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaa
acaaaaaaaagabaaaaaaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaa
agaabaaaaeaaaaaaaaaaaaallcaabaaaaeaaaaaaggacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaiadpdccaaaamhcaabaaaafaaaaaa
pgapbaaaaeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaa
afaaaaaaaaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaahaaaaaaegacbaaa
agaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaaegbcbaaaadaaaaaa
dcaaaaaldcaabaaaajaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
ogikcaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaajaaaaaaegaabaaaajaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaajaaaaaahgapbaaa
ajaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaadiaaaaahhcaabaaaakaaaaaafgafbaaaajaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaakaaaaaaagaabaaaajaaaaaaegbcbaaa
aeaaaaaaegacbaaaakaaaaaaapaaaaahicaabaaaabaaaaaaegaabaaaajaaaaaa
egaabaaaajaaaaaaddaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaa
aiaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaakaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaaiaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaiaaaaaapgapbaaaabaaaaaa
egacbaaaaiaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
aiaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaabkaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaaaaaaaaabkaabaaaaeaaaaaadcaaaaaj
icaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
dcaaaaakicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaeaea
abeaaaaaaaaaiaeabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaiaaaaaa
egacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahocaabaaaabaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaa
diaaaaahocaabaaaabaaaaaaagajbaaaahaaaaaafgaobaaaabaaaaaabaaaaaah
bcaabaaaadaaaaaaegacbaaaaiaaaaaaegacbaaaacaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaidpjccdnelaaaaafccaabaaaadaaaaaabkaabaaa
adaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpbkaabaaaadaaaaaaaaaaaaaiecaabaaaadaaaaaabkaabaiaebaaaaaa
adaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaadaaaaaaakaabaaaadaaaaaa
ckaabaaaadaaaaaabkaabaaaadaaaaaaaaaaaaaibcaabaaaadaaaaaaakaabaia
ebaaaaaaadaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaadaaaaaaakaabaaa
abaaaaaackaabaaaadaaaaaabkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahccaabaaaadaaaaaadkaabaaa
adaaaaaabkaabaaaadaaaaaaaoaaaaakccaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpbkaabaaaadaaaaaadiaaaaahocaabaaaabaaaaaa
fgaobaaaabaaaaaafgafbaaaadaaaaaabaaaaaaiccaabaaaadaaaaaaegacbaia
ebaaaaaaacaaaaaaegacbaaaaiaaaaaaaaaaaaahccaabaaaadaaaaaabkaabaaa
adaaaaaabkaabaaaadaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaaiaaaaaa
fgafbaiaebaaaaaaadaaaaaaegacbaiaebaaaaaaacaaaaaaeiaaaaalpcaabaaa
ahaaaaaaegacbaaaaiaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaeaefaaaaajpcaabaaaaiaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaa
aagabaaaadaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaiaaaaaaagiacaaa
aaaaaaaaaiaaaaaadccaaaakhcaabaaaacaaaaaaegacbaaaahaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegacbaaaacaaaaaadiaaaaahccaabaaaadaaaaaaakaabaaa
adaaaaaaakaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaa
bkaabaaaadaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaadaaaaaaakaabaaa
adaaaaaacpaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaadaaaaaackiacaaaaaaaaaaaagaaaaaabjaaaaafbcaabaaa
adaaaaaaakaabaaaadaaaaaaaoaaaaahicaabaaaaaaaaaaabkaabaaaadaaaaaa
dkaabaaaaaaaaaaadcaaaaajocaabaaaadaaaaaaagajbaaaagaaaaaapgapbaaa
aaaaaaaaagajbaaaafaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaajgahbaaaadaaaaaadcaaaaajocaabaaaabaaaaaafgaobaaa
abaaaaaapgapbaaaacaaaaaaagajbaaaacaaaaaaaaaaaaajhcaabaaaacaaaaaa
egiccaaaadaaaaaaaeaaaaaaegiccaaaadaaaaaaaeaaaaaadcaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaabaaaaaadcaaaaan
hcaabaaaabaaaaaaagaabaaaadaaaaaaegiccaaaaaaaaaaaahaaaaaaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaa
adaaaaaaegiccaaaaaaaaaaaahaaaaaadcaaaabahcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaaagaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaakgakbaaaaeaaaaaa
dbaaaaakhcaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadhcaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaaaaaaaajiccabaaaaaaaaaaackiacaiaebaaaaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES3"
}
}
 }


 // Stats for Vertex shader:
 //       d3d11 : 26 avg math (23..27)
 //        d3d9 : 32 avg math (29..34)
 // Stats for Fragment shader:
 //       d3d11 : 89 avg math (87..94), 4 avg texture (3..5)
 //        d3d9 : 97 avg math (96..102), 5 avg texture (4..6)
 Pass {
  Name "FORWARDADD"
  Tags { "LIGHTMODE"="ForwardAdd" "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
  ZWrite Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
Program "vp" {
SubProgram "opengl " {
Keywords { "POINT" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform mat4 _LightMatrix0;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_7;
  x_7 = (mix (1.0, tmpvar_6.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_7 < 0.0)) {
    discard;
  };
  vec3 tmpvar_8;
  tmpvar_8 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  vec3 tmpvar_9;
  tmpvar_9 = normalize((tmpvar_3 + tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5))).w * 2.0) * _LightColor0.xyz);
  float tmpvar_11;
  tmpvar_11 = dot (tmpvar_5, tmpvar_8);
  vec3 tmpvar_12;
  tmpvar_12 = ((max (0.0, tmpvar_11) * 0.31831) * tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  float tmpvar_14;
  tmpvar_14 = exp2(((mix (((tmpvar_13.y * -1.0) + 1.0), tmpvar_6.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  float tmpvar_15;
  tmpvar_15 = max (0.0, tmpvar_11);
  float tmpvar_16;
  tmpvar_16 = ((tmpvar_13.x * -1.0) + 1.0);
  bvec3 tmpvar_17;
  tmpvar_17 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_18;
  b_18 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_6.xyz)));
  vec3 c_19;
  c_19 = ((2.0 * _Diffuse.xyz) * tmpvar_6.xyz);
  float tmpvar_20;
  if (tmpvar_17.x) {
    tmpvar_20 = b_18.x;
  } else {
    tmpvar_20 = c_19.x;
  };
  float tmpvar_21;
  if (tmpvar_17.y) {
    tmpvar_21 = b_18.y;
  } else {
    tmpvar_21 = c_19.y;
  };
  float tmpvar_22;
  if (tmpvar_17.z) {
    tmpvar_22 = b_18.z;
  } else {
    tmpvar_22 = c_19.z;
  };
  vec3 tmpvar_23;
  tmpvar_23.x = tmpvar_20;
  tmpvar_23.y = tmpvar_21;
  tmpvar_23.z = tmpvar_22;
  vec3 tmpvar_24;
  tmpvar_24 = clamp (tmpvar_23, 0.0, 1.0);
  vec3 tmpvar_25;
  tmpvar_25 = clamp (((tmpvar_16 * 0.2) + clamp ((tmpvar_24 * tmpvar_13.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_26;
  tmpvar_26 = inversesqrt(((0.785398 * tmpvar_14) + 1.5708));
  vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = ((((tmpvar_12 * (1.0 - dot (tmpvar_25, vec3(0.3, 0.59, 0.11)))) * (tmpvar_24 * tmpvar_16)) + (((((tmpvar_10 * tmpvar_15) * pow (max (0.0, dot (tmpvar_9, tmpvar_5)), tmpvar_14)) * (tmpvar_25 + ((1.0 - tmpvar_25) * pow ((1.0 - max (0.0, dot (tmpvar_9, tmpvar_8))), 5.0)))) * (1.0/((((tmpvar_15 * (1.0 - tmpvar_26)) + tmpvar_26) * ((max (0.0, dot (tmpvar_5, tmpvar_3)) * (1.0 - tmpvar_26)) + tmpvar_26))))) * ((tmpvar_14 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 33 math
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c16.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c16.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mov o4.xyz, r1
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mul o5.xyz, r0.w, r2
mov o2, r1
dp4 o6.z, r1, c14
dp4 o6.y, r1, c13
dp4 o6.x, r1, c12
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
// Stats: 27 math
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 208
Matrix 16 [_LightMatrix0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedpgoikocoeepfnkgjiblmgnbjjmleglkiabaaaaaadeagaaaaadaaaaaa
cmaaaaaamaaaaaaajaabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
lmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
lmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcjmaeaaaaeaaaabaachabaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaacaaaaaa
egaobaaaaaaaaaaabaaaaaaibcaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabaaaaaaabaaaaaaiccaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabbaaaaaabaaaaaaiecaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabcaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadgaaaaafhccabaaa
aeaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaadaaaaaacgajbaaaabaaaaaa
jgaebaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgaebaaaabaaaaaacgajbaaa
acaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgbpbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hccabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaakgakbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaaaaaaaaaaeaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture2D (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp float tmpvar_18;
  tmpvar_18 = (texture2D (_LightTexture0, vec2(tmpvar_17)).w * 2.0);
  attenuation_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_21;
  tmpvar_21 = ((max (0.0, tmpvar_20) * 0.31831) * tmpvar_19);
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_22 = texture2D (_MetRoughLum, P_23);
  node_42_2 = tmpvar_22;
  highp float tmpvar_24;
  tmpvar_24 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_20);
  highp float tmpvar_26;
  tmpvar_26 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  highp float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  highp float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  highp vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_36;
  tmpvar_36 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  highp vec4 tmpvar_37;
  tmpvar_37.w = 0.0;
  tmpvar_37.xyz = ((((tmpvar_21 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + (((((tmpvar_19 * tmpvar_25) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_36)) + tmpvar_36) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_36)) + tmpvar_36))))) * ((tmpvar_24 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture2D (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp float tmpvar_18;
  tmpvar_18 = (texture2D (_LightTexture0, vec2(tmpvar_17)).w * 2.0);
  attenuation_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_21;
  tmpvar_21 = ((max (0.0, tmpvar_20) * 0.31831) * tmpvar_19);
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_22 = texture2D (_MetRoughLum, P_23);
  node_42_2 = tmpvar_22;
  highp float tmpvar_24;
  tmpvar_24 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_20);
  highp float tmpvar_26;
  tmpvar_26 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  highp float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  highp float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  highp vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_36;
  tmpvar_36 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  highp vec4 tmpvar_37;
  tmpvar_37.w = 0.0;
  tmpvar_37.xyz = ((((tmpvar_21 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + (((((tmpvar_19 * tmpvar_25) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_36)) + tmpvar_36) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_36)) + tmpvar_36))))) * ((tmpvar_24 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp float tmpvar_18;
  tmpvar_18 = (texture (_LightTexture0, vec2(tmpvar_17)).w * 2.0);
  attenuation_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_21;
  tmpvar_21 = ((max (0.0, tmpvar_20) * 0.31831) * tmpvar_19);
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_22 = texture (_MetRoughLum, P_23);
  node_42_2 = tmpvar_22;
  highp float tmpvar_24;
  tmpvar_24 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_20);
  highp float tmpvar_26;
  tmpvar_26 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  highp float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  highp float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  highp vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_36;
  tmpvar_36 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  highp vec4 tmpvar_37;
  tmpvar_37.w = 0.0;
  tmpvar_37.xyz = ((((tmpvar_21 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + (((((tmpvar_19 * tmpvar_25) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_36)) + tmpvar_36) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_36)) + tmpvar_36))))) * ((tmpvar_24 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_37;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_7;
  x_7 = (mix (1.0, tmpvar_6.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_7 < 0.0)) {
    discard;
  };
  vec3 tmpvar_8;
  tmpvar_8 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  vec3 tmpvar_9;
  tmpvar_9 = normalize((tmpvar_3 + tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10 = (2.0 * _LightColor0.xyz);
  float tmpvar_11;
  tmpvar_11 = dot (tmpvar_5, tmpvar_8);
  vec3 tmpvar_12;
  tmpvar_12 = ((max (0.0, tmpvar_11) * 0.31831) * tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  float tmpvar_14;
  tmpvar_14 = exp2(((mix (((tmpvar_13.y * -1.0) + 1.0), tmpvar_6.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  float tmpvar_15;
  tmpvar_15 = max (0.0, tmpvar_11);
  float tmpvar_16;
  tmpvar_16 = ((tmpvar_13.x * -1.0) + 1.0);
  bvec3 tmpvar_17;
  tmpvar_17 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_18;
  b_18 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_6.xyz)));
  vec3 c_19;
  c_19 = ((2.0 * _Diffuse.xyz) * tmpvar_6.xyz);
  float tmpvar_20;
  if (tmpvar_17.x) {
    tmpvar_20 = b_18.x;
  } else {
    tmpvar_20 = c_19.x;
  };
  float tmpvar_21;
  if (tmpvar_17.y) {
    tmpvar_21 = b_18.y;
  } else {
    tmpvar_21 = c_19.y;
  };
  float tmpvar_22;
  if (tmpvar_17.z) {
    tmpvar_22 = b_18.z;
  } else {
    tmpvar_22 = c_19.z;
  };
  vec3 tmpvar_23;
  tmpvar_23.x = tmpvar_20;
  tmpvar_23.y = tmpvar_21;
  tmpvar_23.z = tmpvar_22;
  vec3 tmpvar_24;
  tmpvar_24 = clamp (tmpvar_23, 0.0, 1.0);
  vec3 tmpvar_25;
  tmpvar_25 = clamp (((tmpvar_16 * 0.2) + clamp ((tmpvar_24 * tmpvar_13.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_26;
  tmpvar_26 = inversesqrt(((0.785398 * tmpvar_14) + 1.5708));
  vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = ((((tmpvar_12 * (1.0 - dot (tmpvar_25, vec3(0.3, 0.59, 0.11)))) * (tmpvar_24 * tmpvar_16)) + (((((tmpvar_10 * tmpvar_15) * pow (max (0.0, dot (tmpvar_9, tmpvar_5)), tmpvar_14)) * (tmpvar_25 + ((1.0 - tmpvar_25) * pow ((1.0 - max (0.0, dot (tmpvar_9, tmpvar_8))), 5.0)))) * (1.0/((((tmpvar_15 * (1.0 - tmpvar_26)) + tmpvar_26) * ((max (0.0, dot (tmpvar_5, tmpvar_3)) * (1.0 - tmpvar_26)) + tmpvar_26))))) * ((tmpvar_14 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 29 math
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul o5.xyz, r0.w, r2
mov o4.xyz, r1
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 23 math
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedooilndalaneljhihncooenjckicbkmglabaaaaaafeafaaaaadaaaaaa
cmaaaaaamaaaaaaahiabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcneadaaaa
eaaaabaapfaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
acaaaaaaegiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaaaaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec4 node_335_3;
  highp vec3 normalLocal_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = xlv_TEXCOORD3.x;
  tmpvar_6[0].y = xlv_TEXCOORD4.x;
  tmpvar_6[0].z = tmpvar_5.x;
  tmpvar_6[1].x = xlv_TEXCOORD3.y;
  tmpvar_6[1].y = xlv_TEXCOORD4.y;
  tmpvar_6[1].z = tmpvar_5.y;
  tmpvar_6[2].x = xlv_TEXCOORD3.z;
  tmpvar_6[2].y = xlv_TEXCOORD4.z;
  tmpvar_6[2].z = tmpvar_5.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpTex, P_8).xyz * 2.0) - 1.0);
  normalLocal_4 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize((normalLocal_4 * tmpvar_6));
  lowp vec4 tmpvar_11;
  highp vec2 P_12;
  P_12 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_11 = texture2D (_MainTex, P_12);
  node_335_3 = tmpvar_11;
  highp float x_13;
  x_13 = (mix (1.0, node_335_3.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_13 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_7 + tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * _LightColor0.xyz);
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_10, tmpvar_14);
  highp vec3 tmpvar_18;
  tmpvar_18 = ((max (0.0, tmpvar_17) * 0.31831) * tmpvar_16);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_19 = texture2D (_MetRoughLum, P_20);
  node_42_2 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_3.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_22;
  tmpvar_22 = max (0.0, tmpvar_17);
  highp float tmpvar_23;
  tmpvar_23 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_24;
  tmpvar_24 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_3.xyz)));
  highp vec3 c_26;
  c_26 = ((2.0 * _Diffuse.xyz) * node_335_3.xyz);
  highp float tmpvar_27;
  if (tmpvar_24.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_24.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_24.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp vec3 tmpvar_32;
  tmpvar_32 = clamp (((tmpvar_23 * 0.2) + clamp ((tmpvar_31 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_33;
  tmpvar_33 = inversesqrt(((0.785398 * tmpvar_21) + 1.5708));
  highp vec4 tmpvar_34;
  tmpvar_34.w = 0.0;
  tmpvar_34.xyz = ((((tmpvar_18 * (1.0 - dot (tmpvar_32, vec3(0.3, 0.59, 0.11)))) * (tmpvar_31 * tmpvar_23)) + (((((tmpvar_16 * tmpvar_22) * pow (max (0.0, dot (tmpvar_15, tmpvar_10)), tmpvar_21)) * (tmpvar_32 + ((1.0 - tmpvar_32) * pow ((1.0 - max (0.0, dot (tmpvar_15, tmpvar_14))), 5.0)))) * (1.0/((((tmpvar_22 * (1.0 - tmpvar_33)) + tmpvar_33) * ((max (0.0, dot (tmpvar_10, tmpvar_7)) * (1.0 - tmpvar_33)) + tmpvar_33))))) * ((tmpvar_21 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec4 node_335_3;
  highp vec3 normalLocal_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = xlv_TEXCOORD3.x;
  tmpvar_6[0].y = xlv_TEXCOORD4.x;
  tmpvar_6[0].z = tmpvar_5.x;
  tmpvar_6[1].x = xlv_TEXCOORD3.y;
  tmpvar_6[1].y = xlv_TEXCOORD4.y;
  tmpvar_6[1].z = tmpvar_5.y;
  tmpvar_6[2].x = xlv_TEXCOORD3.z;
  tmpvar_6[2].y = xlv_TEXCOORD4.z;
  tmpvar_6[2].z = tmpvar_5.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_9;
  normal_9.xy = ((texture2D (_BumpTex, P_8).wy * 2.0) - 1.0);
  normal_9.z = sqrt((1.0 - clamp (dot (normal_9.xy, normal_9.xy), 0.0, 1.0)));
  normalLocal_4 = normal_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize((normalLocal_4 * tmpvar_6));
  lowp vec4 tmpvar_11;
  highp vec2 P_12;
  P_12 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_11 = texture2D (_MainTex, P_12);
  node_335_3 = tmpvar_11;
  highp float x_13;
  x_13 = (mix (1.0, node_335_3.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_13 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_7 + tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * _LightColor0.xyz);
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_10, tmpvar_14);
  highp vec3 tmpvar_18;
  tmpvar_18 = ((max (0.0, tmpvar_17) * 0.31831) * tmpvar_16);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_19 = texture2D (_MetRoughLum, P_20);
  node_42_2 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_3.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_22;
  tmpvar_22 = max (0.0, tmpvar_17);
  highp float tmpvar_23;
  tmpvar_23 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_24;
  tmpvar_24 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_3.xyz)));
  highp vec3 c_26;
  c_26 = ((2.0 * _Diffuse.xyz) * node_335_3.xyz);
  highp float tmpvar_27;
  if (tmpvar_24.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_24.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_24.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp vec3 tmpvar_32;
  tmpvar_32 = clamp (((tmpvar_23 * 0.2) + clamp ((tmpvar_31 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_33;
  tmpvar_33 = inversesqrt(((0.785398 * tmpvar_21) + 1.5708));
  highp vec4 tmpvar_34;
  tmpvar_34.w = 0.0;
  tmpvar_34.xyz = ((((tmpvar_18 * (1.0 - dot (tmpvar_32, vec3(0.3, 0.59, 0.11)))) * (tmpvar_31 * tmpvar_23)) + (((((tmpvar_16 * tmpvar_22) * pow (max (0.0, dot (tmpvar_15, tmpvar_10)), tmpvar_21)) * (tmpvar_32 + ((1.0 - tmpvar_32) * pow ((1.0 - max (0.0, dot (tmpvar_15, tmpvar_14))), 5.0)))) * (1.0/((((tmpvar_22 * (1.0 - tmpvar_33)) + tmpvar_33) * ((max (0.0, dot (tmpvar_10, tmpvar_7)) * (1.0 - tmpvar_33)) + tmpvar_33))))) * ((tmpvar_21 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec4 node_335_3;
  highp vec3 normalLocal_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = xlv_TEXCOORD3.x;
  tmpvar_6[0].y = xlv_TEXCOORD4.x;
  tmpvar_6[0].z = tmpvar_5.x;
  tmpvar_6[1].x = xlv_TEXCOORD3.y;
  tmpvar_6[1].y = xlv_TEXCOORD4.y;
  tmpvar_6[1].z = tmpvar_5.y;
  tmpvar_6[2].x = xlv_TEXCOORD3.z;
  tmpvar_6[2].y = xlv_TEXCOORD4.z;
  tmpvar_6[2].z = tmpvar_5.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture (_BumpTex, P_8).xyz * 2.0) - 1.0);
  normalLocal_4 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize((normalLocal_4 * tmpvar_6));
  lowp vec4 tmpvar_11;
  highp vec2 P_12;
  P_12 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_11 = texture (_MainTex, P_12);
  node_335_3 = tmpvar_11;
  highp float x_13;
  x_13 = (mix (1.0, node_335_3.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_13 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_7 + tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * _LightColor0.xyz);
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_10, tmpvar_14);
  highp vec3 tmpvar_18;
  tmpvar_18 = ((max (0.0, tmpvar_17) * 0.31831) * tmpvar_16);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_19 = texture (_MetRoughLum, P_20);
  node_42_2 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_3.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_22;
  tmpvar_22 = max (0.0, tmpvar_17);
  highp float tmpvar_23;
  tmpvar_23 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_24;
  tmpvar_24 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_25;
  b_25 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_3.xyz)));
  highp vec3 c_26;
  c_26 = ((2.0 * _Diffuse.xyz) * node_335_3.xyz);
  highp float tmpvar_27;
  if (tmpvar_24.x) {
    tmpvar_27 = b_25.x;
  } else {
    tmpvar_27 = c_26.x;
  };
  highp float tmpvar_28;
  if (tmpvar_24.y) {
    tmpvar_28 = b_25.y;
  } else {
    tmpvar_28 = c_26.y;
  };
  highp float tmpvar_29;
  if (tmpvar_24.z) {
    tmpvar_29 = b_25.z;
  } else {
    tmpvar_29 = c_26.z;
  };
  highp vec3 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = tmpvar_28;
  tmpvar_30.z = tmpvar_29;
  highp vec3 tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp vec3 tmpvar_32;
  tmpvar_32 = clamp (((tmpvar_23 * 0.2) + clamp ((tmpvar_31 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_33;
  tmpvar_33 = inversesqrt(((0.785398 * tmpvar_21) + 1.5708));
  highp vec4 tmpvar_34;
  tmpvar_34.w = 0.0;
  tmpvar_34.xyz = ((((tmpvar_18 * (1.0 - dot (tmpvar_32, vec3(0.3, 0.59, 0.11)))) * (tmpvar_31 * tmpvar_23)) + (((((tmpvar_16 * tmpvar_22) * pow (max (0.0, dot (tmpvar_15, tmpvar_10)), tmpvar_21)) * (tmpvar_32 + ((1.0 - tmpvar_32) * pow ((1.0 - max (0.0, dot (tmpvar_15, tmpvar_14))), 5.0)))) * (1.0/((((tmpvar_22 * (1.0 - tmpvar_33)) + tmpvar_33) * ((max (0.0, dot (tmpvar_10, tmpvar_7)) * (1.0 - tmpvar_33)) + tmpvar_33))))) * ((tmpvar_21 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_34;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform mat4 _LightMatrix0;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD5;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_7;
  x_7 = (mix (1.0, tmpvar_6.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_7 < 0.0)) {
    discard;
  };
  vec3 tmpvar_8;
  tmpvar_8 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  vec3 tmpvar_9;
  tmpvar_9 = normalize((tmpvar_3 + tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10 = ((((float((xlv_TEXCOORD5.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD5.xyz, xlv_TEXCOORD5.xyz))).w) * 2.0) * _LightColor0.xyz);
  float tmpvar_11;
  tmpvar_11 = dot (tmpvar_5, tmpvar_8);
  vec3 tmpvar_12;
  tmpvar_12 = ((max (0.0, tmpvar_11) * 0.31831) * tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  float tmpvar_14;
  tmpvar_14 = exp2(((mix (((tmpvar_13.y * -1.0) + 1.0), tmpvar_6.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  float tmpvar_15;
  tmpvar_15 = max (0.0, tmpvar_11);
  float tmpvar_16;
  tmpvar_16 = ((tmpvar_13.x * -1.0) + 1.0);
  bvec3 tmpvar_17;
  tmpvar_17 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_18;
  b_18 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_6.xyz)));
  vec3 c_19;
  c_19 = ((2.0 * _Diffuse.xyz) * tmpvar_6.xyz);
  float tmpvar_20;
  if (tmpvar_17.x) {
    tmpvar_20 = b_18.x;
  } else {
    tmpvar_20 = c_19.x;
  };
  float tmpvar_21;
  if (tmpvar_17.y) {
    tmpvar_21 = b_18.y;
  } else {
    tmpvar_21 = c_19.y;
  };
  float tmpvar_22;
  if (tmpvar_17.z) {
    tmpvar_22 = b_18.z;
  } else {
    tmpvar_22 = c_19.z;
  };
  vec3 tmpvar_23;
  tmpvar_23.x = tmpvar_20;
  tmpvar_23.y = tmpvar_21;
  tmpvar_23.z = tmpvar_22;
  vec3 tmpvar_24;
  tmpvar_24 = clamp (tmpvar_23, 0.0, 1.0);
  vec3 tmpvar_25;
  tmpvar_25 = clamp (((tmpvar_16 * 0.2) + clamp ((tmpvar_24 * tmpvar_13.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_26;
  tmpvar_26 = inversesqrt(((0.785398 * tmpvar_14) + 1.5708));
  vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = ((((tmpvar_12 * (1.0 - dot (tmpvar_25, vec3(0.3, 0.59, 0.11)))) * (tmpvar_24 * tmpvar_16)) + (((((tmpvar_10 * tmpvar_15) * pow (max (0.0, dot (tmpvar_9, tmpvar_5)), tmpvar_14)) * (tmpvar_25 + ((1.0 - tmpvar_25) * pow ((1.0 - max (0.0, dot (tmpvar_9, tmpvar_8))), 5.0)))) * (1.0/((((tmpvar_15 * (1.0 - tmpvar_26)) + tmpvar_26) * ((max (0.0, dot (tmpvar_5, tmpvar_3)) * (1.0 - tmpvar_26)) + tmpvar_26))))) * ((tmpvar_14 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 34 math
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
dp4 r1.w, v0, c7
mov r0.w, c16.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c16.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mov o4.xyz, r1
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mul o5.xyz, r0.w, r2
mov o2, r1
dp4 o6.w, r1, c15
dp4 o6.z, r1, c14
dp4 o6.y, r1, c13
dp4 o6.x, r1, c12
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
// Stats: 27 math
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 208
Matrix 16 [_LightMatrix0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedcodhkfbadjpbpfonohbollfnckiaoighabaaaaaadeagaaaaadaaaaaa
cmaaaaaamaaaaaaajaabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
lmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
lmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcjmaeaaaaeaaaabaachabaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
pccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaacaaaaaa
egaobaaaaaaaaaaabaaaaaaibcaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabaaaaaaabaaaaaaiccaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabbaaaaaabaaaaaaiecaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabcaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadgaaaaafhccabaaa
aeaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaadaaaaaacgajbaaaabaaaaaa
jgaebaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgaebaaaabaaaaaacgajbaaa
acaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgbpbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hccabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaaaaaaaaaabaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaakgakbaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpccabaaaagaaaaaaegiocaaaaaaaaaaaaeaaaaaa
pgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec4 node_335_3;
  highp vec3 normalLocal_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = xlv_TEXCOORD3.x;
  tmpvar_6[0].y = xlv_TEXCOORD4.x;
  tmpvar_6[0].z = tmpvar_5.x;
  tmpvar_6[1].x = xlv_TEXCOORD3.y;
  tmpvar_6[1].y = xlv_TEXCOORD4.y;
  tmpvar_6[1].z = tmpvar_5.y;
  tmpvar_6[2].x = xlv_TEXCOORD3.z;
  tmpvar_6[2].y = xlv_TEXCOORD4.z;
  tmpvar_6[2].z = tmpvar_5.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpTex, P_8).xyz * 2.0) - 1.0);
  normalLocal_4 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize((normalLocal_4 * tmpvar_6));
  lowp vec4 tmpvar_11;
  highp vec2 P_12;
  P_12 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_11 = texture2D (_MainTex, P_12);
  node_335_3 = tmpvar_11;
  highp float x_13;
  x_13 = (mix (1.0, node_335_3.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_13 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_7 + tmpvar_14));
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5);
  tmpvar_16 = texture2D (_LightTexture0, P_17);
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD5.xyz, xlv_TEXCOORD5.xyz);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = ((((float((xlv_TEXCOORD5.z > 0.0)) * tmpvar_16.w) * tmpvar_19.w) * 2.0) * _LightColor0.xyz);
  highp float tmpvar_21;
  tmpvar_21 = dot (tmpvar_10, tmpvar_14);
  highp vec3 tmpvar_22;
  tmpvar_22 = ((max (0.0, tmpvar_21) * 0.31831) * tmpvar_20);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_23 = texture2D (_MetRoughLum, P_24);
  node_42_2 = tmpvar_23;
  highp float tmpvar_25;
  tmpvar_25 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_3.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_26;
  tmpvar_26 = max (0.0, tmpvar_21);
  highp float tmpvar_27;
  tmpvar_27 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_28;
  tmpvar_28 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_29;
  b_29 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_3.xyz)));
  highp vec3 c_30;
  c_30 = ((2.0 * _Diffuse.xyz) * node_335_3.xyz);
  highp float tmpvar_31;
  if (tmpvar_28.x) {
    tmpvar_31 = b_29.x;
  } else {
    tmpvar_31 = c_30.x;
  };
  highp float tmpvar_32;
  if (tmpvar_28.y) {
    tmpvar_32 = b_29.y;
  } else {
    tmpvar_32 = c_30.y;
  };
  highp float tmpvar_33;
  if (tmpvar_28.z) {
    tmpvar_33 = b_29.z;
  } else {
    tmpvar_33 = c_30.z;
  };
  highp vec3 tmpvar_34;
  tmpvar_34.x = tmpvar_31;
  tmpvar_34.y = tmpvar_32;
  tmpvar_34.z = tmpvar_33;
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (tmpvar_34, 0.0, 1.0);
  highp vec3 tmpvar_36;
  tmpvar_36 = clamp (((tmpvar_27 * 0.2) + clamp ((tmpvar_35 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_25) + 1.5708));
  highp vec4 tmpvar_38;
  tmpvar_38.w = 0.0;
  tmpvar_38.xyz = ((((tmpvar_22 * (1.0 - dot (tmpvar_36, vec3(0.3, 0.59, 0.11)))) * (tmpvar_35 * tmpvar_27)) + (((((tmpvar_20 * tmpvar_26) * pow (max (0.0, dot (tmpvar_15, tmpvar_10)), tmpvar_25)) * (tmpvar_36 + ((1.0 - tmpvar_36) * pow ((1.0 - max (0.0, dot (tmpvar_15, tmpvar_14))), 5.0)))) * (1.0/((((tmpvar_26 * (1.0 - tmpvar_37)) + tmpvar_37) * ((max (0.0, dot (tmpvar_10, tmpvar_7)) * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_25 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_38;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec4 node_335_3;
  highp vec3 normalLocal_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = xlv_TEXCOORD3.x;
  tmpvar_6[0].y = xlv_TEXCOORD4.x;
  tmpvar_6[0].z = tmpvar_5.x;
  tmpvar_6[1].x = xlv_TEXCOORD3.y;
  tmpvar_6[1].y = xlv_TEXCOORD4.y;
  tmpvar_6[1].z = tmpvar_5.y;
  tmpvar_6[2].x = xlv_TEXCOORD3.z;
  tmpvar_6[2].y = xlv_TEXCOORD4.z;
  tmpvar_6[2].z = tmpvar_5.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_9;
  normal_9.xy = ((texture2D (_BumpTex, P_8).wy * 2.0) - 1.0);
  normal_9.z = sqrt((1.0 - clamp (dot (normal_9.xy, normal_9.xy), 0.0, 1.0)));
  normalLocal_4 = normal_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize((normalLocal_4 * tmpvar_6));
  lowp vec4 tmpvar_11;
  highp vec2 P_12;
  P_12 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_11 = texture2D (_MainTex, P_12);
  node_335_3 = tmpvar_11;
  highp float x_13;
  x_13 = (mix (1.0, node_335_3.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_13 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_7 + tmpvar_14));
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5);
  tmpvar_16 = texture2D (_LightTexture0, P_17);
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD5.xyz, xlv_TEXCOORD5.xyz);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = ((((float((xlv_TEXCOORD5.z > 0.0)) * tmpvar_16.w) * tmpvar_19.w) * 2.0) * _LightColor0.xyz);
  highp float tmpvar_21;
  tmpvar_21 = dot (tmpvar_10, tmpvar_14);
  highp vec3 tmpvar_22;
  tmpvar_22 = ((max (0.0, tmpvar_21) * 0.31831) * tmpvar_20);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_23 = texture2D (_MetRoughLum, P_24);
  node_42_2 = tmpvar_23;
  highp float tmpvar_25;
  tmpvar_25 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_3.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_26;
  tmpvar_26 = max (0.0, tmpvar_21);
  highp float tmpvar_27;
  tmpvar_27 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_28;
  tmpvar_28 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_29;
  b_29 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_3.xyz)));
  highp vec3 c_30;
  c_30 = ((2.0 * _Diffuse.xyz) * node_335_3.xyz);
  highp float tmpvar_31;
  if (tmpvar_28.x) {
    tmpvar_31 = b_29.x;
  } else {
    tmpvar_31 = c_30.x;
  };
  highp float tmpvar_32;
  if (tmpvar_28.y) {
    tmpvar_32 = b_29.y;
  } else {
    tmpvar_32 = c_30.y;
  };
  highp float tmpvar_33;
  if (tmpvar_28.z) {
    tmpvar_33 = b_29.z;
  } else {
    tmpvar_33 = c_30.z;
  };
  highp vec3 tmpvar_34;
  tmpvar_34.x = tmpvar_31;
  tmpvar_34.y = tmpvar_32;
  tmpvar_34.z = tmpvar_33;
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (tmpvar_34, 0.0, 1.0);
  highp vec3 tmpvar_36;
  tmpvar_36 = clamp (((tmpvar_27 * 0.2) + clamp ((tmpvar_35 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_25) + 1.5708));
  highp vec4 tmpvar_38;
  tmpvar_38.w = 0.0;
  tmpvar_38.xyz = ((((tmpvar_22 * (1.0 - dot (tmpvar_36, vec3(0.3, 0.59, 0.11)))) * (tmpvar_35 * tmpvar_27)) + (((((tmpvar_20 * tmpvar_26) * pow (max (0.0, dot (tmpvar_15, tmpvar_10)), tmpvar_25)) * (tmpvar_36 + ((1.0 - tmpvar_36) * pow ((1.0 - max (0.0, dot (tmpvar_15, tmpvar_14))), 5.0)))) * (1.0/((((tmpvar_26 * (1.0 - tmpvar_37)) + tmpvar_37) * ((max (0.0, dot (tmpvar_10, tmpvar_7)) * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_25 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_38;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec4 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec4 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp vec4 node_335_3;
  highp vec3 normalLocal_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = xlv_TEXCOORD3.x;
  tmpvar_6[0].y = xlv_TEXCOORD4.x;
  tmpvar_6[0].z = tmpvar_5.x;
  tmpvar_6[1].x = xlv_TEXCOORD3.y;
  tmpvar_6[1].y = xlv_TEXCOORD4.y;
  tmpvar_6[1].z = tmpvar_5.y;
  tmpvar_6[2].x = xlv_TEXCOORD3.z;
  tmpvar_6[2].y = xlv_TEXCOORD4.z;
  tmpvar_6[2].z = tmpvar_5.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture (_BumpTex, P_8).xyz * 2.0) - 1.0);
  normalLocal_4 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize((normalLocal_4 * tmpvar_6));
  lowp vec4 tmpvar_11;
  highp vec2 P_12;
  P_12 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_11 = texture (_MainTex, P_12);
  node_335_3 = tmpvar_11;
  highp float x_13;
  x_13 = (mix (1.0, node_335_3.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_13 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_7 + tmpvar_14));
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5);
  tmpvar_16 = texture (_LightTexture0, P_17);
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD5.xyz, xlv_TEXCOORD5.xyz);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_LightTextureB0, vec2(tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = ((((float((xlv_TEXCOORD5.z > 0.0)) * tmpvar_16.w) * tmpvar_19.w) * 2.0) * _LightColor0.xyz);
  highp float tmpvar_21;
  tmpvar_21 = dot (tmpvar_10, tmpvar_14);
  highp vec3 tmpvar_22;
  tmpvar_22 = ((max (0.0, tmpvar_21) * 0.31831) * tmpvar_20);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_23 = texture (_MetRoughLum, P_24);
  node_42_2 = tmpvar_23;
  highp float tmpvar_25;
  tmpvar_25 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_3.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_26;
  tmpvar_26 = max (0.0, tmpvar_21);
  highp float tmpvar_27;
  tmpvar_27 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_28;
  tmpvar_28 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_29;
  b_29 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_3.xyz)));
  highp vec3 c_30;
  c_30 = ((2.0 * _Diffuse.xyz) * node_335_3.xyz);
  highp float tmpvar_31;
  if (tmpvar_28.x) {
    tmpvar_31 = b_29.x;
  } else {
    tmpvar_31 = c_30.x;
  };
  highp float tmpvar_32;
  if (tmpvar_28.y) {
    tmpvar_32 = b_29.y;
  } else {
    tmpvar_32 = c_30.y;
  };
  highp float tmpvar_33;
  if (tmpvar_28.z) {
    tmpvar_33 = b_29.z;
  } else {
    tmpvar_33 = c_30.z;
  };
  highp vec3 tmpvar_34;
  tmpvar_34.x = tmpvar_31;
  tmpvar_34.y = tmpvar_32;
  tmpvar_34.z = tmpvar_33;
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (tmpvar_34, 0.0, 1.0);
  highp vec3 tmpvar_36;
  tmpvar_36 = clamp (((tmpvar_27 * 0.2) + clamp ((tmpvar_35 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_37;
  tmpvar_37 = inversesqrt(((0.785398 * tmpvar_25) + 1.5708));
  highp vec4 tmpvar_38;
  tmpvar_38.w = 0.0;
  tmpvar_38.xyz = ((((tmpvar_22 * (1.0 - dot (tmpvar_36, vec3(0.3, 0.59, 0.11)))) * (tmpvar_35 * tmpvar_27)) + (((((tmpvar_20 * tmpvar_26) * pow (max (0.0, dot (tmpvar_15, tmpvar_10)), tmpvar_25)) * (tmpvar_36 + ((1.0 - tmpvar_36) * pow ((1.0 - max (0.0, dot (tmpvar_15, tmpvar_14))), 5.0)))) * (1.0/((((tmpvar_26 * (1.0 - tmpvar_37)) + tmpvar_37) * ((max (0.0, dot (tmpvar_10, tmpvar_7)) * (1.0 - tmpvar_37)) + tmpvar_37))))) * ((tmpvar_25 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_38;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform mat4 _LightMatrix0;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform samplerCube _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_7;
  x_7 = (mix (1.0, tmpvar_6.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_7 < 0.0)) {
    discard;
  };
  vec3 tmpvar_8;
  tmpvar_8 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  vec3 tmpvar_9;
  tmpvar_9 = normalize((tmpvar_3 + tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10 = (((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5))).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w) * 2.0) * _LightColor0.xyz);
  float tmpvar_11;
  tmpvar_11 = dot (tmpvar_5, tmpvar_8);
  vec3 tmpvar_12;
  tmpvar_12 = ((max (0.0, tmpvar_11) * 0.31831) * tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  float tmpvar_14;
  tmpvar_14 = exp2(((mix (((tmpvar_13.y * -1.0) + 1.0), tmpvar_6.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  float tmpvar_15;
  tmpvar_15 = max (0.0, tmpvar_11);
  float tmpvar_16;
  tmpvar_16 = ((tmpvar_13.x * -1.0) + 1.0);
  bvec3 tmpvar_17;
  tmpvar_17 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_18;
  b_18 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_6.xyz)));
  vec3 c_19;
  c_19 = ((2.0 * _Diffuse.xyz) * tmpvar_6.xyz);
  float tmpvar_20;
  if (tmpvar_17.x) {
    tmpvar_20 = b_18.x;
  } else {
    tmpvar_20 = c_19.x;
  };
  float tmpvar_21;
  if (tmpvar_17.y) {
    tmpvar_21 = b_18.y;
  } else {
    tmpvar_21 = c_19.y;
  };
  float tmpvar_22;
  if (tmpvar_17.z) {
    tmpvar_22 = b_18.z;
  } else {
    tmpvar_22 = c_19.z;
  };
  vec3 tmpvar_23;
  tmpvar_23.x = tmpvar_20;
  tmpvar_23.y = tmpvar_21;
  tmpvar_23.z = tmpvar_22;
  vec3 tmpvar_24;
  tmpvar_24 = clamp (tmpvar_23, 0.0, 1.0);
  vec3 tmpvar_25;
  tmpvar_25 = clamp (((tmpvar_16 * 0.2) + clamp ((tmpvar_24 * tmpvar_13.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_26;
  tmpvar_26 = inversesqrt(((0.785398 * tmpvar_14) + 1.5708));
  vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = ((((tmpvar_12 * (1.0 - dot (tmpvar_25, vec3(0.3, 0.59, 0.11)))) * (tmpvar_24 * tmpvar_16)) + (((((tmpvar_10 * tmpvar_15) * pow (max (0.0, dot (tmpvar_9, tmpvar_5)), tmpvar_14)) * (tmpvar_25 + ((1.0 - tmpvar_25) * pow ((1.0 - max (0.0, dot (tmpvar_9, tmpvar_8))), 5.0)))) * (1.0/((((tmpvar_15 * (1.0 - tmpvar_26)) + tmpvar_26) * ((max (0.0, dot (tmpvar_5, tmpvar_3)) * (1.0 - tmpvar_26)) + tmpvar_26))))) * ((tmpvar_14 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 33 math
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c16.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c16.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mov o4.xyz, r1
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mul o5.xyz, r0.w, r2
mov o2, r1
dp4 o6.z, r1, c14
dp4 o6.y, r1, c13
dp4 o6.x, r1, c12
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
// Stats: 27 math
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 208
Matrix 16 [_LightMatrix0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedpgoikocoeepfnkgjiblmgnbjjmleglkiabaaaaaadeagaaaaadaaaaaa
cmaaaaaamaaaaaaajaabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
lmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaa
lmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcjmaeaaaaeaaaabaachabaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaacaaaaaa
egaobaaaaaaaaaaabaaaaaaibcaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabaaaaaaabaaaaaaiccaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabbaaaaaabaaaaaaiecaabaaaabaaaaaaegbcbaaaabaaaaaaegiccaaa
abaaaaaabcaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadgaaaaafhccabaaa
aeaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaadaaaaaacgajbaaaabaaaaaa
jgaebaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgaebaaaabaaaaaacgajbaaa
acaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgbpbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hccabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaakgakbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaaaaaaaaaaeaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture2D (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp float tmpvar_18;
  tmpvar_18 = ((texture2D (_LightTextureB0, vec2(tmpvar_17)).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w) * 2.0);
  attenuation_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_21;
  tmpvar_21 = ((max (0.0, tmpvar_20) * 0.31831) * tmpvar_19);
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_22 = texture2D (_MetRoughLum, P_23);
  node_42_2 = tmpvar_22;
  highp float tmpvar_24;
  tmpvar_24 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_20);
  highp float tmpvar_26;
  tmpvar_26 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  highp float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  highp float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  highp vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_36;
  tmpvar_36 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  highp vec4 tmpvar_37;
  tmpvar_37.w = 0.0;
  tmpvar_37.xyz = ((((tmpvar_21 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + (((((tmpvar_19 * tmpvar_25) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_36)) + tmpvar_36) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_36)) + tmpvar_36))))) * ((tmpvar_24 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture2D (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp float tmpvar_18;
  tmpvar_18 = ((texture2D (_LightTextureB0, vec2(tmpvar_17)).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w) * 2.0);
  attenuation_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_21;
  tmpvar_21 = ((max (0.0, tmpvar_20) * 0.31831) * tmpvar_19);
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_22 = texture2D (_MetRoughLum, P_23);
  node_42_2 = tmpvar_22;
  highp float tmpvar_24;
  tmpvar_24 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_20);
  highp float tmpvar_26;
  tmpvar_26 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  highp float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  highp float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  highp vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_36;
  tmpvar_36 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  highp vec4 tmpvar_37;
  tmpvar_37.w = 0.0;
  tmpvar_37.xyz = ((((tmpvar_21 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + (((((tmpvar_19 * tmpvar_25) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_36)) + tmpvar_36) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_36)) + tmpvar_36))))) * ((tmpvar_24 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp float tmpvar_18;
  tmpvar_18 = ((texture (_LightTextureB0, vec2(tmpvar_17)).w * texture (_LightTexture0, xlv_TEXCOORD5).w) * 2.0);
  attenuation_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_21;
  tmpvar_21 = ((max (0.0, tmpvar_20) * 0.31831) * tmpvar_19);
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_22 = texture (_MetRoughLum, P_23);
  node_42_2 = tmpvar_22;
  highp float tmpvar_24;
  tmpvar_24 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_25;
  tmpvar_25 = max (0.0, tmpvar_20);
  highp float tmpvar_26;
  tmpvar_26 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_27;
  tmpvar_27 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_28;
  b_28 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_29;
  c_29 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_30;
  if (tmpvar_27.x) {
    tmpvar_30 = b_28.x;
  } else {
    tmpvar_30 = c_29.x;
  };
  highp float tmpvar_31;
  if (tmpvar_27.y) {
    tmpvar_31 = b_28.y;
  } else {
    tmpvar_31 = c_29.y;
  };
  highp float tmpvar_32;
  if (tmpvar_27.z) {
    tmpvar_32 = b_28.z;
  } else {
    tmpvar_32 = c_29.z;
  };
  highp vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = tmpvar_31;
  tmpvar_33.z = tmpvar_32;
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (tmpvar_33, 0.0, 1.0);
  highp vec3 tmpvar_35;
  tmpvar_35 = clamp (((tmpvar_26 * 0.2) + clamp ((tmpvar_34 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_36;
  tmpvar_36 = inversesqrt(((0.785398 * tmpvar_24) + 1.5708));
  highp vec4 tmpvar_37;
  tmpvar_37.w = 0.0;
  tmpvar_37.xyz = ((((tmpvar_21 * (1.0 - dot (tmpvar_35, vec3(0.3, 0.59, 0.11)))) * (tmpvar_34 * tmpvar_26)) + (((((tmpvar_19 * tmpvar_25) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_24)) * (tmpvar_35 + ((1.0 - tmpvar_35) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_25 * (1.0 - tmpvar_36)) + tmpvar_36) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_36)) + tmpvar_36))))) * ((tmpvar_24 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_37;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL
#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform mat4 _LightMatrix0;
attribute vec4 TANGENT;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * _World2Object).xyz;
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = TANGENT.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = normalize((_Object2World * tmpvar_3).xyz);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize((((tmpvar_2.yzx * tmpvar_4.zxy) - (tmpvar_2.zxy * tmpvar_4.yzx)) * TANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform vec4 _BumpTex_ST;
uniform float _DiffuseHasAlphaclip;
uniform float _DiffuseHasRoughness;
uniform float _Opacity;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(xlv_TEXCOORD2);
  mat3 tmpvar_2;
  tmpvar_2[0].x = xlv_TEXCOORD3.x;
  tmpvar_2[0].y = xlv_TEXCOORD4.x;
  tmpvar_2[0].z = tmpvar_1.x;
  tmpvar_2[1].x = xlv_TEXCOORD3.y;
  tmpvar_2[1].y = xlv_TEXCOORD4.y;
  tmpvar_2[1].z = tmpvar_1.y;
  tmpvar_2[2].x = xlv_TEXCOORD3.z;
  tmpvar_2[2].y = xlv_TEXCOORD4.z;
  tmpvar_2[2].z = tmpvar_1.z;
  vec3 tmpvar_3;
  tmpvar_3 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpTex, ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw)).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((normal_4 * tmpvar_2));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw));
  float x_7;
  x_7 = (mix (1.0, tmpvar_6.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_7 < 0.0)) {
    discard;
  };
  vec3 tmpvar_8;
  tmpvar_8 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  vec3 tmpvar_9;
  tmpvar_9 = normalize((tmpvar_3 + tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_LightTexture0, xlv_TEXCOORD5).w * 2.0) * _LightColor0.xyz);
  float tmpvar_11;
  tmpvar_11 = dot (tmpvar_5, tmpvar_8);
  vec3 tmpvar_12;
  tmpvar_12 = ((max (0.0, tmpvar_11) * 0.31831) * tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MetRoughLum, ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw));
  float tmpvar_14;
  tmpvar_14 = exp2(((mix (((tmpvar_13.y * -1.0) + 1.0), tmpvar_6.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  float tmpvar_15;
  tmpvar_15 = max (0.0, tmpvar_11);
  float tmpvar_16;
  tmpvar_16 = ((tmpvar_13.x * -1.0) + 1.0);
  bvec3 tmpvar_17;
  tmpvar_17 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  vec3 b_18;
  b_18 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - tmpvar_6.xyz)));
  vec3 c_19;
  c_19 = ((2.0 * _Diffuse.xyz) * tmpvar_6.xyz);
  float tmpvar_20;
  if (tmpvar_17.x) {
    tmpvar_20 = b_18.x;
  } else {
    tmpvar_20 = c_19.x;
  };
  float tmpvar_21;
  if (tmpvar_17.y) {
    tmpvar_21 = b_18.y;
  } else {
    tmpvar_21 = c_19.y;
  };
  float tmpvar_22;
  if (tmpvar_17.z) {
    tmpvar_22 = b_18.z;
  } else {
    tmpvar_22 = c_19.z;
  };
  vec3 tmpvar_23;
  tmpvar_23.x = tmpvar_20;
  tmpvar_23.y = tmpvar_21;
  tmpvar_23.z = tmpvar_22;
  vec3 tmpvar_24;
  tmpvar_24 = clamp (tmpvar_23, 0.0, 1.0);
  vec3 tmpvar_25;
  tmpvar_25 = clamp (((tmpvar_16 * 0.2) + clamp ((tmpvar_24 * tmpvar_13.x), 0.0, 1.0)), 0.0, 1.0);
  float tmpvar_26;
  tmpvar_26 = inversesqrt(((0.785398 * tmpvar_14) + 1.5708));
  vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = ((((tmpvar_12 * (1.0 - dot (tmpvar_25, vec3(0.3, 0.59, 0.11)))) * (tmpvar_24 * tmpvar_16)) + (((((tmpvar_10 * tmpvar_15) * pow (max (0.0, dot (tmpvar_9, tmpvar_5)), tmpvar_14)) * (tmpvar_25 + ((1.0 - tmpvar_25) * pow ((1.0 - max (0.0, dot (tmpvar_9, tmpvar_8))), 5.0)))) * (1.0/((((tmpvar_15 * (1.0 - tmpvar_26)) + tmpvar_26) * ((max (0.0, dot (tmpvar_5, tmpvar_3)) * (1.0 - tmpvar_26)) + tmpvar_26))))) * ((tmpvar_14 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 32 math
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dcl_texcoord0 v3
mov r0.w, c16.x
mov r0.xyz, v2
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c16.x
mul r2.xyz, r0.zxyw, r1.yzxw
mad r2.xyz, r0.yzxw, r1.zxyw, -r2
mov o4.xyz, r1
mul r2.xyz, v2.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mul o5.xyz, r0.w, r2
mov o2, r1
dp4 o6.y, r1, c13
dp4 o6.x, r1, c12
mov o3.xyz, r0
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
// Stats: 27 math
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 208
Matrix 16 [_LightMatrix0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedmdfgjhoeogphpponijlbnkfloaemelddabaaaaaadeagaaaaadaaaaaa
cmaaaaaamaaaaaaajaabaaaaejfdeheoimaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaahiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaiaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeebeoehefeofeaafeeffiedepepfceeaaklklkl
epfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
lmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaa
lmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcjmaeaaaaeaaaabaachabaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaadpcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaaacaaaaaa
dcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaabaaaaaaagaabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaa
kgakbaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiecaaa
aaaaaaaaaeaaaaaapgapbaaaaaaaaaaaagaebaaaabaaaaaadgaaaaafpccabaaa
acaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaabaaaaaabaaaaaaa
baaaaaaiccaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaabaaaaaabbaaaaaa
baaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaaegiccaaaabaaaaaabcaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture2D (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  lowp float tmpvar_17;
  tmpvar_17 = (texture2D (_LightTexture0, xlv_TEXCOORD5).w * 2.0);
  attenuation_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((max (0.0, tmpvar_19) * 0.31831) * tmpvar_18);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  highp float tmpvar_23;
  tmpvar_23 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_24;
  tmpvar_24 = max (0.0, tmpvar_19);
  highp float tmpvar_25;
  tmpvar_25 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_26;
  tmpvar_26 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_27;
  b_27 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_28;
  c_28 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_29;
  if (tmpvar_26.x) {
    tmpvar_29 = b_27.x;
  } else {
    tmpvar_29 = c_28.x;
  };
  highp float tmpvar_30;
  if (tmpvar_26.y) {
    tmpvar_30 = b_27.y;
  } else {
    tmpvar_30 = c_28.y;
  };
  highp float tmpvar_31;
  if (tmpvar_26.z) {
    tmpvar_31 = b_27.z;
  } else {
    tmpvar_31 = c_28.z;
  };
  highp vec3 tmpvar_32;
  tmpvar_32.x = tmpvar_29;
  tmpvar_32.y = tmpvar_30;
  tmpvar_32.z = tmpvar_31;
  highp vec3 tmpvar_33;
  tmpvar_33 = clamp (tmpvar_32, 0.0, 1.0);
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (((tmpvar_25 * 0.2) + clamp ((tmpvar_33 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_35;
  tmpvar_35 = inversesqrt(((0.785398 * tmpvar_23) + 1.5708));
  highp vec4 tmpvar_36;
  tmpvar_36.w = 0.0;
  tmpvar_36.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_34, vec3(0.3, 0.59, 0.11)))) * (tmpvar_33 * tmpvar_25)) + (((((tmpvar_18 * tmpvar_24) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_23)) * (tmpvar_34 + ((1.0 - tmpvar_34) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_24 * (1.0 - tmpvar_35)) + tmpvar_35) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_35)) + tmpvar_35))))) * ((tmpvar_23 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_36;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 normal_10;
  normal_10.xy = ((texture2D (_BumpTex, P_9).wy * 2.0) - 1.0);
  normal_10.z = sqrt((1.0 - clamp (dot (normal_10.xy, normal_10.xy), 0.0, 1.0)));
  normalLocal_5 = normal_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture2D (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  lowp float tmpvar_17;
  tmpvar_17 = (texture2D (_LightTexture0, xlv_TEXCOORD5).w * 2.0);
  attenuation_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((max (0.0, tmpvar_19) * 0.31831) * tmpvar_18);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture2D (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  highp float tmpvar_23;
  tmpvar_23 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_24;
  tmpvar_24 = max (0.0, tmpvar_19);
  highp float tmpvar_25;
  tmpvar_25 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_26;
  tmpvar_26 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_27;
  b_27 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_28;
  c_28 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_29;
  if (tmpvar_26.x) {
    tmpvar_29 = b_27.x;
  } else {
    tmpvar_29 = c_28.x;
  };
  highp float tmpvar_30;
  if (tmpvar_26.y) {
    tmpvar_30 = b_27.y;
  } else {
    tmpvar_30 = c_28.y;
  };
  highp float tmpvar_31;
  if (tmpvar_26.z) {
    tmpvar_31 = b_27.z;
  } else {
    tmpvar_31 = c_28.z;
  };
  highp vec3 tmpvar_32;
  tmpvar_32.x = tmpvar_29;
  tmpvar_32.y = tmpvar_30;
  tmpvar_32.z = tmpvar_31;
  highp vec3 tmpvar_33;
  tmpvar_33 = clamp (tmpvar_32, 0.0, 1.0);
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (((tmpvar_25 * 0.2) + clamp ((tmpvar_33 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_35;
  tmpvar_35 = inversesqrt(((0.785398 * tmpvar_23) + 1.5708));
  highp vec4 tmpvar_36;
  tmpvar_36.w = 0.0;
  tmpvar_36.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_34, vec3(0.3, 0.59, 0.11)))) * (tmpvar_33 * tmpvar_25)) + (((((tmpvar_18 * tmpvar_24) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_23)) * (tmpvar_34 + ((1.0 - tmpvar_34) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_24 * (1.0 - tmpvar_35)) + tmpvar_35) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_35)) + tmpvar_35))))) * ((tmpvar_23 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_36;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp mat4 _LightMatrix0;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * _World2Object).xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((_Object2World * tmpvar_4).xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = normalize((((tmpvar_3.yzx * tmpvar_5.zxy) - (tmpvar_3.zxy * tmpvar_5.yzx)) * _glesTANGENT.w));
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Diffuse;
uniform sampler2D _MetRoughLum;
uniform highp vec4 _MetRoughLum_ST;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform sampler2D _BumpTex;
uniform highp vec4 _BumpTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
uniform lowp float _DiffuseHasRoughness;
uniform highp float _Opacity;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_42_2;
  highp float attenuation_3;
  highp vec4 node_335_4;
  highp vec3 normalLocal_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = xlv_TEXCOORD3.x;
  tmpvar_7[0].y = xlv_TEXCOORD4.x;
  tmpvar_7[0].z = tmpvar_6.x;
  tmpvar_7[1].x = xlv_TEXCOORD3.y;
  tmpvar_7[1].y = xlv_TEXCOORD4.y;
  tmpvar_7[1].z = tmpvar_6.y;
  tmpvar_7[2].x = xlv_TEXCOORD3.z;
  tmpvar_7[2].y = xlv_TEXCOORD4.z;
  tmpvar_7[2].z = tmpvar_6.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1.xyz));
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 * _BumpTex_ST.xy) + _BumpTex_ST.zw);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture (_BumpTex, P_9).xyz * 2.0) - 1.0);
  normalLocal_5 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((normalLocal_5 * tmpvar_7));
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((xlv_TEXCOORD0 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_12 = texture (_MainTex, P_13);
  node_335_4 = tmpvar_12;
  highp float x_14;
  x_14 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_14 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(mix (_WorldSpaceLightPos0.xyz, (_WorldSpaceLightPos0.xyz - xlv_TEXCOORD1.xyz), _WorldSpaceLightPos0.www));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_8 + tmpvar_15));
  lowp float tmpvar_17;
  tmpvar_17 = (texture (_LightTexture0, xlv_TEXCOORD5).w * 2.0);
  attenuation_3 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (attenuation_3 * _LightColor0.xyz);
  highp float tmpvar_19;
  tmpvar_19 = dot (tmpvar_11, tmpvar_15);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((max (0.0, tmpvar_19) * 0.31831) * tmpvar_18);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((xlv_TEXCOORD0 * _MetRoughLum_ST.xy) + _MetRoughLum_ST.zw);
  tmpvar_21 = texture (_MetRoughLum, P_22);
  node_42_2 = tmpvar_21;
  highp float tmpvar_23;
  tmpvar_23 = exp2(((mix (((node_42_2.y * -1.0) + 1.0), node_335_4.w, _DiffuseHasRoughness) * 10.0) + 1.0));
  highp float tmpvar_24;
  tmpvar_24 = max (0.0, tmpvar_19);
  highp float tmpvar_25;
  tmpvar_25 = ((node_42_2.x * -1.0) + 1.0);
  bvec3 tmpvar_26;
  tmpvar_26 = greaterThan (_Diffuse.xyz, vec3(0.5, 0.5, 0.5));
  highp vec3 b_27;
  b_27 = (1.0 - ((1.0 - (2.0 * (_Diffuse.xyz - 0.5))) * (1.0 - node_335_4.xyz)));
  highp vec3 c_28;
  c_28 = ((2.0 * _Diffuse.xyz) * node_335_4.xyz);
  highp float tmpvar_29;
  if (tmpvar_26.x) {
    tmpvar_29 = b_27.x;
  } else {
    tmpvar_29 = c_28.x;
  };
  highp float tmpvar_30;
  if (tmpvar_26.y) {
    tmpvar_30 = b_27.y;
  } else {
    tmpvar_30 = c_28.y;
  };
  highp float tmpvar_31;
  if (tmpvar_26.z) {
    tmpvar_31 = b_27.z;
  } else {
    tmpvar_31 = c_28.z;
  };
  highp vec3 tmpvar_32;
  tmpvar_32.x = tmpvar_29;
  tmpvar_32.y = tmpvar_30;
  tmpvar_32.z = tmpvar_31;
  highp vec3 tmpvar_33;
  tmpvar_33 = clamp (tmpvar_32, 0.0, 1.0);
  highp vec3 tmpvar_34;
  tmpvar_34 = clamp (((tmpvar_25 * 0.2) + clamp ((tmpvar_33 * node_42_2.x), 0.0, 1.0)), 0.0, 1.0);
  highp float tmpvar_35;
  tmpvar_35 = inversesqrt(((0.785398 * tmpvar_23) + 1.5708));
  highp vec4 tmpvar_36;
  tmpvar_36.w = 0.0;
  tmpvar_36.xyz = ((((tmpvar_20 * (1.0 - dot (tmpvar_34, vec3(0.3, 0.59, 0.11)))) * (tmpvar_33 * tmpvar_25)) + (((((tmpvar_18 * tmpvar_24) * pow (max (0.0, dot (tmpvar_16, tmpvar_11)), tmpvar_23)) * (tmpvar_34 + ((1.0 - tmpvar_34) * pow ((1.0 - max (0.0, dot (tmpvar_16, tmpvar_15))), 5.0)))) * (1.0/((((tmpvar_24 * (1.0 - tmpvar_35)) + tmpvar_35) * ((max (0.0, dot (tmpvar_11, tmpvar_8)) * (1.0 - tmpvar_35)) + tmpvar_35))))) * ((tmpvar_23 + 8.0) / 25.1327))) * ((_Opacity * -1.0) + 1.0));
  tmpvar_1 = tmpvar_36;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "POINT" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 97 math, 5 textures
Keywords { "POINT" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_Diffuse]
Vector 4 [_MetRoughLum_ST]
Vector 5 [_MainTex_ST]
Vector 6 [_BumpTex_ST]
Float 7 [_DiffuseHasAlphaclip]
Float 8 [_DiffuseHasRoughness]
Float 9 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_MetRoughLum] 2D 3
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c10, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c11, 2.00000000, -1.00000000, -0.50000000, 1.00000000
def c12, 0.20000000, 0.30000001, 0.58999997, 0.11000000
def c13, 10.00000000, 1.00000000, 8.00000000, 5.00000000
def c14, 0.78539819, 1.57079637, 0.03978873, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r0.yw, r0, s0
mad_pp r1.zw, r0.xywy, c11.x, c11.y
mul_pp r1.xy, r1.zwzw, r1.zwzw
add_pp_sat r1.x, r1, r1.y
mul r0.xyz, r1.w, v4
add_pp r1.x, -r1, c10.w
mad r5.xy, v0, c4, c4.zwzw
texld r7.xy, r5, s3
dp3 r0.w, v2, v2
mov r5.xyz, c3
mad r0.xyz, r1.z, v3, r0
rsq_pp r1.w, r1.x
rsq r0.w, r0.w
mul r1.xyz, r0.w, v2
rcp_pp r0.w, r1.w
mad r1.xyz, r0.w, r1, r0
add r2.xyz, -v1, c0
mad r0.xyz, -v1, c1.w, c1
dp3 r0.w, r2, r2
dp3 r1.w, r0, r0
rsq r0.w, r0.w
mul r3.xyz, r0.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
add r0.xyz, r2, r3
dp3 r0.w, r0, r0
dp3 r2.w, r1, r1
rsq r1.w, r2.w
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
mul r1.xyz, r1.w, r1
mad r0.xy, v0, c5, c5.zwzw
dp3 r1.w, r1, r4
texld r0, r0, s1
add r3.w, -r7.y, c10
add r2.w, r0, -r3
mad r2.w, r2, c8.x, r3
max r3.w, r1, c10.z
mad r1.w, r2, c13.x, c13.y
dp3 r2.w, r2, r4
dp3 r2.x, r1, r2
exp r1.w, r1.w
mul r4.xyz, r0, c3
max r2.y, r2.x, c10.z
mad r4.w, r1, c14.x, c14.y
pow r6, r3.w, r1.w
add r5.xyz, c11.z, r5
mad r6.yzw, -r5.xxyz, c11.x, c11.w
max r2.w, r2, c10.z
add r0.xyz, -r0, c10.w
add r0.w, r0, c10.x
dp3 r1.y, r1, r3
dp3 r2.x, v5, v5
texld r1.x, r2.x, s2
max r2.x, r1.y, c10.z
mul r1.xyz, r1.x, c2
mul r1.xyz, r1, c11.x
rsq r4.w, r4.w
mul r1.xyz, r2.y, r1
add r2.w, -r2, c10
mul_sat r4.xyz, r4, c11.x
mad_sat r0.xyz, -r6.yzww, r0, c10.w
cmp r0.xyz, -r5, r4, r0
pow r5, r2.w, c13.w
add r5.w, -r4, c10
add r2.w, -r7.x, c10
mul_sat r4.xyz, r7.x, r0
mad_sat r4.xyz, r2.w, c12.x, r4
mov r3.w, r5.x
add r5.xyz, -r4, c10.w
mad r5.xyz, r5, r3.w, r4
mad r2.z, r2.y, r5.w, r4.w
mad r2.x, r5.w, r2, r4.w
mul r3.x, r2.z, r2
mov r3.w, r6.x
mul r2.xyz, r1, r3.w
rcp r3.x, r3.x
mul r2.xyz, r2, r5
mul r2.xyz, r2, r3.x
add r1.w, r1, c13.z
mul r2.xyz, r1.w, r2
dp3 r3.x, r4, c12.yzww
add r1.w, -r3.x, c10
mul r2.xyz, r2, c14.z
mul r1.xyz, r1, r1.w
mul r0.xyz, r2.w, r0
mul r0.xyz, r1, r0
mad r1.xyz, r0, c14.w, r2
mul r0.w, r0, c7.x
add r0.y, r0.w, c10
mov r0.x, c9
cmp r0.y, r0, c10.z, c10.w
add r0.x, c10.w, -r0
mov_pp r2, -r0.y
mul oC0.xyz, r1, r0.x
texkill r2.xyzw
mov_pp oC0.w, c10.z
"
}
SubProgram "d3d11 " {
// Stats: 89 math, 4 textures
Keywords { "POINT" }
SetTexture 0 [_BumpTex] 2D 3
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
SetTexture 3 [_MetRoughLum] 2D 1
ConstBuffer "$Globals" 208
Vector 80 [_LightColor0]
Vector 96 [_Diffuse]
Vector 112 [_MetRoughLum_ST]
Vector 128 [_MainTex_ST]
Vector 144 [_BumpTex_ST]
Float 160 [_DiffuseHasAlphaclip]
Float 164 [_DiffuseHasRoughness]
Float 192 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
eefiecedkacacghckgbedocbfmigfjfiljpcicidabaaaaaaeaaoaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcaianaaaaeaaaaaaaecadaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaad
hcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaiaaaaaadcaaaaal
dcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaa
aaaaaaaaaiaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaaaaaaaaaaakaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaadcaaaaamhcaabaaa
abaaaaaapgipcaaaacaaaaaaaaaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaa
acaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaa
egbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
adaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaadkaabaaa
acaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaa
aaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaiaebaaaaaa
aeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaiaebaaaaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaa
aeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaagaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaaegiccaaaaaaaaaaaagaaaaaadhcaaaajhcaabaaaaaaaaaaa
egacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaaldcaabaaa
aeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
ahaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaaadaaaaaa
aagabaaaabaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaaagaabaaa
aeaaaaaaaaaaaaaldcaabaaaaeaaaaaabgafbaiaebaaaaaaaeaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaaaaaaaaaaaaadccaaaamhcaabaaaafaaaaaafgafbaaa
aeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaaafaaaaaa
aaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaagaaaaaaegacbaaaagaaaaaa
pgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaakicaabaaaabaaaaaaegacbaaa
afaaaaaaaceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaa
acaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaacaaaaaaegbcbaaa
adaaaaaadcaaaaalmcaabaaaaeaaaaaaagbebaaaabaaaaaaagiecaaaaaaaaaaa
ajaaaaaakgiocaaaaaaaaaaaajaaaaaaefaaaaajpcaabaaaahaaaaaaogakbaaa
aeaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadcaaaaapmcaabaaaaeaaaaaa
pgahbaaaahaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaaaaaaaaaaaaaaaaialpaaaaialpdiaaaaahhcaabaaaahaaaaaapgapbaaa
aeaaaaaaegbcbaaaafaaaaaadcaaaaajhcaabaaaahaaaaaakgakbaaaaeaaaaaa
egbcbaaaaeaaaaaaegacbaaaahaaaaaaapaaaaahicaabaaaacaaaaaaogakbaaa
aeaaaaaaogakbaaaaeaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaa
abeaaaaaaaaaiadpelaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaaj
hcaabaaaafaaaaaapgapbaaaacaaaaaaegacbaaaafaaaaaaegacbaaaahaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaafaaaaaaegacbaaaafaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaa
acaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaadaaaaaa
egacbaaaafaaaaaadeaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaa
aaaaaaaabkiacaaaaaaaaaaaakaaaaaadkaabaaaaaaaaaaaakaabaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaaeaaaaaadcaaaaaj
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaadkaabaaaaaaaaaaabjaaaaaficaabaaaacaaaaaadkaabaaa
acaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaabaaaaaa
baaaaaahccaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadeaaaaak
dcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaagaaaaaaegbcbaaaagaaaaaa
efaaaaajpcaabaaaadaaaaaakgakbaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaaaaaaaaahecaabaaaabaaaaaaakaabaaaadaaaaaaakaabaaaadaaaaaa
diaaaaaihcaabaaaacaaaaaakgakbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaadaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaacaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaa
adaaaaaaegacbaaaagaaaaaaegacbaaaadaaaaaadcaaaaajecaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaidpjccdnelaaaaafecaabaaaabaaaaaackaabaaa
abaaaaaaaoaaaaakecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpckaabaaaabaaaaaaaaaaaaaiicaabaaaacaaaaaackaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaabaaaaaabkaabaaaabaaaaaa
dkaabaaaacaaaaaackaabaaaabaaaaaadcaaaaajecaabaaaabaaaaaaakaabaaa
abaaaaaadkaabaaaacaaaaaackaabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaacaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaackaabaaa
abaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaa
egacbaaaadaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaaaaaaaaajicaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaa
amaaaaaaabeaaaaaaaaaiadpdiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}
SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 96 math, 4 textures
Keywords { "DIRECTIONAL" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_Diffuse]
Vector 4 [_MetRoughLum_ST]
Vector 5 [_MainTex_ST]
Vector 6 [_BumpTex_ST]
Float 7 [_DiffuseHasAlphaclip]
Float 8 [_DiffuseHasRoughness]
Float 9 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 2
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c10, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c11, 2.00000000, -1.00000000, -0.50000000, 1.00000000
def c12, 0.20000000, 0.30000001, 0.58999997, 0.11000000
def c13, 10.00000000, 1.00000000, 8.00000000, 5.00000000
def c14, 0.78539819, 1.57079637, 0.03978873, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r0.yw, r0, s0
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r1.xy, r0, r0
add_pp_sat r0.w, r1.x, r1.y
mul r2.xyz, r0.y, v4
mad r0.xyz, r0.x, v3, r2
add r2.xyz, -v1, c0
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.x, v2, v2
add_pp r0.w, -r0, c10
rsq r1.x, r1.x
rsq_pp r0.w, r0.w
mul r4.xyz, r2.w, r2
mul r1.xyz, r1.x, v2
rcp_pp r0.w, r0.w
mad r0.xyz, r0.w, r1, r0
dp3 r0.w, r0, r0
mad_pp r1.xyz, -v1, c1.w, c1
rsq r0.w, r0.w
mul r6.xyz, r0.w, r0
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r5.xyz, r1.w, r1
add r2.xyz, r5, r4
dp3 r0.z, r2, r2
mad r0.xy, v0, c4, c4.zwzw
texld r3.xy, r0, s2
mad r0.xy, v0, c5, c5.zwzw
texld r1, r0, s1
add r0.w, -r3.y, c10
add r2.w, r1, -r0
mad r0.w, r2, c8.x, r0
mad r0.w, r0, c13.x, c13.y
rsq r0.z, r0.z
mul r0.xyz, r0.z, r2
dp3 r2.x, r6, r0
exp r4.w, r0.w
dp3 r2.y, r5, r0
max r2.x, r2, c10.z
pow r0, r2.x, r4.w
max r0.y, r2, c10.z
mov r2.xyz, c3
add r5.w, -r0.y, c10
mul r0.yzw, r1.xxyz, c3.xxyz
add r3.yzw, -r1.xxyz, c10.w
add r2.xyz, c11.z, r2
mad r1.xyz, -r2, c11.x, c11.w
mad_sat r1.xyz, -r1, r3.yzww, c10.w
mul_sat r0.yzw, r0, c11.x
cmp r1.xyz, -r2, r0.yzww, r1
pow r2, r5.w, c13.w
mul_sat r0.yzw, r3.x, r1.xxyz
add r2.w, -r3.x, c10
mad_sat r3.xyz, r2.w, c12.x, r0.yzww
mov r0.y, r2.x
mov r0.w, r0.x
mad r0.x, r4.w, c14, c14.y
rsq r3.w, r0.x
add r2.xyz, -r3, c10.w
mad r2.xyz, r2, r0.y, r3
dp3 r0.y, r6, r4
dp3 r0.x, r6, r5
add r4.y, -r3.w, c10.w
max r4.x, r0, c10.z
max r5.x, r0.y, c10.z
mad r4.z, r4.x, r4.y, r3.w
mad r3.w, r4.y, r5.x, r3
mov r0.xyz, c2
mul r0.xyz, c11.x, r0
mul r3.w, r4.z, r3
mul r4.xyz, r4.x, r0
mul r0.xyz, r4, r0.w
mul r0.xyz, r0, r2
rcp r0.w, r3.w
mul r0.xyz, r0, r0.w
add r2.x, r4.w, c13.z
mul r0.xyz, r2.x, r0
dp3 r0.w, r3, c12.yzww
add r0.w, -r0, c10
mul r2.xyz, r4, r0.w
add r0.w, r1, c10.x
mul r1.xyz, r2.w, r1
mul r0.xyz, r0, c14.z
mul r1.xyz, r2, r1
mad r1.xyz, r1, c14.w, r0
mul r0.w, r0, c7.x
add r0.x, r0.w, c10.y
mov r0.y, c9.x
add r1.w, c10, -r0.y
cmp r0.x, r0, c10.z, c10.w
mov_pp r0, -r0.x
mul oC0.xyz, r1, r1.w
texkill r0.xyzw
mov_pp oC0.w, c10.z
"
}
SubProgram "d3d11 " {
// Stats: 87 math, 3 textures
Keywords { "DIRECTIONAL" }
SetTexture 0 [_BumpTex] 2D 2
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_MetRoughLum] 2D 0
ConstBuffer "$Globals" 144
Vector 16 [_LightColor0]
Vector 32 [_Diffuse]
Vector 48 [_MetRoughLum_ST]
Vector 64 [_MainTex_ST]
Vector 80 [_BumpTex_ST]
Float 96 [_DiffuseHasAlphaclip]
Float 100 [_DiffuseHasRoughness]
Float 128 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
eefiecedjbdeolpkflgonjnncjhhdbgpjggnahejabaaaaaakianaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefciiamaaaa
eaaaaaaaccadaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaiaaaaaadcaaaaal
dcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaaeaaaaaaogikcaaa
aaaaaaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaadcaaaaamhcaabaaa
abaaaaaapgipcaaaacaaaaaaaaaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaa
acaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaa
egbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
adaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaadkaabaaa
acaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaa
aaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaiaebaaaaaa
aeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaiaebaaaaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaa
aeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaaegiccaaaaaaaaaaaacaaaaaadhcaaaajhcaabaaaaaaaaaaa
egacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaaldcaabaaa
aeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaa
adaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaaacaaaaaa
aagabaaaaaaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaaagaabaaa
aeaaaaaaaaaaaaaldcaabaaaaeaaaaaabgafbaiaebaaaaaaaeaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaaaaaaaaaaaaadccaaaamhcaabaaaafaaaaaafgafbaaa
aeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaaafaaaaaa
aaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaagaaaaaaegacbaaaagaaaaaa
pgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaakicaabaaaabaaaaaaegacbaaa
afaaaaaaaceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaa
acaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaacaaaaaaegbcbaaa
adaaaaaadcaaaaalmcaabaaaaeaaaaaaagbebaaaabaaaaaaagiecaaaaaaaaaaa
afaaaaaakgiocaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaahaaaaaaogakbaaa
aeaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaapmcaabaaaaeaaaaaa
pgahbaaaahaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaaaaaaaaaaaaaaaaialpaaaaialpdiaaaaahhcaabaaaahaaaaaapgapbaaa
aeaaaaaaegbcbaaaafaaaaaadcaaaaajhcaabaaaahaaaaaakgakbaaaaeaaaaaa
egbcbaaaaeaaaaaaegacbaaaahaaaaaaapaaaaahicaabaaaacaaaaaaogakbaaa
aeaaaaaaogakbaaaaeaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaa
abeaaaaaaaaaiadpelaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaaj
hcaabaaaafaaaaaapgapbaaaacaaaaaaegacbaaaafaaaaaaegacbaaaahaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaafaaaaaaegacbaaaafaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaa
acaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaadaaaaaa
egacbaaaafaaaaaadeaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaa
aaaaaaaabkiacaaaaaaaaaaaagaaaaaadkaabaaaaaaaaaaaakaabaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaaeaaaaaadcaaaaaj
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaadkaabaaaaaaaaaaabjaaaaaficaabaaaacaaaaaadkaabaaa
acaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaabaaaaaa
baaaaaahccaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadeaaaaak
dcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaajhcaabaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaacaaaaaaegacbaaaadaaaaaa
diaaaaahhcaabaaaadaaaaaaegacbaaaagaaaaaaegacbaaaadaaaaaadcaaaaaj
ecaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdp
aaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaidpjccdnelaaaaafecaabaaa
abaaaaaackaabaaaabaaaaaaaoaaaaakecaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpckaabaaaabaaaaaaaaaaaaaiicaabaaaacaaaaaa
ckaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaabaaaaaa
bkaabaaaabaaaaaadkaabaaaacaaaaaackaabaaaabaaaaaadcaaaaajecaabaaa
abaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaackaabaaaabaaaaaadiaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaa
abaaaaaackaabaaaabaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
agaabaaaabaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajicaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaaiaaaaaaabeaaaaaaaaaiadpdiaaaaahhccabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 102 math, 6 textures
Keywords { "SPOT" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_Diffuse]
Vector 4 [_MetRoughLum_ST]
Vector 5 [_MainTex_ST]
Vector 6 [_BumpTex_ST]
Float 7 [_DiffuseHasAlphaclip]
Float 8 [_DiffuseHasRoughness]
Float 9 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_MetRoughLum] 2D 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c11, 2.00000000, -1.00000000, -0.50000000, 1.00000000
def c12, 0.20000000, 0.30000001, 0.58999997, 0.11000000
def c13, 10.00000000, 1.00000000, 8.00000000, 5.00000000
def c14, 0.78539819, 1.57079637, 0.03978873, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5
mad r0.xy, v0, c6, c6.zwzw
texld r0.yw, r0, s0
mad_pp r1.zw, r0.xywy, c11.x, c11.y
mul_pp r1.xy, r1.zwzw, r1.zwzw
add_pp_sat r1.x, r1, r1.y
mul r0.xyz, r1.w, v4
add_pp r1.x, -r1, c10.w
mad r5.xy, v0, c4, c4.zwzw
texld r7.xy, r5, s4
dp3 r0.w, v2, v2
mov r5.xyz, c3
mad r0.xyz, r1.z, v3, r0
rsq_pp r1.w, r1.x
rsq r0.w, r0.w
mul r1.xyz, r0.w, v2
rcp_pp r0.w, r1.w
mad r1.xyz, r0.w, r1, r0
add r2.xyz, -v1, c0
mad r0.xyz, -v1, c1.w, c1
dp3 r0.w, r2, r2
dp3 r1.w, r0, r0
rsq r0.w, r0.w
mul r3.xyz, r0.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
add r0.xyz, r2, r3
dp3 r0.w, r0, r0
dp3 r2.w, r1, r1
rsq r1.w, r2.w
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
mul r1.xyz, r1.w, r1
mad r0.xy, v0, c5, c5.zwzw
dp3 r1.w, r1, r4
texld r0, r0, s1
add r3.w, -r7.y, c10
add r2.w, r0, -r3
mad r2.w, r2, c8.x, r3
max r3.w, r1, c10.z
mad r1.w, r2, c13.x, c13.y
dp3 r2.w, r2, r4
dp3 r2.x, r1, r2
dp3 r1.y, r1, r3
mul r4.xyz, r0, c3
max r2.z, r2.x, c10
exp r1.w, r1.w
pow r6, r3.w, r1.w
add r5.xyz, c11.z, r5
mad r6.yzw, -r5.xxyz, c11.x, c11.w
max r2.w, r2, c10.z
add r0.xyz, -r0, c10.w
rcp r2.x, v5.w
dp3 r1.x, v5, v5
add r0.w, r0, c10.x
mad r2.xy, v5, r2.x, c10.y
add r2.w, -r2, c10
mad_sat r0.xyz, -r6.yzww, r0, c10.w
mul_sat r4.xyz, r4, c11.x
cmp r0.xyz, -r5, r4, r0
pow r5, r2.w, c13.w
mov r2.w, r5.x
mul_sat r4.xyz, r7.x, r0
add r3.w, -r7.x, c10
mad_sat r4.xyz, r3.w, c12.x, r4
add r5.xyz, -r4, c10.w
mad r5.xyz, r5, r2.w, r4
mad r2.w, r1, c14.x, c14.y
mov r4.w, r6.x
rsq r6.x, r2.w
add r6.y, -r6.x, c10.w
texld r2.w, r2, s2
cmp r1.z, -v5, c10, c10.w
mul_pp r1.z, r1, r2.w
texld r1.x, r1.x, s3
mul_pp r1.z, r1, r1.x
max r1.x, r1.y, c10.z
mad r2.x, r6.y, r1, r6
mad r5.w, r2.z, r6.y, r6.x
mul r2.w, r5, r2.x
mul_pp r1.y, r1.z, c11.x
mul r1.xyz, r1.y, c2
mul r1.xyz, r2.z, r1
mul r2.xyz, r1, r4.w
rcp r2.w, r2.w
mul r2.xyz, r2, r5
mul r2.xyz, r2, r2.w
add r1.w, r1, c13.z
mul r2.xyz, r1.w, r2
dp3 r2.w, r4, c12.yzww
add r1.w, -r2, c10
mul r2.xyz, r2, c14.z
mul r1.xyz, r1, r1.w
mul r0.xyz, r3.w, r0
mul r0.xyz, r1, r0
mad r1.xyz, r0, c14.w, r2
mul r0.w, r0, c7.x
add r0.y, r0.w, c10
mov r0.x, c9
cmp r0.y, r0, c10.z, c10.w
add r0.x, c10.w, -r0
mov_pp r2, -r0.y
mul oC0.xyz, r1, r0.x
texkill r2.xyzw
mov_pp oC0.w, c10.z
"
}
SubProgram "d3d11 " {
// Stats: 94 math, 5 textures
Keywords { "SPOT" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 3
SetTexture 2 [_LightTexture0] 2D 0
SetTexture 3 [_LightTextureB0] 2D 1
SetTexture 4 [_MetRoughLum] 2D 2
ConstBuffer "$Globals" 208
Vector 80 [_LightColor0]
Vector 96 [_Diffuse]
Vector 112 [_MetRoughLum_ST]
Vector 128 [_MainTex_ST]
Vector 144 [_BumpTex_ST]
Float 160 [_DiffuseHasAlphaclip]
Float 164 [_DiffuseHasRoughness]
Float 192 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
eefiecedkcbblnmlnadhpekkpmhmopfibehidhbgabaaaaaabiapaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaanaaaaeaaaaaaahiadaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadpcbabaaa
agaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaiaaaaaadcaaaaaldcaabaaa
aaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaa
aiaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaadaaaaaaaaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaaaaaaaaaaakaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaadcaaaaamhcaabaaaabaaaaaa
pgipcaaaacaaaaaaaaaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaacaaaaaa
aaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegbcbaia
ebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaa
pgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
adaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaadkaabaaaacaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaaaaaaaaal
hcaabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaaeaaaaaa
egacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaagaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaaegiccaaaaaaaaaaaagaaaaaadhcaaaajhcaabaaaaaaaaaaaegacbaaa
afaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaaldcaabaaaaeaaaaaa
egbabaaaabaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaa
efaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
acaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaaagaabaaaaeaaaaaa
aaaaaaaldcaabaaaaeaaaaaabgafbaiaebaaaaaaaeaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaaaaaaaaaaaaadccaaaamhcaabaaaafaaaaaafgafbaaaaeaaaaaa
aceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaaafaaaaaaaaaaaaal
hcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadcaaaaajhcaabaaaagaaaaaaegacbaaaagaaaaaapgapbaaa
abaaaaaaegacbaaaafaaaaaabaaaaaakicaabaaaabaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaaacaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaa
acaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaacaaaaaaegbcbaaaadaaaaaa
dcaaaaalmcaabaaaaeaaaaaaagbebaaaabaaaaaaagiecaaaaaaaaaaaajaaaaaa
kgiocaaaaaaaaaaaajaaaaaaefaaaaajpcaabaaaahaaaaaaogakbaaaaeaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapmcaabaaaaeaaaaaapgahbaaa
ahaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaeaaceaaaaaaaaaaaaa
aaaaaaaaaaaaialpaaaaialpdiaaaaahhcaabaaaahaaaaaapgapbaaaaeaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaahaaaaaakgakbaaaaeaaaaaaegbcbaaa
aeaaaaaaegacbaaaahaaaaaaapaaaaahicaabaaaacaaaaaaogakbaaaaeaaaaaa
ogakbaaaaeaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaajhcaabaaa
afaaaaaapgapbaaaacaaaaaaegacbaaaafaaaaaaegacbaaaahaaaaaabaaaaaah
icaabaaaacaaaaaaegacbaaaafaaaaaaegacbaaaafaaaaaaeeaaaaaficaabaaa
acaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaacaaaaaa
egacbaaaafaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaa
afaaaaaadeaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaakaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaakaaaaaadkaabaaaaaaaaaaaakaabaaaaeaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaaeaaaaaadcaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadpbjaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaa
acaaaaaadkaabaaaaaaaaaaabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaa
baaaaaahbcaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaabaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadeaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaaaaaaaak
dcaabaaaacaaaaaaegaabaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaa
aaaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaaaaaaaaadbaaaaahecaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaa
agaaaaaaabaaaaahecaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaaaaaaiadp
diaaaaahecaabaaaabaaaaaadkaabaaaadaaaaaackaabaaaabaaaaaabaaaaaah
bcaabaaaacaaaaaaegbcbaaaagaaaaaaegbcbaaaagaaaaaaefaaaaajpcaabaaa
adaaaaaaagaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaaapaaaaah
ecaabaaaabaaaaaakgakbaaaabaaaaaaagaabaaaadaaaaaadiaaaaaihcaabaaa
acaaaaaakgakbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadiaaaaahhcaabaaa
adaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaadaaaaaa
pgapbaaaacaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaa
agaaaaaaegacbaaaadaaaaaadcaaaaajecaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaidpjccdnelaaaaafecaabaaaabaaaaaackaabaaaabaaaaaaaoaaaaak
ecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpckaabaaa
abaaaaaaaaaaaaaiicaabaaaacaaaaaackaabaiaebaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajccaabaaaabaaaaaabkaabaaaabaaaaaadkaabaaaacaaaaaa
ckaabaaaabaaaaaadcaaaaajecaabaaaabaaaaaaakaabaaaabaaaaaadkaabaaa
acaaaaaackaabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaidpjkcdodiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaagaabaaa
abaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaackaabaaaabaaaaaaaoaaaaak
bcaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajicaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaamaaaaaaabeaaaaa
aaaaiadpdiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 98 math, 6 textures
Keywords { "POINT_COOKIE" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_Diffuse]
Vector 4 [_MetRoughLum_ST]
Vector 5 [_MainTex_ST]
Vector 6 [_BumpTex_ST]
Float 7 [_DiffuseHasAlphaclip]
Float 8 [_DiffuseHasRoughness]
Float 9 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_LightTexture0] CUBE 3
SetTexture 4 [_MetRoughLum] 2D 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_2d s4
def c10, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c11, 2.00000000, -1.00000000, -0.50000000, 1.00000000
def c12, 0.20000000, 0.30000001, 0.58999997, 0.11000000
def c13, 10.00000000, 1.00000000, 8.00000000, 5.00000000
def c14, 0.78539819, 1.57079637, 0.03978873, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
mad r0.xy, v0, c6, c6.zwzw
texld r0.yw, r0, s0
mad_pp r1.zw, r0.xywy, c11.x, c11.y
mul_pp r1.xy, r1.zwzw, r1.zwzw
add_pp_sat r1.x, r1, r1.y
mul r0.xyz, r1.w, v4
add_pp r1.x, -r1, c10.w
mad r5.xy, v0, c4, c4.zwzw
texld r7.xy, r5, s4
dp3 r0.w, v2, v2
mov r5.xyz, c3
mad r0.xyz, r1.z, v3, r0
rsq_pp r1.w, r1.x
rsq r0.w, r0.w
mul r1.xyz, r0.w, v2
rcp_pp r0.w, r1.w
mad r1.xyz, r0.w, r1, r0
add r2.xyz, -v1, c0
mad r0.xyz, -v1, c1.w, c1
dp3 r0.w, r2, r2
dp3 r1.w, r0, r0
rsq r0.w, r0.w
mul r3.xyz, r0.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
add r0.xyz, r2, r3
dp3 r0.w, r0, r0
dp3 r2.w, r1, r1
rsq r1.w, r2.w
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
mul r1.xyz, r1.w, r1
mad r0.xy, v0, c5, c5.zwzw
dp3 r1.w, r1, r4
texld r0, r0, s1
add r3.w, -r7.y, c10
add r2.w, r0, -r3
mad r2.w, r2, c8.x, r3
max r3.w, r1, c10.z
mad r1.w, r2, c13.x, c13.y
dp3 r2.w, r2, r4
dp3 r2.x, r1, r2
mul r4.xyz, r0, c3
exp r1.w, r1.w
pow r6, r3.w, r1.w
add r5.xyz, c11.z, r5
mad r6.yzw, -r5.xxyz, c11.x, c11.w
dp3 r1.y, r1, r3
max r2.w, r2, c10.z
add r0.xyz, -r0, c10.w
dp3 r1.x, v5, v5
add r0.w, r0, c10.x
max r2.x, r2, c10.z
add r2.w, -r2, c10
mul_sat r4.xyz, r4, c11.x
mad_sat r0.xyz, -r6.yzww, r0, c10.w
cmp r0.xyz, -r5, r4, r0
pow r5, r2.w, c13.w
mov r2.w, r5.x
mul_sat r4.xyz, r7.x, r0
add r3.w, -r7.x, c10
mad_sat r4.xyz, r3.w, c12.x, r4
add r5.xyz, -r4, c10.w
mad r5.xyz, r5, r2.w, r4
mad r2.w, r1, c14.x, c14.y
rsq r5.w, r2.w
add r2.z, -r5.w, c10.w
mad r2.y, r2.x, r2.z, r5.w
texld r2.w, v5, s3
texld r1.x, r1.x, s2
mul r1.x, r1, r2.w
max r2.w, r1.y, c10.z
mad r2.z, r2, r2.w, r5.w
mul r2.w, r2.y, r2.z
mul r1.xyz, r1.x, c2
mul r1.xyz, r1, c11.x
mul r1.xyz, r2.x, r1
mov r4.w, r6.x
mul r2.xyz, r1, r4.w
rcp r2.w, r2.w
mul r2.xyz, r2, r5
mul r2.xyz, r2, r2.w
add r1.w, r1, c13.z
mul r2.xyz, r1.w, r2
dp3 r2.w, r4, c12.yzww
add r1.w, -r2, c10
mul r2.xyz, r2, c14.z
mul r1.xyz, r1, r1.w
mul r0.xyz, r3.w, r0
mul r0.xyz, r1, r0
mad r1.xyz, r0, c14.w, r2
mul r0.w, r0, c7.x
add r0.y, r0.w, c10
mov r0.x, c9
cmp r0.y, r0, c10.z, c10.w
add r0.x, c10.w, -r0
mov_pp r2, -r0.y
mul oC0.xyz, r1, r0.x
texkill r2.xyzw
mov_pp oC0.w, c10.z
"
}
SubProgram "d3d11 " {
// Stats: 89 math, 5 textures
Keywords { "POINT_COOKIE" }
SetTexture 0 [_BumpTex] 2D 4
SetTexture 1 [_MainTex] 2D 3
SetTexture 2 [_LightTextureB0] 2D 1
SetTexture 3 [_LightTexture0] CUBE 0
SetTexture 4 [_MetRoughLum] 2D 2
ConstBuffer "$Globals" 208
Vector 80 [_LightColor0]
Vector 96 [_Diffuse]
Vector 112 [_MetRoughLum_ST]
Vector 128 [_MainTex_ST]
Vector 144 [_BumpTex_ST]
Float 160 [_DiffuseHasAlphaclip]
Float 164 [_DiffuseHasRoughness]
Float 192 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
eefiecedkpgegdkhbfdmdmkbhoiclbkmfocffiimabaaaaaaiaaoaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceianaaaaeaaaaaaafcadaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaa
agaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaiaaaaaadcaaaaaldcaabaaa
aaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaa
aiaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaadaaaaaaaaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaaaaaaaaaaakaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaadcaaaaamhcaabaaaabaaaaaa
pgipcaaaacaaaaaaaaaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaacaaaaaa
aaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegbcbaia
ebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaa
acaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaa
pgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
adaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaadkaabaaaacaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaaaaaaaaal
hcaabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaiaebaaaaaaaeaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaaaeaaaaaa
egacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaagaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaaegiccaaaaaaaaaaaagaaaaaadhcaaaajhcaabaaaaaaaaaaaegacbaaa
afaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaaldcaabaaaaeaaaaaa
egbabaaaabaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaa
efaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
acaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaaagaabaaaaeaaaaaa
aaaaaaaldcaabaaaaeaaaaaabgafbaiaebaaaaaaaeaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaaaaaaaaaaaaadccaaaamhcaabaaaafaaaaaafgafbaaaaeaaaaaa
aceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaaafaaaaaaaaaaaaal
hcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadcaaaaajhcaabaaaagaaaaaaegacbaaaagaaaaaapgapbaaa
abaaaaaaegacbaaaafaaaaaabaaaaaakicaabaaaabaaaaaaegacbaaaafaaaaaa
aceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaaacaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaa
acaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaacaaaaaaegbcbaaaadaaaaaa
dcaaaaalmcaabaaaaeaaaaaaagbebaaaabaaaaaaagiecaaaaaaaaaaaajaaaaaa
kgiocaaaaaaaaaaaajaaaaaaefaaaaajpcaabaaaahaaaaaaogakbaaaaeaaaaaa
eghobaaaaaaaaaaaaagabaaaaeaaaaaadcaaaaapmcaabaaaaeaaaaaapgahbaaa
ahaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaeaaceaaaaaaaaaaaaa
aaaaaaaaaaaaialpaaaaialpdiaaaaahhcaabaaaahaaaaaapgapbaaaaeaaaaaa
egbcbaaaafaaaaaadcaaaaajhcaabaaaahaaaaaakgakbaaaaeaaaaaaegbcbaaa
aeaaaaaaegacbaaaahaaaaaaapaaaaahicaabaaaacaaaaaaogakbaaaaeaaaaaa
ogakbaaaaeaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaaabeaaaaa
aaaaiadpelaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaajhcaabaaa
afaaaaaapgapbaaaacaaaaaaegacbaaaafaaaaaaegacbaaaahaaaaaabaaaaaah
icaabaaaacaaaaaaegacbaaaafaaaaaaegacbaaaafaaaaaaeeaaaaaficaabaaa
acaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaacaaaaaa
egacbaaaafaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaa
afaaaaaadeaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaakaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaaaaaaaaaa
bkiacaaaaaaaaaaaakaaaaaadkaabaaaaaaaaaaaakaabaaaaeaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaaeaaaaaadcaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadpbjaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaa
acaaaaaadkaabaaaaaaaaaaabjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaa
baaaaaahbcaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaabaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadeaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
baaaaaahecaabaaaabaaaaaaegbcbaaaagaaaaaaegbcbaaaagaaaaaaefaaaaaj
pcaabaaaadaaaaaakgakbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaaeaaaaaaegbcbaaaagaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaaapaaaaahecaabaaaabaaaaaaagaabaaaadaaaaaapgapbaaaaeaaaaaa
diaaaaaihcaabaaaacaaaaaakgakbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaadaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaacaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaa
adaaaaaaegacbaaaagaaaaaaegacbaaaadaaaaaadcaaaaajecaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaidpjccdnelaaaaafecaabaaaabaaaaaackaabaaa
abaaaaaaaoaaaaakecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpckaabaaaabaaaaaaaaaaaaaiicaabaaaacaaaaaackaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaabaaaaaabkaabaaaabaaaaaa
dkaabaaaacaaaaaackaabaaaabaaaaaadcaaaaajecaabaaaabaaaaaaakaabaaa
abaaaaaadkaabaaaacaaaaaackaabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaacaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaackaabaaa
abaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaa
egacbaaaadaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaaaaaaaaajicaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaa
amaaaaaaabeaaaaaaaaaiadpdiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 96 math, 5 textures
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_Diffuse]
Vector 4 [_MetRoughLum_ST]
Vector 5 [_MainTex_ST]
Vector 6 [_BumpTex_ST]
Float 7 [_DiffuseHasAlphaclip]
Float 8 [_DiffuseHasRoughness]
Float 9 [_Opacity]
SetTexture 0 [_BumpTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_MetRoughLum] 2D 3
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c10, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c11, 2.00000000, -1.00000000, -0.50000000, 1.00000000
def c12, 0.20000000, 0.30000001, 0.58999997, 0.11000000
def c13, 10.00000000, 1.00000000, 8.00000000, 5.00000000
def c14, 0.78539819, 1.57079637, 0.03978873, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xy
mad r0.xy, v0, c6, c6.zwzw
texld r0.yw, r0, s0
mad_pp r1.zw, r0.xywy, c11.x, c11.y
mul_pp r1.xy, r1.zwzw, r1.zwzw
add_pp_sat r1.x, r1, r1.y
mul r0.xyz, r1.w, v4
add_pp r1.x, -r1, c10.w
mad r5.xy, v0, c4, c4.zwzw
texld r7.xy, r5, s3
dp3 r0.w, v2, v2
mov r5.xyz, c3
mad r0.xyz, r1.z, v3, r0
rsq_pp r1.w, r1.x
rsq r0.w, r0.w
mul r1.xyz, r0.w, v2
rcp_pp r0.w, r1.w
mad r1.xyz, r0.w, r1, r0
add r2.xyz, -v1, c0
mad_pp r0.xyz, -v1, c1.w, c1
dp3 r0.w, r2, r2
dp3_pp r1.w, r0, r0
rsq r0.w, r0.w
mul r3.xyz, r0.w, r2
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, r0
add r0.xyz, r2, r3
dp3 r0.w, r0, r0
dp3 r2.w, r1, r1
rsq r1.w, r2.w
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
mul r1.xyz, r1.w, r1
mad r0.xy, v0, c5, c5.zwzw
texld r0, r0, s1
add r3.w, -r7.y, c10
add r2.w, r0, -r3
add r0.w, r0, c10.x
dp3 r1.w, r1, r4
mad r2.w, r2, c8.x, r3
max r3.w, r1, c10.z
mad r1.w, r2, c13.x, c13.y
dp3 r2.w, r2, r4
dp3 r2.x, r1, r2
mul r4.xyz, r0, c3
dp3 r1.x, r1, r3
exp r1.w, r1.w
max r2.w, r2, c10.z
pow r6, r3.w, r1.w
add r5.xyz, c11.z, r5
mad r6.yzw, -r5.xxyz, c11.x, c11.w
add r0.xyz, -r0, c10.w
max r2.x, r2, c10.z
add r2.w, -r2, c10
mul_sat r4.xyz, r4, c11.x
mad_sat r0.xyz, -r6.yzww, r0, c10.w
cmp r0.xyz, -r5, r4, r0
pow r5, r2.w, c13.w
add r2.w, -r7.x, c10
mul_sat r4.xyz, r7.x, r0
mad_sat r4.xyz, r2.w, c12.x, r4
mov r3.w, r5.x
add r5.xyz, -r4, c10.w
mad r5.xyz, r5, r3.w, r4
mad r3.w, r1, c14.x, c14.y
rsq r5.w, r3.w
mov r4.w, r6.x
add r6.x, -r5.w, c10.w
max r2.z, r1.x, c10
texld r3.w, v5, s2
mul r1.xyz, r3.w, c2
mul r1.xyz, r1, c11.x
mul r1.xyz, r2.x, r1
mad r2.y, r2.x, r6.x, r5.w
mad r2.z, r6.x, r2, r5.w
mul r3.x, r2.y, r2.z
mul r2.xyz, r1, r4.w
rcp r3.x, r3.x
mul r2.xyz, r2, r5
mul r2.xyz, r2, r3.x
add r1.w, r1, c13.z
mul r2.xyz, r1.w, r2
dp3 r3.x, r4, c12.yzww
add r1.w, -r3.x, c10
mul r2.xyz, r2, c14.z
mul r1.xyz, r1, r1.w
mul r0.xyz, r2.w, r0
mul r0.xyz, r1, r0
mad r1.xyz, r0, c14.w, r2
mul r0.w, r0, c7.x
add r0.y, r0.w, c10
mov r0.x, c9
cmp r0.y, r0, c10.z, c10.w
add r0.x, c10.w, -r0
mov_pp r2, -r0.y
mul oC0.xyz, r1, r0.x
texkill r2.xyzw
mov_pp oC0.w, c10.z
"
}
SubProgram "d3d11 " {
// Stats: 88 math, 4 textures
Keywords { "DIRECTIONAL_COOKIE" }
SetTexture 0 [_BumpTex] 2D 3
SetTexture 1 [_MainTex] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
SetTexture 3 [_MetRoughLum] 2D 1
ConstBuffer "$Globals" 208
Vector 80 [_LightColor0]
Vector 96 [_Diffuse]
Vector 112 [_MetRoughLum_ST]
Vector 128 [_MainTex_ST]
Vector 144 [_BumpTex_ST]
Float 160 [_DiffuseHasAlphaclip]
Float 164 [_DiffuseHasRoughness]
Float 192 [_Opacity]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
eefiecedjkaiophoanneilnmmdhhabmmhfdpdejbabaaaaaaceaoaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcomamaaaaeaaaaaaadladaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaiaaaaaadcaaaaal
dcaabaaaaaaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaaiaaaaaaogikcaaa
aaaaaaaaaiaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaialpdcaaaaakbcaabaaaabaaaaaaakiacaaaaaaaaaaaakaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaadcaaaaamhcaabaaa
abaaaaaapgipcaaaacaaaaaaaaaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaa
acaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaa
egbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
adaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaacaaaaaadkaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaadkaabaaa
acaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaa
aaaaaaalhcaabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaaaadcaaaabahcaabaaaaeaaaaaaegacbaiaebaaaaaa
aeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaaaaaaaalhcaabaaaafaaaaaaegacbaiaebaaaaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadcaaaaanhcaabaaa
aeaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaagaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaadbaaaaalhcaabaaaafaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaaegiccaaaaaaaaaaaagaaaaaadhcaaaajhcaabaaaaaaaaaaa
egacbaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaaldcaabaaa
aeaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
ahaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaaeghobaaaadaaaaaa
aagabaaaabaaaaaadicaaaahhcaabaaaafaaaaaaegacbaaaaaaaaaaaagaabaaa
aeaaaaaaaaaaaaaldcaabaaaaeaaaaaabgafbaiaebaaaaaaaeaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaaaaaaaaaaaaadccaaaamhcaabaaaafaaaaaafgafbaaa
aeaaaaaaaceaaaaamnmmemdomnmmemdomnmmemdoaaaaaaaaegacbaaaafaaaaaa
aaaaaaalhcaabaaaagaaaaaaegacbaiaebaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaadcaaaaajhcaabaaaagaaaaaaegacbaaaagaaaaaa
pgapbaaaabaaaaaaegacbaaaafaaaaaabaaaaaakicaabaaaabaaaaaaegacbaaa
afaaaaaaaceaaaaajkjjjjdodnakbhdpkoehobdnaaaaaaaaaaaaaaaiicaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaa
acaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaaacaaaaaa
dkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaacaaaaaaegbcbaaa
adaaaaaadcaaaaalmcaabaaaaeaaaaaaagbebaaaabaaaaaaagiecaaaaaaaaaaa
ajaaaaaakgiocaaaaaaaaaaaajaaaaaaefaaaaajpcaabaaaahaaaaaaogakbaaa
aeaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadcaaaaapmcaabaaaaeaaaaaa
pgahbaaaahaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaaaaaaaaaaaaaaaaialpaaaaialpdiaaaaahhcaabaaaahaaaaaapgapbaaa
aeaaaaaaegbcbaaaafaaaaaadcaaaaajhcaabaaaahaaaaaakgakbaaaaeaaaaaa
egbcbaaaaeaaaaaaegacbaaaahaaaaaaapaaaaahicaabaaaacaaaaaaogakbaaa
aeaaaaaaogakbaaaaeaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaa
abeaaaaaaaaaiadpelaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaaj
hcaabaaaafaaaaaapgapbaaaacaaaaaaegacbaaaafaaaaaaegacbaaaahaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaafaaaaaaegacbaaaafaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaa
acaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaadaaaaaa
egacbaaaafaaaaaadeaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaiaebaaaaaaaeaaaaaadcaaaaakicaabaaa
aaaaaaaabkiacaaaaaaaaaaaakaaaaaadkaabaaaaaaaaaaaakaabaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaaeaaaaaadcaaaaaj
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaacaebabeaaaaaaaaaiadp
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaadkaabaaaaaaaaaaabjaaaaaficaabaaaacaaaaaadkaabaaa
acaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaabaaaaaa
baaaaaahccaabaaaabaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadeaaaaak
dcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaaaaaaaaaaaaaaaahecaabaaaabaaaaaadkaabaaaadaaaaaadkaabaaa
adaaaaaadiaaaaaihcaabaaaacaaaaaakgakbaaaabaaaaaaegiccaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaacaaaaaaegacbaaaadaaaaaadiaaaaah
hcaabaaaadaaaaaaegacbaaaagaaaaaaegacbaaaadaaaaaadcaaaaajecaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaanlapejdpabeaaaaanlapmjdpaaaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaidpjccdnelaaaaafecaabaaaabaaaaaa
ckaabaaaabaaaaaaaoaaaaakecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpckaabaaaabaaaaaaaaaaaaaiicaabaaaacaaaaaackaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaabaaaaaabkaabaaa
abaaaaaadkaabaaaacaaaaaackaabaaaabaaaaaadcaaaaajecaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaaaacaaaaaackaabaaaabaaaaaadiaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaidpjkcdodiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaa
ckaabaaaabaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
abaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajicaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaamaaaaaaabeaaaaaaaaaiadpdiaaaaahhccabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaa
doaaaaab"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}
}
 }


 // Stats for Vertex shader:
 //       d3d11 : 29 math
 //        d3d9 : 25 math
 // Stats for Fragment shader:
 //       d3d11 : 26 avg math (21..31), 1 texture
 //        d3d9 : 33 avg math (28..38), 3 texture
 Pass {
  Name "SHADOWCOLLECTOR"
  Tags { "LIGHTMODE"="SHADOWCOLLECTOR" "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLSL
#ifdef VERTEX
uniform mat4 unity_World2Shadow[4];


uniform mat4 _Object2World;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * gl_Vertex).z);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform vec4 _ProjectionParams;
uniform vec4 _LightSplitsNear;
uniform vec4 _LightSplitsFar;
uniform vec4 _LightShadowData;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform float _DiffuseHasAlphaclip;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 res_1;
  float x_2;
  x_2 = (mix (1.0, texture2D (_MainTex, ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw)).w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_2 < 0.0)) {
    discard;
  };
  vec4 tmpvar_3;
  tmpvar_3 = (vec4(greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear)) * vec4(lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar)));
  float tmpvar_4;
  tmpvar_4 = clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = ((((xlv_TEXCOORD0 * tmpvar_3.x) + (xlv_TEXCOORD1 * tmpvar_3.y)) + (xlv_TEXCOORD2 * tmpvar_3.z)) + (xlv_TEXCOORD3 * tmpvar_3.w));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_ShadowMapTexture, tmpvar_5.xy);
  float tmpvar_7;
  if ((tmpvar_6.x < tmpvar_5.z)) {
    tmpvar_7 = _LightShadowData.x;
  } else {
    tmpvar_7 = 1.0;
  };
  res_1.x = clamp ((tmpvar_7 + tmpvar_4), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_8;
  vec2 tmpvar_9;
  tmpvar_9 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_8.y = tmpvar_9.y;
  enc_8.x = (tmpvar_9.x - (tmpvar_9.y * 0.00392157));
  res_1.zw = enc_8;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 25 math
Keywords { "SHADOWS_NONATIVE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c2
dp4 r1.w, v0, c27
dp4 r0.z, v0, c26
dp4 r0.x, v0, c24
dp4 r0.y, v0, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
mov o6.xy, v1
dp4 o0.w, v0, c7
dp4 o0.z, v0, c6
dp4 o0.y, v0, c5
dp4 o0.x, v0, c4
"
}
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp vec4 _LightShadowData;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp vec4 zFar_3;
  highp vec4 zNear_4;
  highp vec4 node_335_5;
  lowp vec4 tmpvar_6;
  highp vec2 P_7;
  P_7 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_6 = texture2D (_MainTex, P_7);
  node_335_5 = tmpvar_6;
  highp float x_8;
  x_8 = (mix (1.0, node_335_5.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_8 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_9;
  tmpvar_9 = greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear);
  lowp vec4 tmpvar_10;
  tmpvar_10 = vec4(tmpvar_9);
  zNear_4 = tmpvar_10;
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  zFar_3 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (zNear_4 * zFar_3);
  highp float tmpvar_14;
  tmpvar_14 = clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = ((((xlv_TEXCOORD0 * tmpvar_13.x) + (xlv_TEXCOORD1 * tmpvar_13.y)) + (xlv_TEXCOORD2 * tmpvar_13.z)) + (xlv_TEXCOORD3 * tmpvar_13.w));
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_15.z)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  res_2.x = clamp ((tmpvar_17 + tmpvar_14), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_18;
  highp vec2 tmpvar_19;
  tmpvar_19 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_18.y = tmpvar_19.y;
  enc_18.x = (tmpvar_19.x - (tmpvar_19.y * 0.00392157));
  res_2.zw = enc_18;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp vec4 _LightShadowData;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp vec4 zFar_3;
  highp vec4 zNear_4;
  highp vec4 node_335_5;
  lowp vec4 tmpvar_6;
  highp vec2 P_7;
  P_7 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_6 = texture2D (_MainTex, P_7);
  node_335_5 = tmpvar_6;
  highp float x_8;
  x_8 = (mix (1.0, node_335_5.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_8 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_9;
  tmpvar_9 = greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear);
  lowp vec4 tmpvar_10;
  tmpvar_10 = vec4(tmpvar_9);
  zNear_4 = tmpvar_10;
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  zFar_3 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (zNear_4 * zFar_3);
  highp float tmpvar_14;
  tmpvar_14 = clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = ((((xlv_TEXCOORD0 * tmpvar_13.x) + (xlv_TEXCOORD1 * tmpvar_13.y)) + (xlv_TEXCOORD2 * tmpvar_13.z)) + (xlv_TEXCOORD3 * tmpvar_13.w));
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_15.z)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  res_2.x = clamp ((tmpvar_17 + tmpvar_14), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_18;
  highp vec2 tmpvar_19;
  tmpvar_19 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_18.y = tmpvar_19.y;
  enc_18.x = (tmpvar_19.x - (tmpvar_19.y * 0.00392157));
  res_2.zw = enc_18;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "SHADOWS_NATIVE" }
"!!GLSL
#ifdef VERTEX
uniform mat4 unity_World2Shadow[4];


uniform mat4 _Object2World;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * gl_Vertex).z);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform vec4 _ProjectionParams;
uniform vec4 _LightSplitsNear;
uniform vec4 _LightSplitsFar;
uniform vec4 _LightShadowData;
uniform sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform float _DiffuseHasAlphaclip;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 res_1;
  float x_2;
  x_2 = (mix (1.0, texture2D (_MainTex, ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw)).w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_2 < 0.0)) {
    discard;
  };
  vec4 tmpvar_3;
  tmpvar_3 = (vec4(greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear)) * vec4(lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar)));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = ((((xlv_TEXCOORD0 * tmpvar_3.x) + (xlv_TEXCOORD1 * tmpvar_3.y)) + (xlv_TEXCOORD2 * tmpvar_3.z)) + (xlv_TEXCOORD3 * tmpvar_3.w));
  res_1.x = clamp (((_LightShadowData.x + (shadow2D (_ShadowMapTexture, tmpvar_4.xyz).x * (1.0 - _LightShadowData.x))) + clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_5;
  vec2 tmpvar_6;
  tmpvar_6 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_5.y = tmpvar_6.y;
  enc_5.x = (tmpvar_6.x - (tmpvar_6.y * 0.00392157));
  res_1.zw = enc_5;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 25 math
Keywords { "SHADOWS_NATIVE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c2
dp4 r1.w, v0, c27
dp4 r0.z, v0, c26
dp4 r0.x, v0, c24
dp4 r0.y, v0, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
mov o6.xy, v1
dp4 o0.w, v0, c7
dp4 o0.z, v0, c6
dp4 o0.y, v0, c5
dp4 o0.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 29 math
Keywords { "SHADOWS_NATIVE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
BindCB  "UnityShadows" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlbhpagelbjfjngfgkglellllpkkhdjmaabaaaaaageagaaaaadaaaaaa
cmaaaaaaiaaaaaaafaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
lmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
lmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaadamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcamafaaaaeaaaabaaedabaaaa
fjaaaaaeegiocaaaaaaaaaaabiaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagfaaaaaddccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaajaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaaiaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaaakaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
abaaaaaaegiccaaaaaaaaaaaalaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
aaaaaaaaapaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaabaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaakgakbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaaaaaaaaabdaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaabfaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaabeaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaabgaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaaeaaaaaaegiccaaaaaaaaaaabhaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaabaaaaaaafaaaaaadcaaaaak
bcaabaaaaaaaaaaackiacaaaabaaaaaaaeaaaaaaakbabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaabaaaaaaagaaaaaackbabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaabaaaaaa
ahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaadgaaaaagiccabaaaafaaaaaa
akaabaiaebaaaaaaaaaaaaaadgaaaaafdccabaaaagaaaaaaegbabaaaabaaaaaa
doaaaaab"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp vec4 _LightShadowData;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  mediump float shadow_3;
  highp vec4 zFar_4;
  highp vec4 zNear_5;
  highp vec4 node_335_6;
  lowp vec4 tmpvar_7;
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_7 = texture2D (_MainTex, P_8);
  node_335_6 = tmpvar_7;
  highp float x_9;
  x_9 = (mix (1.0, node_335_6.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_10;
  tmpvar_10 = greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear);
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(tmpvar_10);
  zNear_5 = tmpvar_11;
  bvec4 tmpvar_12;
  tmpvar_12 = lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar);
  lowp vec4 tmpvar_13;
  tmpvar_13 = vec4(tmpvar_12);
  zFar_4 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (zNear_5 * zFar_4);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = ((((xlv_TEXCOORD0 * tmpvar_14.x) + (xlv_TEXCOORD1 * tmpvar_14.y)) + (xlv_TEXCOORD2 * tmpvar_14.z)) + (xlv_TEXCOORD3 * tmpvar_14.w));
  lowp float tmpvar_16;
  tmpvar_16 = shadow2DEXT (_ShadowMapTexture, tmpvar_15.xyz);
  shadow_3 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (_LightShadowData.x + (shadow_3 * (1.0 - _LightShadowData.x)));
  shadow_3 = tmpvar_17;
  res_2.x = clamp ((shadow_3 + clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_18;
  highp vec2 tmpvar_19;
  tmpvar_19 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_18.y = tmpvar_19.y;
  enc_18.x = (tmpvar_19.x - (tmpvar_19.y * 0.00392157));
  res_2.zw = enc_18;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
out highp vec3 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
out highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp vec4 _LightShadowData;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
in highp vec3 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
in highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  mediump float shadow_3;
  highp vec4 zFar_4;
  highp vec4 zNear_5;
  highp vec4 node_335_6;
  lowp vec4 tmpvar_7;
  highp vec2 P_8;
  P_8 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_7 = texture (_MainTex, P_8);
  node_335_6 = tmpvar_7;
  highp float x_9;
  x_9 = (mix (1.0, node_335_6.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_9 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_10;
  tmpvar_10 = greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear);
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(tmpvar_10);
  zNear_5 = tmpvar_11;
  bvec4 tmpvar_12;
  tmpvar_12 = lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar);
  lowp vec4 tmpvar_13;
  tmpvar_13 = vec4(tmpvar_12);
  zFar_4 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (zNear_5 * zFar_4);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = ((((xlv_TEXCOORD0 * tmpvar_14.x) + (xlv_TEXCOORD1 * tmpvar_14.y)) + (xlv_TEXCOORD2 * tmpvar_14.z)) + (xlv_TEXCOORD3 * tmpvar_14.w));
  mediump float tmpvar_16;
  tmpvar_16 = texture (_ShadowMapTexture, tmpvar_15.xyz);
  highp float tmpvar_17;
  tmpvar_17 = (_LightShadowData.x + (tmpvar_16 * (1.0 - _LightShadowData.x)));
  shadow_3 = tmpvar_17;
  res_2.x = clamp ((shadow_3 + clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_18;
  highp vec2 tmpvar_19;
  tmpvar_19 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_18.y = tmpvar_19.y;
  enc_18.x = (tmpvar_19.x - (tmpvar_19.y * 0.00392157));
  res_2.zw = enc_18;
  tmpvar_1 = res_2;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLSL
#ifdef VERTEX
uniform mat4 unity_World2Shadow[4];


uniform mat4 _Object2World;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * gl_Vertex).z);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform vec4 _ProjectionParams;
uniform vec4 unity_ShadowSplitSpheres[4];
uniform vec4 unity_ShadowSplitSqRadii;
uniform vec4 _LightShadowData;
uniform vec4 unity_ShadowFadeCenterAndType;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform float _DiffuseHasAlphaclip;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 res_1;
  vec4 cascadeWeights_2;
  float x_3;
  x_3 = (mix (1.0, texture2D (_MainTex, ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw)).w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_3 < 0.0)) {
    discard;
  };
  vec3 tmpvar_4;
  tmpvar_4 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  vec3 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_4, tmpvar_4);
  tmpvar_8.y = dot (tmpvar_5, tmpvar_5);
  tmpvar_8.z = dot (tmpvar_6, tmpvar_6);
  tmpvar_8.w = dot (tmpvar_7, tmpvar_7);
  vec4 tmpvar_9;
  tmpvar_9 = vec4(lessThan (tmpvar_8, unity_ShadowSplitSqRadii));
  cascadeWeights_2.x = tmpvar_9.x;
  cascadeWeights_2.yzw = clamp ((tmpvar_9.yzw - tmpvar_9.xyz), 0.0, 1.0);
  vec3 p_10;
  p_10 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  float tmpvar_11;
  tmpvar_11 = clamp (((sqrt(dot (p_10, p_10)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = ((((xlv_TEXCOORD0 * tmpvar_9.x) + (xlv_TEXCOORD1 * cascadeWeights_2.y)) + (xlv_TEXCOORD2 * cascadeWeights_2.z)) + (xlv_TEXCOORD3 * cascadeWeights_2.w));
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_12.xy);
  float tmpvar_14;
  if ((tmpvar_13.x < tmpvar_12.z)) {
    tmpvar_14 = _LightShadowData.x;
  } else {
    tmpvar_14 = 1.0;
  };
  res_1.x = clamp ((tmpvar_14 + tmpvar_11), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_15;
  vec2 tmpvar_16;
  tmpvar_16 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_15.y = tmpvar_16.y;
  enc_15.x = (tmpvar_16.x - (tmpvar_16.y * 0.00392157));
  res_1.zw = enc_15;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 25 math
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c2
dp4 r1.w, v0, c27
dp4 r0.z, v0, c26
dp4 r0.x, v0, c24
dp4 r0.y, v0, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
mov o6.xy, v1
dp4 o0.w, v0, c7
dp4 o0.z, v0, c6
dp4 o0.y, v0, c5
dp4 o0.x, v0, c4
"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ProjectionParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp vec4 cascadeWeights_3;
  highp vec4 node_335_4;
  lowp vec4 tmpvar_5;
  highp vec2 P_6;
  P_6 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_5 = texture2D (_MainTex, P_6);
  node_335_4 = tmpvar_5;
  highp float x_7;
  x_7 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_7 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  cascadeWeights_3 = tmpvar_14;
  cascadeWeights_3.yzw = clamp ((cascadeWeights_3.yzw - cascadeWeights_3.xyz), 0.0, 1.0);
  highp vec3 p_15;
  p_15 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = clamp (((sqrt(dot (p_15, p_15)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = ((((xlv_TEXCOORD0 * cascadeWeights_3.x) + (xlv_TEXCOORD1 * cascadeWeights_3.y)) + (xlv_TEXCOORD2 * cascadeWeights_3.z)) + (xlv_TEXCOORD3 * cascadeWeights_3.w));
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_ShadowMapTexture, tmpvar_17.xy);
  highp float tmpvar_19;
  if ((tmpvar_18.x < tmpvar_17.z)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  res_2.x = clamp ((tmpvar_19 + tmpvar_16), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_20.y = tmpvar_21.y;
  enc_20.x = (tmpvar_21.x - (tmpvar_21.y * 0.00392157));
  res_2.zw = enc_20;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ProjectionParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp vec4 cascadeWeights_3;
  highp vec4 node_335_4;
  lowp vec4 tmpvar_5;
  highp vec2 P_6;
  P_6 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_5 = texture2D (_MainTex, P_6);
  node_335_4 = tmpvar_5;
  highp float x_7;
  x_7 = (mix (1.0, node_335_4.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_7 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  cascadeWeights_3 = tmpvar_14;
  cascadeWeights_3.yzw = clamp ((cascadeWeights_3.yzw - cascadeWeights_3.xyz), 0.0, 1.0);
  highp vec3 p_15;
  p_15 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = clamp (((sqrt(dot (p_15, p_15)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = ((((xlv_TEXCOORD0 * cascadeWeights_3.x) + (xlv_TEXCOORD1 * cascadeWeights_3.y)) + (xlv_TEXCOORD2 * cascadeWeights_3.z)) + (xlv_TEXCOORD3 * cascadeWeights_3.w));
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_ShadowMapTexture, tmpvar_17.xy);
  highp float tmpvar_19;
  if ((tmpvar_18.x < tmpvar_17.z)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  res_2.x = clamp ((tmpvar_19 + tmpvar_16), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_20.y = tmpvar_21.y;
  enc_20.x = (tmpvar_21.x - (tmpvar_21.y * 0.00392157));
  res_2.zw = enc_20;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLSL
#ifdef VERTEX
uniform mat4 unity_World2Shadow[4];


uniform mat4 _Object2World;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * gl_Vertex).z);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform vec4 _ProjectionParams;
uniform vec4 unity_ShadowSplitSpheres[4];
uniform vec4 unity_ShadowSplitSqRadii;
uniform vec4 _LightShadowData;
uniform vec4 unity_ShadowFadeCenterAndType;
uniform sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform float _DiffuseHasAlphaclip;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD5;
void main ()
{
  vec4 res_1;
  vec4 cascadeWeights_2;
  float x_3;
  x_3 = (mix (1.0, texture2D (_MainTex, ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw)).w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_3 < 0.0)) {
    discard;
  };
  vec3 tmpvar_4;
  tmpvar_4 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  vec3 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_4, tmpvar_4);
  tmpvar_8.y = dot (tmpvar_5, tmpvar_5);
  tmpvar_8.z = dot (tmpvar_6, tmpvar_6);
  tmpvar_8.w = dot (tmpvar_7, tmpvar_7);
  vec4 tmpvar_9;
  tmpvar_9 = vec4(lessThan (tmpvar_8, unity_ShadowSplitSqRadii));
  cascadeWeights_2.x = tmpvar_9.x;
  cascadeWeights_2.yzw = clamp ((tmpvar_9.yzw - tmpvar_9.xyz), 0.0, 1.0);
  vec3 p_10;
  p_10 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = ((((xlv_TEXCOORD0 * tmpvar_9.x) + (xlv_TEXCOORD1 * cascadeWeights_2.y)) + (xlv_TEXCOORD2 * cascadeWeights_2.z)) + (xlv_TEXCOORD3 * cascadeWeights_2.w));
  res_1.x = clamp (((_LightShadowData.x + (shadow2D (_ShadowMapTexture, tmpvar_11.xyz).x * (1.0 - _LightShadowData.x))) + clamp (((sqrt(dot (p_10, p_10)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_12;
  vec2 tmpvar_13;
  tmpvar_13 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_12.y = tmpvar_13.y;
  enc_12.x = (tmpvar_13.x - (tmpvar_13.y * 0.00392157));
  res_1.zw = enc_12;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 25 math
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c2
dp4 r1.w, v0, c27
dp4 r0.z, v0, c26
dp4 r0.x, v0, c24
dp4 r0.y, v0, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
mov o6.xy, v1
dp4 o0.w, v0, c7
dp4 o0.z, v0, c6
dp4 o0.y, v0, c5
dp4 o0.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 29 math
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
BindCB  "UnityShadows" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlbhpagelbjfjngfgkglellllpkkhdjmaabaaaaaageagaaaaadaaaaaa
cmaaaaaaiaaaaaaafaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
lmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
lmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaadamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcamafaaaaeaaaabaaedabaaaa
fjaaaaaeegiocaaaaaaaaaaabiaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagfaaaaaddccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaajaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaaiaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaaakaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
abaaaaaaegiccaaaaaaaaaaaalaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
aaaaaaaaapaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaabaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaabcaaaaaakgakbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaaaaaaaaabdaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaabfaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaabeaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaaaaaaaaabgaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaaeaaaaaaegiccaaaaaaaaaaabhaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaabaaaaaaafaaaaaadcaaaaak
bcaabaaaaaaaaaaackiacaaaabaaaaaaaeaaaaaaakbabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaabaaaaaaagaaaaaackbabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaabaaaaaa
ahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaadgaaaaagiccabaaaafaaaaaa
akaabaiaebaaaaaaaaaaaaaadgaaaaafdccabaaaagaaaaaaegbabaaaabaaaaaa
doaaaaab"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ProjectionParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  mediump float shadow_3;
  highp vec4 cascadeWeights_4;
  highp vec4 node_335_5;
  lowp vec4 tmpvar_6;
  highp vec2 P_7;
  P_7 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_6 = texture2D (_MainTex, P_7);
  node_335_5 = tmpvar_6;
  highp float x_8;
  x_8 = (mix (1.0, node_335_5.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_8 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  cascadeWeights_4 = tmpvar_15;
  cascadeWeights_4.yzw = clamp ((cascadeWeights_4.yzw - cascadeWeights_4.xyz), 0.0, 1.0);
  highp vec3 p_16;
  p_16 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = ((((xlv_TEXCOORD0 * cascadeWeights_4.x) + (xlv_TEXCOORD1 * cascadeWeights_4.y)) + (xlv_TEXCOORD2 * cascadeWeights_4.z)) + (xlv_TEXCOORD3 * cascadeWeights_4.w));
  lowp float tmpvar_18;
  tmpvar_18 = shadow2DEXT (_ShadowMapTexture, tmpvar_17.xyz);
  shadow_3 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (_LightShadowData.x + (shadow_3 * (1.0 - _LightShadowData.x)));
  shadow_3 = tmpvar_19;
  res_2.x = clamp ((shadow_3 + clamp (((sqrt(dot (p_16, p_16)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_20.y = tmpvar_21.y;
  enc_20.x = (tmpvar_21.x - (tmpvar_21.y * 0.00392157));
  res_2.zw = enc_20;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
out highp vec3 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
out highp vec2 xlv_TEXCOORD5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  tmpvar_1.xyz = tmpvar_2.xyz;
  tmpvar_1.w = -((glstate_matrix_modelview0 * _glesVertex).z);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_2).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_2).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_2).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_2).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec4 _ProjectionParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
in highp vec3 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
in highp vec2 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  mediump float shadow_3;
  highp vec4 cascadeWeights_4;
  highp vec4 node_335_5;
  lowp vec4 tmpvar_6;
  highp vec2 P_7;
  P_7 = ((xlv_TEXCOORD5 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_6 = texture (_MainTex, P_7);
  node_335_5 = tmpvar_6;
  highp float x_8;
  x_8 = (mix (1.0, node_335_5.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_8 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  cascadeWeights_4 = tmpvar_15;
  cascadeWeights_4.yzw = clamp ((cascadeWeights_4.yzw - cascadeWeights_4.xyz), 0.0, 1.0);
  highp vec3 p_16;
  p_16 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = ((((xlv_TEXCOORD0 * cascadeWeights_4.x) + (xlv_TEXCOORD1 * cascadeWeights_4.y)) + (xlv_TEXCOORD2 * cascadeWeights_4.z)) + (xlv_TEXCOORD3 * cascadeWeights_4.w));
  mediump float tmpvar_18;
  tmpvar_18 = texture (_ShadowMapTexture, tmpvar_17.xyz);
  highp float tmpvar_19;
  tmpvar_19 = (_LightShadowData.x + (tmpvar_18 * (1.0 - _LightShadowData.x)));
  shadow_3 = tmpvar_19;
  res_2.x = clamp ((shadow_3 + clamp (((sqrt(dot (p_16, p_16)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_2.y = 1.0;
  highp vec2 enc_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_20.y = tmpvar_21.y;
  enc_20.x = (tmpvar_21.x - (tmpvar_21.y * 0.00392157));
  res_2.zw = enc_20;
  tmpvar_1 = res_2;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 28 math, 3 textures
Keywords { "SHADOWS_NONATIVE" }
Vector 0 [_ProjectionParams]
Vector 1 [_LightSplitsNear]
Vector 2 [_LightSplitsFar]
Vector 3 [_LightShadowData]
Vector 4 [_MainTex_ST]
Float 5 [_DiffuseHasAlphaclip]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] 2D 1
"ps_3_0
dcl_2d s0
dcl_2d s1
def c6, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c7, 1.00000000, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyzw
dcl_texcoord5 v5.xy
add r1, v4.w, -c2
add r0, v4.w, -c1
cmp r1, r1, c6.z, c6.w
cmp r0, r0, c6.w, c6.z
mul r0, r0, r1
mul r1.xyz, r0.y, v1
mad r1.xyz, r0.x, v0, r1
mad r0.xyz, r0.z, v2, r1
mad r0.xyz, v3, r0.w, r0
texld r0.x, r0, s1
add r0.z, r0.x, -r0
mov r0.w, c3.x
cmp r0.z, r0, c6.w, r0.w
mad r0.xy, v5, c4, c4.zwzw
texld r0.w, r0, s0
mad_sat r0.y, v4.w, c3.z, c3.w
add r0.x, r0.w, c6
add_sat oC0.x, r0.z, r0.y
mul r0.x, r0, c5
mul r0.y, -v4.w, c0.w
add r0.y, r0, c6.w
mul r1.xy, r0.y, c7
add r0.x, r0, c6.y
cmp r0.x, r0, c6.z, c6.w
mov_pp r0, -r0.x
frc r1.xy, r1
texkill r0.xyzw
mov r0.y, r1
mad r0.x, -r1.y, c7.z, r1
mov oC0.zw, r0.xyxy
mov oC0.y, c6.w
"
}
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "opengl " {
Keywords { "SHADOWS_NATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 28 math, 3 textures
Keywords { "SHADOWS_NATIVE" }
Vector 0 [_ProjectionParams]
Vector 1 [_LightSplitsNear]
Vector 2 [_LightSplitsFar]
Vector 3 [_LightShadowData]
Vector 4 [_MainTex_ST]
Float 5 [_DiffuseHasAlphaclip]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] 2D 1
"ps_3_0
dcl_2d s0
dcl_2d s1
def c6, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c7, 1.00000000, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyzw
dcl_texcoord5 v5.xy
add r1, v4.w, -c2
add r0, v4.w, -c1
cmp r1, r1, c6.z, c6.w
cmp r0, r0, c6.w, c6.z
mul r0, r0, r1
mul r1.xyz, r0.y, v1
mad r1.xyz, r0.x, v0, r1
mad r0.xyz, r0.z, v2, r1
mad r0.xyz, v3, r0.w, r0
texld r0.x, r0, s1
mov r0.w, c3.x
add r0.y, c6.w, -r0.w
mad r1.xy, v5, c4, c4.zwzw
mad r0.y, r0.x, r0, c3.x
texld r0.w, r1, s0
mad_sat r0.z, v4.w, c3, c3.w
add r0.x, r0.w, c6
add_sat oC0.x, r0.y, r0.z
mul r0.x, r0, c5
mul r0.y, -v4.w, c0.w
add r0.y, r0, c6.w
mul r1.xy, r0.y, c7
add r0.x, r0, c6.y
cmp r0.x, r0, c6.z, c6.w
mov_pp r0, -r0.x
frc r1.xy, r1
texkill r0.xyzw
mov r0.y, r1
mad r0.x, -r1.y, c7.z, r1
mov oC0.zw, r0.xyxy
mov oC0.y, c6.w
"
}
SubProgram "d3d11 " {
// Stats: 21 math, 1 textures
Keywords { "SHADOWS_NATIVE" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 80
Vector 48 [_MainTex_ST]
Float 64 [_DiffuseHasAlphaclip]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 96 [_LightSplitsNear]
Vector 112 [_LightSplitsFar]
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedenjkbekhhfggljpeffdaeicbgaonkgpoabaaaaaahaafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiaeaaaaeaaaaaaaaoabaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaiaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadicbabaaa
afaaaaaagcbaaaaddcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaagaaaaaaegiacaaaaaaaaaaa
adaaaaaaogikcaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaaaaaaaaa
bnaaaaaipcaabaaaaaaaaaaapgbpbaaaafaaaaaaegiocaaaacaaaaaaagaaaaaa
abaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdbaaaaaipcaabaaaabaaaaaapgbpbaaaafaaaaaaegiocaaa
acaaaaaaahaaaaaaabaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdiaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaa
egbcbaaaacaaaaaadcaaaaajhcaabaaaabaaaaaaegbcbaaaabaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegbcbaaaadaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegbcbaaa
aeaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaehaaaaalbcaabaaaaaaaaaaa
egaabaaaaaaaaaaaaghabaaaabaaaaaaaagabaaaaaaaaaaackaabaaaaaaaaaaa
aaaaaaajccaabaaaaaaaaaaaakiacaiaebaaaaaaacaaaaaabiaaaaaaabeaaaaa
aaaaiadpdcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaacaaaaaabiaaaaaadccaaaalccaabaaaaaaaaaaadkbabaaaafaaaaaa
ckiacaaaacaaaaaabiaaaaaadkiacaaaacaaaaaabiaaaaaaaacaaaahbccabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaa
dkbabaiaebaaaaaaafaaaaaadkiacaaaabaaaaaaafaaaaaaabeaaaaaaaaaiadp
diaaaaakdcaabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaahped
aaaaaaaaaaaaaaaabkaaaaafdcaabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
eccabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabeaaaaaibiaiadlakaabaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaabkaabaaaaaaaaaaadgaaaaafcccabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 38 math, 3 textures
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
Vector 0 [_ProjectionParams]
Vector 1 [unity_ShadowSplitSpheres0]
Vector 2 [unity_ShadowSplitSpheres1]
Vector 3 [unity_ShadowSplitSpheres2]
Vector 4 [unity_ShadowSplitSpheres3]
Vector 5 [unity_ShadowSplitSqRadii]
Vector 6 [_LightShadowData]
Vector 7 [unity_ShadowFadeCenterAndType]
Vector 8 [_MainTex_ST]
Float 9 [_DiffuseHasAlphaclip]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] 2D 1
"ps_3_0
dcl_2d s0
dcl_2d s1
def c10, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c11, 1.00000000, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
add r0.xyz, v4, -c1
add r2.xyz, v4, -c4
dp3 r0.x, r0, r0
add r1.xyz, v4, -c2
dp3 r0.y, r1, r1
add r1.xyz, v4, -c3
dp3 r0.w, r2, r2
dp3 r0.z, r1, r1
add r0, r0, -c5
cmp r2, r0, c10.z, c10.w
add_sat r0.xyz, r2.yzww, -r2
mul r1.xyz, r0.x, v1
mad r1.xyz, r2.x, v0, r1
mad r1.xyz, r0.y, v2, r1
mad r0.xyz, v3, r0.z, r1
texld r0.x, r0, s1
add r1.xyz, -v4, c7
dp3 r0.w, r1, r1
rsq r0.w, r0.w
add r0.x, r0, -r0.z
mov r0.y, c6.x
cmp r0.z, r0.x, c10.w, r0.y
mad r0.xy, v5, c8, c8.zwzw
rcp r1.x, r0.w
texld r0.w, r0, s0
mad_sat r0.y, r1.x, c6.z, c6.w
add r0.x, r0.w, c10
add_sat oC0.x, r0.z, r0.y
mul r0.x, r0, c9
mul r0.y, -v4.w, c0.w
add r0.y, r0, c10.w
mul r1.xy, r0.y, c11
add r0.x, r0, c10.y
cmp r0.x, r0, c10.z, c10.w
mov_pp r0, -r0.x
frc r1.xy, r1
texkill r0.xyzw
mov r0.y, r1
mad r0.x, -r1.y, c11.z, r1
mov oC0.zw, r0.xyxy
mov oC0.y, c10.w
"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 38 math, 3 textures
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
Vector 0 [_ProjectionParams]
Vector 1 [unity_ShadowSplitSpheres0]
Vector 2 [unity_ShadowSplitSpheres1]
Vector 3 [unity_ShadowSplitSpheres2]
Vector 4 [unity_ShadowSplitSpheres3]
Vector 5 [unity_ShadowSplitSqRadii]
Vector 6 [_LightShadowData]
Vector 7 [unity_ShadowFadeCenterAndType]
Vector 8 [_MainTex_ST]
Float 9 [_DiffuseHasAlphaclip]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] 2D 1
"ps_3_0
dcl_2d s0
dcl_2d s1
def c10, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c11, 1.00000000, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
add r0.xyz, v4, -c1
add r2.xyz, v4, -c4
dp3 r0.x, r0, r0
add r1.xyz, v4, -c2
dp3 r0.y, r1, r1
add r1.xyz, v4, -c3
dp3 r0.w, r2, r2
dp3 r0.z, r1, r1
add r0, r0, -c5
cmp r2, r0, c10.z, c10.w
add_sat r0.xyz, r2.yzww, -r2
mul r1.xyz, r0.x, v1
mad r1.xyz, r2.x, v0, r1
mad r1.xyz, r0.y, v2, r1
mad r0.xyz, v3, r0.z, r1
texld r0.x, r0, s1
add r1.xyz, -v4, c7
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mov r0.y, c6.x
add r0.y, c10.w, -r0
mad r0.z, r0.x, r0.y, c6.x
mad r0.xy, v5, c8, c8.zwzw
rcp r1.x, r0.w
texld r0.w, r0, s0
mad_sat r0.y, r1.x, c6.z, c6.w
add r0.x, r0.w, c10
add_sat oC0.x, r0.z, r0.y
mul r0.x, r0, c9
mul r0.y, -v4.w, c0.w
add r0.y, r0, c10.w
mul r1.xy, r0.y, c11
add r0.x, r0, c10.y
cmp r0.x, r0, c10.z, c10.w
mov_pp r0, -r0.x
frc r1.xy, r1
texkill r0.xyzw
mov r0.y, r1
mad r0.x, -r1.y, c11.z, r1
mov oC0.zw, r0.xyxy
mov oC0.y, c10.w
"
}
SubProgram "d3d11 " {
// Stats: 31 math, 1 textures
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 80
Vector 48 [_MainTex_ST]
Float 64 [_DiffuseHasAlphaclip]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 0 [unity_ShadowSplitSpheres0]
Vector 16 [unity_ShadowSplitSpheres1]
Vector 32 [unity_ShadowSplitSpheres2]
Vector 48 [unity_ShadowSplitSpheres3]
Vector 64 [unity_ShadowSplitSqRadii]
Vector 384 [_LightShadowData]
Vector 400 [unity_ShadowFadeCenterAndType]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedgjemkmecpjiijdmplehkmjefdefhpejpabaaaaaaoaagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckiafaaaaeaaaaaaagkabaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaabkaaaaaafkaiaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadpcbabaaa
afaaaaaagcbaaaaddcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaagaaaaaaegiacaaaaaaaaaaa
adaaaaaaogikcaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdbaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaaaaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaaaafaaaaaaegiccaiaebaaaaaaacaaaaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaaaafaaaaaaegiccaiaebaaaaaaacaaaaaa
abaaaaaabaaaaaahccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaaaafaaaaaaegiccaiaebaaaaaaacaaaaaa
acaaaaaabaaaaaahecaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaaaafaaaaaaegiccaiaebaaaaaaacaaaaaa
adaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
dbaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaacaaaaaaaeaaaaaa
dhaaaaaphcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaaaceaaaaaaaaaaaiaaaaaaaiaaaaaaaiaaaaaaaaaabaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaaaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaa
deaaaaakocaabaaaaaaaaaaafgaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaajhcaabaaaabaaaaaaegbcbaaaabaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegbcbaaaadaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegbcbaaaaeaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaaehaaaaalbcaabaaaaaaaaaaaegaabaaa
aaaaaaaaaghabaaaabaaaaaaaagabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaaj
ccaabaaaaaaaaaaaakiacaiaebaaaaaaacaaaaaabiaaaaaaabeaaaaaaaaaiadp
dcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
acaaaaaabiaaaaaaaaaaaaajocaabaaaaaaaaaaaagbjbaaaafaaaaaaagijcaia
ebaaaaaaacaaaaaabjaaaaaabaaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaa
jgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadccaaaal
ccaabaaaaaaaaaaabkaabaaaaaaaaaaackiacaaaacaaaaaabiaaaaaadkiacaaa
acaaaaaabiaaaaaaaacaaaahbccabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaalbcaabaaaaaaaaaaadkbabaiaebaaaaaaafaaaaaadkiacaaa
abaaaaaaafaaaaaaabeaaaaaaaaaiadpdiaaaaakdcaabaaaaaaaaaaaagaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaahpedaaaaaaaaaaaaaaaabkaaaaafdcaabaaa
aaaaaaaaegaabaaaaaaaaaaadcaaaaakeccabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaaabeaaaaaibiaiadlakaabaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
bkaabaaaaaaaaaaadgaaaaafcccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES3"
}
}
 }


 // Stats for Vertex shader:
 //       d3d11 : 8 avg math (8..9)
 //        d3d9 : 10 avg math (9..11)
 // Stats for Fragment shader:
 //       d3d11 : 7 avg math (4..11), 1 texture
 //        d3d9 : 11 avg math (8..14), 2 texture
 Pass {
  Name "SHADOWCASTER"
  Tags { "LIGHTMODE"="SHADOWCASTER" "SHADOWSUPPORT"="true" "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
  Cull Off
  Fog { Mode Off }
  Offset 1, 1
Program "vp" {
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" }
"!!GLSL
#ifdef VERTEX
uniform vec4 unity_LightShadowBias;

varying vec2 xlv_TEXCOORD1;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  tmpvar_1.xyw = tmpvar_2.xyw;
  tmpvar_1.z = (tmpvar_2.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_2.w * -1.0)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD1 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform float _DiffuseHasAlphaclip;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  float x_1;
  x_1 = (mix (1.0, texture2D (_MainTex, ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw)).w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_1 < 0.0)) {
    discard;
  };
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 11 math
Keywords { "SHADOWS_DEPTH" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [unity_LightShadowBias]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c5, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.x, v0, c2
add r0.x, r0, c4
max r0.y, r0.x, c5.x
add r0.y, r0, -r0.x
mad r0.z, r0.y, c4.y, r0.x
dp4 r0.w, v0, c3
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mov o0, r0
mov o1, r0
mov o2.xy, v1
"
}
SubProgram "d3d11 " {
// Stats: 8 math
Keywords { "SHADOWS_DEPTH" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityShadows" 416
Vector 80 [unity_LightShadowBias]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "UnityShadows" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedignanfocgdllnnmfimaoenjaecabdjmnabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckmabaaaa
eaaaabaaglaaaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaaaaaaaaai
ecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadgaaaaaf
lccabaaaaaaaaaaaegambaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakeccabaaaaaaaaaaabkiacaaaaaaaaaaa
afaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaabaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xyw = tmpvar_2.xyw;
  tmpvar_1.z = (tmpvar_2.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_2.w * -1.0)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD1 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 node_335_1;
  lowp vec4 tmpvar_2;
  highp vec2 P_3;
  P_3 = ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = texture2D (_MainTex, P_3);
  node_335_1 = tmpvar_2;
  highp float x_4;
  x_4 = (mix (1.0, node_335_1.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_4 < 0.0)) {
    discard;
  };
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xyw = tmpvar_2.xyw;
  tmpvar_1.z = (tmpvar_2.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_2.w * -1.0)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD1 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 node_335_1;
  lowp vec4 tmpvar_2;
  highp vec2 P_3;
  P_3 = ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = texture2D (_MainTex, P_3);
  node_335_1 = tmpvar_2;
  highp float x_4;
  x_4 = (mix (1.0, node_335_1.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_4 < 0.0)) {
    discard;
  };
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xyw = tmpvar_2.xyw;
  tmpvar_1.z = (tmpvar_2.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_2.w * -1.0)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD1 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
in highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 node_335_1;
  lowp vec4 tmpvar_2;
  highp vec2 P_3;
  P_3 = ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = texture (_MainTex, P_3);
  node_335_1 = tmpvar_2;
  highp float x_4;
  x_4 = (mix (1.0, node_335_1.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_4 < 0.0)) {
    discard;
  };
  _glesFragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}



#endif"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" }
"!!GLSL
#ifdef VERTEX
uniform vec4 _LightPositionRange;

uniform mat4 _Object2World;
varying vec3 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
  xlv_TEXCOORD1 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform vec4 _LightPositionRange;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_ST;
uniform float _DiffuseHasAlphaclip;
varying vec3 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  float x_1;
  x_1 = (mix (1.0, texture2D (_MainTex, ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw)).w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_1 < 0.0)) {
    discard;
  };
  vec4 tmpvar_2;
  tmpvar_2 = fract((vec4(1.0, 255.0, 65025.0, 1.65814e+07) * min ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w), 0.999)));
  gl_FragData[0] = (tmpvar_2 - (tmpvar_2.yzww * 0.00392157));
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 9 math
Keywords { "SHADOWS_CUBE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_LightPositionRange]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o1.xyz, r0, -c8
mov o2.xy, v1
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
// Stats: 9 math
Keywords { "SHADOWS_CUBE" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "UnityLighting" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedmdjbgdnmhcafjijklapnjlgoimaoofdpabaaaaaaneacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcnmabaaaaeaaaabaahhaaaaaa
fjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaa
abaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaaaaaaaaaabaaaaaadgaaaaaf
dccabaaaacaaaaaaegbabaaaabaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_Object2World * _glesVertex).xyz - _LightPositionRange.xyz);
  xlv_TEXCOORD1 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _LightPositionRange;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_335_2;
  lowp vec4 tmpvar_3;
  highp vec2 P_4;
  P_4 = ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3 = texture2D (_MainTex, P_4);
  node_335_2 = tmpvar_3;
  highp float x_5;
  x_5 = (mix (1.0, node_335_2.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_5 < 0.0)) {
    discard;
  };
  highp vec4 tmpvar_6;
  tmpvar_6 = fract((vec4(1.0, 255.0, 65025.0, 1.65814e+07) * min ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w), 0.999)));
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 - (tmpvar_6.yzww * 0.00392157));
  tmpvar_1 = tmpvar_7;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_Object2World * _glesVertex).xyz - _LightPositionRange.xyz);
  xlv_TEXCOORD1 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _LightPositionRange;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
varying highp vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_335_2;
  lowp vec4 tmpvar_3;
  highp vec2 P_4;
  P_4 = ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3 = texture2D (_MainTex, P_4);
  node_335_2 = tmpvar_3;
  highp float x_5;
  x_5 = (mix (1.0, node_335_2.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_5 < 0.0)) {
    discard;
  };
  highp vec4 tmpvar_6;
  tmpvar_6 = fract((vec4(1.0, 255.0, 65025.0, 1.65814e+07) * min ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w), 0.999)));
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 - (tmpvar_6.yzww * 0.00392157));
  tmpvar_1 = tmpvar_7;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
out highp vec3 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_Object2World * _glesVertex).xyz - _LightPositionRange.xyz);
  xlv_TEXCOORD1 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec4 _LightPositionRange;
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_ST;
uniform lowp float _DiffuseHasAlphaclip;
in highp vec3 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 node_335_2;
  lowp vec4 tmpvar_3;
  highp vec2 P_4;
  P_4 = ((xlv_TEXCOORD1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3 = texture (_MainTex, P_4);
  node_335_2 = tmpvar_3;
  highp float x_5;
  x_5 = (mix (1.0, node_335_2.w, _DiffuseHasAlphaclip) - 0.5);
  if ((x_5 < 0.0)) {
    discard;
  };
  highp vec4 tmpvar_6;
  tmpvar_6 = fract((vec4(1.0, 255.0, 65025.0, 1.65814e+07) * min ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w), 0.999)));
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 - (tmpvar_6.yzww * 0.00392157));
  tmpvar_1 = tmpvar_7;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 8 math, 2 textures
Keywords { "SHADOWS_DEPTH" }
Vector 0 [_MainTex_ST]
Float 1 [_DiffuseHasAlphaclip]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
dcl_2d s0
def c2, -1.00000000, 0.50000000, 0.00000000, 1.00000000
dcl_texcoord0 v0.xyzw
dcl_texcoord1 v1.xy
mad r0.xy, v1, c0, c0.zwzw
texld r0.w, r0, s0
add r0.x, r0.w, c2
mul r0.x, r0, c1
add r0.x, r0, c2.y
cmp r0.x, r0, c2.z, c2.w
mov_pp r0, -r0.x
rcp r1.x, v0.w
texkill r0.xyzw
mul oC0, v0.z, r1.x
"
}
SubProgram "d3d11 " {
// Stats: 4 math, 1 textures
Keywords { "SHADOWS_DEPTH" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 80
Vector 48 [_MainTex_ST]
Float 64 [_DiffuseHasAlphaclip]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmedgejiadengoedbhldjcioodgemlllhabaaaaaapeabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdeabaaaa
eaaaaaaaenaaaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaadcaaaaaldcaabaaaaaaaaaaa
egbabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaaadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahbcaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaialp
dcaaaaakbcaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaadpdbaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaaaaaaaaadgaaaaaipccabaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadoaaaaab"
}
SubProgram "gles " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES3"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" }
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 14 math, 2 textures
Keywords { "SHADOWS_CUBE" }
Vector 0 [_LightPositionRange]
Vector 1 [_MainTex_ST]
Float 2 [_DiffuseHasAlphaclip]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
dcl_2d s0
def c3, -1.00000000, 0.50000000, 0.00000000, 1.00000000
def c4, 0.99900001, 0.00392157, 0, 0
def c5, 1.00000000, 255.00000000, 65025.00000000, 16581375.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xy
mad r0.xy, v1, c1, c1.zwzw
texld r0.w, r0, s0
dp3 r0.z, v0, v0
rsq r0.y, r0.z
add r0.x, r0.w, c3
rcp r0.y, r0.y
mul r0.x, r0, c2
mul r0.y, r0, c0.w
min r0.y, r0, c4.x
mul r1, r0.y, c5
add r0.x, r0, c3.y
cmp r0.x, r0, c3.z, c3.w
mov_pp r0, -r0.x
frc r1, r1
texkill r0.xyzw
mad oC0, -r1.yzww, c4.y, r1
"
}
SubProgram "d3d11 " {
// Stats: 11 math, 1 textures
Keywords { "SHADOWS_CUBE" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 80
Vector 48 [_MainTex_ST]
Float 64 [_DiffuseHasAlphaclip]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedmndlhipmpfogomgiaeifcphhlncpjmleabaaaaaaoeacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcamacaaaaeaaaaaaaidaaaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacabaaaaaadcaaaaaldcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaa
aaaaaaaaadaaaaaaogikcaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahbcaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaialpdcaaaaakbcaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdbaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaadkiacaaaabaaaaaaabaaaaaaddaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaahhlohpdpdiaaaaakpcaabaaaaaaaaaaaagaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaahpedaaabhoehppachnelbkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaanpccabaaaaaaaaaaajgapbaiaebaaaaaa
aaaaaaaaaceaaaaaibiaiadlibiaiadlibiaiadlibiaiadlegaobaaaaaaaaaaa
doaaaaab"
}
SubProgram "gles " {
Keywords { "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "glesdesktop " {
Keywords { "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_CUBE" }
"!!GLES3"
}
}
 }
}
Fallback "Diffuse"
}