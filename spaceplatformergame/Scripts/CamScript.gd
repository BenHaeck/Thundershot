extends Camera2D

@onready var player = get_parent().get_node("Player");

@export var left_bound = -99999;
@export var right_bound = 99999;
@export var lower_bound = 99999;
@export var upper_bound = -99999;

@export var cam_speed:float = 4;

var cam_pf_time = 0.2;

func _process(delta: float) -> void:
	position = HFuncs.exp_approach(position, player.position, cam_speed * delta);
	
	if cam_pf_time >= 0:
		position = player.position;
	
	cam_pf_time = maxf(-5.0, cam_pf_time - delta);
	
	position.x = clampf(position.x, left_bound, right_bound);
	position.y = clampf(position.y, upper_bound, lower_bound);
	
