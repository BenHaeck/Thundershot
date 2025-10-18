extends Node2D


@onready var lazor_container = $LazerHB
@onready var lazer_point = $LazerEnd
@onready var rc = $RayCast2D

func _ready() -> void:
	lazer_point.process_mode = Node.PROCESS_MODE_INHERIT

func _physics_process(delta: float) -> void:
	var dist: float = (rc.get_collision_point() - rc.global_position).length();
	lazer_point.global_position = rc.get_collision_point()
	lazor_container.scale.x = dist / 2
	
