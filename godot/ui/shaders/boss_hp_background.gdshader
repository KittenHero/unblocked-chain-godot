shader_type canvas_item;

// hex code = #330000
uniform vec4 color_modifier : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// uniform vec2 chunk_size = vec2(0.2, 0.2);
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform int extra_height = 2;


void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	// COLOR = tex_color * color_modifier;

	float growth_position = 1.0 - UV.x - progress;
	vec2 snapped_uv = floor(UV / TEXTURE_PIXEL_SIZE) * TEXTURE_PIXEL_SIZE;

	float random_value = fract(sin(dot(snapped_uv, vec2(12.9898, 78.233))) * 43758.5453);

	float glitch_area = growth_position - random_value * 0.05;
	bool is_glitching = glitch_area < 0.0;

	// dump colors outside original UV
	if ((UV.y > 1.0 || UV.y < 0.0) && UV.x > 1.0 - progress) {
		tex_color = vec4(0);
	}
 	if (progress > 0.0 && (growth_position < 0.0 || is_glitching)) {
 		COLOR = tex_color * color_modifier;
	} else {
		discard;
	}
}

void vertex() {
	float scaler = 1.0 + float(extra_height) * TEXTURE_PIXEL_SIZE.y;
	// extend canvas height
	VERTEX.y *= scaler;
	// move existing UV to middle
	UV.y = UV.y * scaler - 0.5 * float(extra_height) * TEXTURE_PIXEL_SIZE.y;
}