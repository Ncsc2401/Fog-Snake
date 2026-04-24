shader_type canvas_item;

uniform float band_amount : hint_range(1.0, 10.0, 1);
uniform float progress : hint_range(0.0, 1.0, 0.1);
uniform vec3 transition_color : source_color;

void fragment() {
	float left_bands_mask = mod(UV.y, 1.0 / band_amount);
	left_bands_mask = ceil(left_bands_mask - 1.0 / band_amount / 2.0);
	
	float right_bands_mask = 1.0 - left_bands_mask;
	
	float left_progress_mask = ceil(progress - UV.x);
	float right_progress_mask = floor(progress + UV.x);
	
	vec4 left_side = vec4(transition_color, left_bands_mask * left_progress_mask);
	vec4 right_side = vec4(transition_color, right_bands_mask * right_progress_mask);
	
	vec4 color = left_side + right_side;
	
	COLOR = color;
}
