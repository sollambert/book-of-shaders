#ifdef GL_ES
precision mediump float;
#endif

#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0), 6.0)-3.0)-1.0, 0.0, 1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix( vec3(1.0), rgb, c.y);
}

float quadratic_bezier(float t, float p, float start, float end) {
    float result = (1.-t)*((1.-t)*start + t*p)
        + t*((1.-t)*p + t*end);
    return result;
}

float cubic_bezier(float t, vec2 p, float start, float end) {
    float result = pow(1.-t, 3.)*start
        + pow(3.*(1.-t), 2.)*t*p.x
        + 3.*(1.-t)*pow(t, 2.)*p.y
        + pow(t, 3.)*end;
    return result;
}

float quartic_bezier(float t, vec3 p, float start, float end) {
    float result =
        pow(1.-t, 4.)*start
        + 4.*t*pow(1.-t, 3.)*p.x
        + 6.*pow(t, 2.)*pow(1.-t, 2.)*p.y
        + 4.*pow(t, 3.)*(1.-t)*p.z
        + pow(t, 4.)*end;
    return result;
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec3 color = vec3(0.0);

    // st.x = quadraticBezier(st.x, vec2(.5, .2));
    // Use polar coordinates instead of cartesian
    vec2 toCenter = vec2(0.5)-st;
    float angle = atan(toCenter.y,toCenter.x);
    float radius = length(toCenter)*2.0;

    // Map the angle (-PI to PI) to the Hue (from 0 to 1)
    // and the Saturation to the radius
    color = hsb2rgb(
        vec3(quartic_bezier(
            mod((angle + u_time * 4.), TWO_PI) / TWO_PI,
            vec3(0.2, .13, .8),
            0., 1.),
             radius,
             1.0));
    // color.r = quartic_bezier(color.r, vec3(0.1, 0., 0.8), 0., 1.);
    // color.g = quartic_bezier(color.g, vec3(0.1, .5, 1.), 0., 1.);
    // color.b = quartic_bezier(color.b, vec3(0.1, 0.5, 0.2), 0., 1.);
    gl_FragColor = vec4(color,1.0);
    float distance = sqrt(toCenter.x * toCenter.x + toCenter.y * toCenter.y);
    if (distance > .5) {
        gl_FragColor = vec4(vec4(1.0));
    }
}