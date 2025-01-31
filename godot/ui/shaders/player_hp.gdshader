shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;
uniform vec4 bar_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool flip = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
	if(!flip) {
		if(UV.x > progress) {
			discard;
		} else {
			COLOR = bar_color * tex_color;
		}
	} else {
		if(UV.x < 1.0 - progress) {
			discard;
		} else {
			COLOR = bar_color * tex_color;
		}
	}
}
