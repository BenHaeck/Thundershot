extends Area2D

class_name LevelTransition

@export var level_path: String = "";

@export var starting_point: String = " "
@export var door_name: String = " ";

var load_new_level = false;

func _ready() -> void:
	LevelTracking.bring_player_if_current(door_name, global_position);
	body_entered.connect(trigger);
	pass
	
func _process(delta: float) -> void:
	if load_new_level:
		get_tree().change_scene_to_file(level_path);
	
func trigger (body: Node2D):
	load_new_level = true;
	LevelTracking.starting_location = starting_point;
	pass
