extends Node2D


@onready var lazor_container = $LazerHB
@onready var rc = $RayCast2D


func _physics_process(delta: float) -> void:
	var dist: float = (rc.get_collision_point() - rc.global_position).length();

	lazor_container.scale.x = dist / 2
	
