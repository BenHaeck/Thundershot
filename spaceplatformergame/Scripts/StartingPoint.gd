extends Area2D

class_name StartingPoint

@export var point_name = "1"

func _ready():
	#if LevelTracking.starting_location == point_name:
	#	var pl = get_tree().root.find_child("Player", true, false);
	#	if pl != null:
	#		pl.global_position = global_position;
	#	else:
	#		print("Error: could not find player in starting point " + name);
	LevelTracking.bring_player_if_current(point_name, global_position);
			
	body_entered.connect(activate_starting_point);
		
func activate_starting_point(node: Node2D):
	LevelTracking.starting_location = point_name;
	pass
