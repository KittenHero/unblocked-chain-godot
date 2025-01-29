shader_type canvas_item;

// hex code = #330000
uniform vec4 color_modifier : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec2 chunk_size = vec2(0.2, 0.2);
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color * color_modifier;

	float growth_position = 1.0 - UV.x - progress;
	vec2 snapped_uv = floor(UV / chunk_size) * chunk_size;

	float random_value = fract(sin(dot(snapped_uv, vec2(12.9898, 78.233))) * 43758.5453);
	
	float glitch_area = growth_position - random_value * 0.05;
	bool is_glitching = glitch_area < 0.0;

 	if (progress > 0.0 && (growth_position < 0.0 || is_glitching)) {
 		COLOR = tex_color * color_modifier; 
	} else {
		discard; 	
	}
}