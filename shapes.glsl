// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float border(float width, vec2 dim) {
    // bottom-left
    vec2 bl = floor(dim + (width - 1.0));
    float pct = bl.x * bl.y;

    // top-right
    vec2 tr = floor(width - dim);
    pct *= tr.x * tr.y;
    return pct;
}

float rect(vec2 st, vec2 coord, vec2 dim) {
    if (st.x < coord.x
       || st.y > coord.y
       || st.x > coord.x + dim.x
       || st.y < coord.y - dim.y) {
        return 1.0;
    }
    float l = step(coord.x, st.x);
    float r = step(st.x - dim.x, coord.x);
    float b = step(coord.y, st.y);
    float t = step(st.y - dim.y, coord.y);
    float pct = l * r * t * b;
    return pct;
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(1.0);

    color = vec3(border(.1, st));
    color = min(
        vec3(
        rect(
            st,
              vec2(0.3, 0.3),
              vec2(0.1, 0.1))),
        color);

    gl_FragColor = vec4(color,1.0);
}