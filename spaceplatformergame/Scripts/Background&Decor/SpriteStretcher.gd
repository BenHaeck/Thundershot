extends Node2D

@onready var left = $Left
@onready var right = $Right

func _ready() -> void:
	fix_sides()
	pass
	
func fix_sides() -> void:
	left.scale.x = 1/scale.x
	right.scale.x = 1/scale.x
	
