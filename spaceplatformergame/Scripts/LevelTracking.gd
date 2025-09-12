extends Node

var starting_location = " "

var player_has_gun = false;

func bring_player_if_current(point_name: String, position: Vector2):
	if LevelTracking.starting_location == point_name:
		var pl = get_tree().root.find_child("Player", true, false);
		if pl != null:
			pl.global_position = position;
		else:
			print("Error: could not find player in starting point " + name);
	pass

	
