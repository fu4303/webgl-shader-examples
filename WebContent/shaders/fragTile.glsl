#define GLSLIFY 1
// Common uniforms
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
 * Returns a value between 1 and 0 that indicates if the pixel is inside the square
 */
float square(vec2 pixel, vec2 bottom_left, float side) {
    vec2 top_right = bottom_left + side;

    return step(bottom_left.x, pixel.x) * step(bottom_left.y, pixel.y) * step(pixel.x, top_right.x)
            * step(pixel.y, top_right.y);
}

/*
 * Returns a value between 1 and 0 that indicates if the pixel is inside the rectangle
 */
float rectangle(vec2 pixel, vec2 bottom_left, vec2 sides) {
    vec2 top_right = bottom_left + sides;

    return step(bottom_left.x, pixel.x) * step(bottom_left.y, pixel.y) * step(pixel.x, top_right.x)
            * step(pixel.y, top_right.y);
}

/*
 * Returns a value between 1 and 0 that indicates if the pixel is inside the circle
 */
float circle(vec2 pixel, vec2 center, float radius) {
    vec2 relative_pos = (pixel - center) / radius;
    float delta = min(2.5 / radius, 0.1);

    return 1.0 - smoothstep(1.0 - delta, 1.0 + delta, dot(relative_pos, relative_pos));
}

/*
 * Returns a value between 1 and 0 that indicates if the pixel is inside the ellipse
 */
float ellipse(vec2 pixel, vec2 center, vec2 radii) {
    vec2 relative_pos = (pixel - center) / radii;
    float delta = min(2.5 / min(radii.x, radii.y), 0.1);

    return 1.0 - smoothstep(1.0 - delta, 1.0 + delta, dot(relative_pos, relative_pos));
}

/*
 * Returns a value between 1 and 0 that indicates if the pixel is inside the line
 */
float line(vec2 pixel, vec2 start, vec2 end, float width) {
    vec2 pixel_dir = pixel - start;
    vec2 line_dir = end - start;
    float line_length = length(line_dir);
    float projected_dist = dot(pixel_dir, line_dir) / line_length;
    float tanjential_dist_sq = dot(pixel_dir, pixel_dir) - pow(projected_dist, 2.0);
    float width_sq = pow(width, 2.0);
    float delta = min(3.0 / width, 0.7);

    return step(0.0, projected_dist) * step(0.0, line_length - projected_dist)
            * (1.0 - smoothstep(1.0 - delta, 1.0 + delta, tanjential_dist_sq / width_sq));
}

/*
 * Returns a rotation matrix for the given angle
 */
mat2 rotate(float angle) {
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

void main() {
    vec2 grid_pos = mod(gl_FragCoord.xy, 250.0);

    vec3 pixel_color = mix(vec3(0.0), vec3(0.3, 0.4, 1.0), square(grid_pos, vec2(5.0, 5.0), 150.0));
    pixel_color = mix(pixel_color, vec3(1.0, 0.4, 0.3), circle(grid_pos, vec2(-10.0, 20.0), 40.0));

    for (float i = 0.0; i < 10.0; ++i) {
        pixel_color = mix(pixel_color, vec3(0.8, 0.8, 0.8),
                line(grid_pos, vec2(10.0, -10.0 * i), vec2(150.0, 100.0 - 10.0 * i), 2.0));
    }

    grid_pos = mod(rotate(radians(45.0)) * gl_FragCoord.xy, 100.0);
    pixel_color = mix(pixel_color, vec3(1.0, 1.0, 1.0), circle(grid_pos, vec2(50.0), 20.0));

    grid_pos = mod(gl_FragCoord.xy, 100.0);
    grid_pos -= 50.0;
    grid_pos = rotate(u_time) * grid_pos;
    grid_pos += 50.0;
    pixel_color = mix(pixel_color, vec3(0.3, 1.0, 0.4), ellipse(grid_pos, vec2(50.0, 50.0), vec2(30.0, 10.0)));
    grid_pos = rotate(u_time) * grid_pos;
    pixel_color = mix(pixel_color, vec3(1.0, 0.2, 1.0), rectangle(grid_pos, vec2(10.0, 10.0), vec2(40.0, 20)));

    gl_FragColor = vec4(pixel_color, 1.0);
}
