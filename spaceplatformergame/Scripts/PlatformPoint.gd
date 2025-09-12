extends Node2D


func _ready() -> void:
	$Area2D/HitListener.hit.connect(make_current);
	pass
	
func make_current(node: Node2D):
	get_parent().target_position = position;
	#print("J")
	pass
