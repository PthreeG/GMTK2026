shader_type spatial;

render_mode unshaded, fog_disabled;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;
uniform float fog_distance : hint_range(0.0, 1.0, 0.01);
uniform vec3 fog_rgb : source_color = vec3(1.0, 1.0, 1.0);
uniform int pixel_multiplier : hint_range(1,8,1) = 2;
uniform bool disable_dither;

float luma(vec3 color) {
	vec3 luma = vec3(0.299, 0.587, 0.144);
	return dot(luma, color);
}
int bayer_matrix8x8 (int x, int y) {
	const int[8*8] arr = {
		 0, 32,  8, 40,  2, 34, 10, 42,
		48, 16, 56, 24, 50, 18, 58, 26,
		12, 44,  4, 36, 14, 46,  6, 38,
		60, 28, 52, 20, 62, 30, 54, 22,
		 3, 35, 11, 43,  1, 33,  9, 41,
		51, 19, 59, 27, 49, 17, 57, 25,
		15, 47,  7, 39, 13, 45,  5, 37,
		63, 31, 55, 23, 61, 29, 53, 21
	};
	
	return arr[x + y * 8];
}

float dither8x8(ivec2 position, float brightness) {
	int x = position.x % 8;
	int y = position.y % 8;
	float limit = 0.0;

	if (x < 8) {
		limit = float(bayer_matrix8x8(x, y) + 1)/ 64.0;
	}
	
	return brightness < limit ? 0.0 : 1.0;
}

vec3 dither8x8(ivec2 position, vec3 color) {
	return color * dither8x8(position, luma(color));
}

vec3 ndc(vec2 screen_uv, mat4 inv_projection_matrix) {
	float depth = texture(depth_texture, screen_uv).x;
	
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(screen_uv, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	#endif
	
	return ndc;
}

float depth(vec2 screen_uv, mat4 inv_projection_matrix) {
	vec4 view = inv_projection_matrix * vec4(ndc(screen_uv, inv_projection_matrix), 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
}

vec3 world_position(vec2 screen_uv, mat4 inv_projection_matrix, mat4 inv_view_matrix) {
	vec4 world = inv_view_matrix * inv_projection_matrix * vec4(ndc(screen_uv, inv_projection_matrix), 1.0);
	return world.xyz/world.w;
}

vec3 fog(vec3 fog_color, vec3 screen_color, float depth, float max_distance) {
	depth = 1.0 - pow(1.0 - depth, 3.0);
	return mix(fog_color, screen_color, max(max_distance - depth, 0.0) / max_distance);
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	float depth = depth(SCREEN_UV, INV_PROJECTION_MATRIX)/200.0;
	
	ivec2 pixel_coordinate = ivec2(SCREEN_UV * VIEWPORT_SIZE);
	ivec2 pixelized_pixel_coordinate = pixel_coordinate / pixel_multiplier;
	vec3 pixelized_screen = texture(screen_texture, vec2(pixelized_pixel_coordinate) / VIEWPORT_SIZE * float(pixel_multiplier)).xyz;
	
	//fog pass
	pixelized_screen = (fog(fog_rgb, pixelized_screen, depth, fog_distance));
	
	if (disable_dither) {
			ALBEDO.rgb = pixelized_screen;
		} else {
			ALBEDO.rgb = dither8x8(pixelized_pixel_coordinate, pixelized_screen);
		}
}
