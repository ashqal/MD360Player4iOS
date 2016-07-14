precision mediump float;
uniform lowp sampler2D u_TextureX;
uniform lowp sampler2D u_TextureY;
uniform lowp sampler2D u_TextureZ;
uniform mat3 u_ColorConversion;
varying vec2 v_TexCoordinate;

void main()
{
    mediump vec3 yuv;
    lowp    vec3 rgb;
    
    yuv.x = (texture2D(u_TextureX, v_TexCoordinate).r - (16.0 / 255.0));
    yuv.y = (texture2D(u_TextureY, v_TexCoordinate).r - 0.5);
    yuv.z = (texture2D(u_TextureZ, v_TexCoordinate).r - 0.5);
    rgb = u_ColorConversion * yuv;
    gl_FragColor = vec4(rgb, 1);
}
