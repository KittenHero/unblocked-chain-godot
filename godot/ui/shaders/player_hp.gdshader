shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0; 
uniform vec4 bar_color = vec4(1.0, 1.0, 1.0, 1.0);   


void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
	
	if(UV.x > progress) {
		discard;
	} else {
		COLOR = bar_color * tex_color;
	}
}
