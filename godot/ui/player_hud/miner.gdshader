shader_type canvas_item;
uniform float speed_multiplier = 1;
uniform float default_speed = .2;
uniform sampler2D noise : repeat_enable;
uniform float noise_scale : hint_range(0.0, 1.0, 0.01) = 0.3;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 base = vec4(vec3(1.0 - noise_scale), 1);
	COLOR *= texture(noise, UV - vec2(TIME) * default_speed * speed_multiplier) * noise_scale + base;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
