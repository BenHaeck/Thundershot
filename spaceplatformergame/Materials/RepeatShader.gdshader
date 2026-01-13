shader_type canvas_item;

uniform vec2 repeat_amount = vec2(1,1);

void vertex() {
	//qVERTEX *= repeat_amount;
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, fract(UV * repeat_amount));
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
