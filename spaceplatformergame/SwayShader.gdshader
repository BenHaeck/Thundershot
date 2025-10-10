shader_type canvas_item;

uniform vec2 sway_amount = vec2(0.05);
uniform vec2 offset = vec2(0.0);
uniform float sway_speed = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
	//vec2 processed_vert = VERTEX - 0.5;
	vec2 vert_sway_score = VERTEX - offset;
	VERTEX += sway_amount*(vert_sway_score).yx * vec2(cos(TIME*sway_speed));
	
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
