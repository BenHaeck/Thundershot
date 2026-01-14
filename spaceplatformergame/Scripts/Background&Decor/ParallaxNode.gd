extends Node2D
@onready var cam = get_node("../Camera2D");
@onready var starting_pos = position;

@export var follow_amount: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = starting_pos.lerp(cam.position, 1 - follow_amount)
	pass
