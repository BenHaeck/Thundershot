shader_type canvas_item;

uniform vec2 visible_point;
uniform float visible_radius;

varying vec2 world_position;
void vertex() {
	// Called for every vertex the material is visible on.
	world_position = (MODEL_MATRIX * vec3(VERTEX, 1.0).xyzz).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.

	float d = distance(world_position, visible_point);
	if (d < visible_radius) {
		COLOR.a = (d) / visible_radius;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
