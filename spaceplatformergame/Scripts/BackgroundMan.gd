extends Sprite2D

@onready var cam = get_node("../Camera2D");

@export var offset_mult: float = 1.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	material.set_shader_parameter("tile_offset", 
	-(cam.global_position - global_position) * (1-offset_mult)
	- global_position
	);
	pass
