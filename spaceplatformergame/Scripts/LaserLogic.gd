extends Node2D


@onready var lasor_container = $LaserHB
@onready var laser_point = $LaserEnd
@onready var rc = $RayCast2D

func _ready() -> void:
	laser_point.process_mode = Node.PROCESS_MODE_INHERIT

func _physics_process(delta: float) -> void:
	var dist: float = (rc.get_collision_point() - rc.global_position).length();
	laser_point.global_position = rc.get_collision_point()
	lasor_container.scale.x = dist / 2
	
