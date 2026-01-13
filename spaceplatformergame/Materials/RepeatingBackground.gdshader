shader_type canvas_item;

uniform vec2 tex_size;
uniform vec2 tile_offset;

varying vec2 wp;

vec2 tile_portion(vec2 sp, vec2 pos, vec2 size) {
	return pos + fract((tile_offset + sp)/(tex_size*size))*size;
}

void vertex() {
	wp = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;
	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR = texture(TEXTURE, fract((tile_offset + wp) / tex_size));
	if (wp.y + tile_offset.y > 0.0 ){
		COLOR = texture(TEXTURE, tile_portion(wp, vec2(0.0,0.5), vec2(1.0, 0.5 )));
	}
	else {
		COLOR = texture(TEXTURE, tile_portion(wp, vec2(0.0,0.0), vec2(1.0, 0.5 )));
	}
	
	//COLOR = texture(TEXTURE, tile_portion(wp, vec2(0.0,0.5), vec2(1.0, 0.5 )));
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
