// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 smooth_circle(float inner, float outer, vec3 color) {
	vec2 st = gl_FragCoord.xy/u_resolution;
    float pct = distance(st,vec2(0.5));
    pct = smoothstep(inner, outer, pct);
    return max(vec3(pct), color);
}

void main(){
	vec2 st = gl_FragCoord.xy/u_resolution;
    float pct = 0.0;

    // a. The DISTANCE from the pixel to the center
    pct = distance(st,vec2(0.5));

    // b. The LENGTH of the vector
    //    from the pixel to the center
    vec2 toCenter = vec2(0.5)-st;
    pct = length(toCenter);

    // c. The SQUARE ROOT of the vector
    //    from the pixel to the center
    vec2 tC = vec2(0.5)-st;
    pct = sqrt(tC.x*tC.x+tC.y*tC.y);
    // pct = step(pct, 0.5);
    pct = smoothstep(0.5, 0.3, pct);

    vec3 color = smooth_circle(abs(sin(u_time)), abs(sin(0.1 + u_time)), vec3(1.0, 0., 0.));

	gl_FragColor = vec4( color, 1.0 );
}
