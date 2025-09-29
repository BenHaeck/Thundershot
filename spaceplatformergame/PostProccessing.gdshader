shader_type canvas_item;

uniform vec4 world_tint: source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform vec4 vin_tint: source_color = vec4(0.5, 0.5, 0.5, 1.0);

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 world_color = texture(screen_texture, SCREEN_UV);
	vec3 inv_color = (1.0-COLOR.rgb);
	//COLOR.rgb = 1.0 - inv_color.rgb * inv_color.rgb * inv_color.rgb;
	COLOR.rgb = (world_color.rgb + world_color.rgb * world_color.rgb) * 0.5;

	vec2 vin = (SCREEN_UV - 0.5)*2.0;
	vin *= vin;
	vin = 1.0 - vin;
	float vin_total = (vin.r * vin.g);
	COLOR.rgb *= world_tint.rgb * (vin_total) + vin_tint.rgb * (1.0-vin_total);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
