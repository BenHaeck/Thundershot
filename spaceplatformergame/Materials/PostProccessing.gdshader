shader_type canvas_item;

uniform vec4 world_tint: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float vin_amount = 1.0;

uniform float color_eat = 0.1;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = texture(screen_texture, SCREEN_UV).rgb;
	
	color += (color * color);
	color *= 0.5;
	
	vec3 vin = vec3(SCREEN_UV.xy - 0.5, 0);
	vin = vin * vin * 4.0;
	vin.xy *= vin.xy;
	vin.xy = 1.0 - vin.xy * vin_amount * (1.0 - color.r * color.g * color.b);
	vin.z = vin.x * vin.y;
	
	//vin.z = vin.z * vin_amount;
	//vin.z = 1.0 - vin.z;
	
	color *= vin.z;
	
	
	color *= world_tint.rgb * world_tint.a * 2.0;
	
	COLOR.rgb = color;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
