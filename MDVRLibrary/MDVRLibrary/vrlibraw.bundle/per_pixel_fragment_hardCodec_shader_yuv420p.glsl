precision mediump float;
varying   vec2 v_TexCoordinate;
uniform   mat3 u_ColorConversion;
uniform   lowp  sampler2D us2_SamplerX;
uniform   lowp  sampler2D us2_SamplerY;

void main()
{
    mediump vec3 yuv;
    lowp    vec3 rgb;
    
    yuv.x  = (texture2D(us2_SamplerX,  v_TexCoordinate).r  - (16.0 / 255.0));
    yuv.y = (texture2D(us2_SamplerY,  v_TexCoordinate).r - 0.5);
    yuv.z = (texture2D(us2_SamplerY,  v_TexCoordinate).g - 0.5);
    rgb = u_ColorConversion * yuv;
    gl_FragColor = vec4(rgb, 1);
}
