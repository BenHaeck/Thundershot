extends Node2D

@onready var platform = $StaticBody2D

@onready var target_pos: Vector2 = $Target.position

@export var speed: float = 1;

@export var invert_activation: bool = false;

var w = 0;
func _physics_process(delta: float) -> void:
	var d = -1;
	if get_parent().get_active() != invert_activation:
		d = 1;
		
	if float(d+1)*0.5 != w:
		w += speed * d * delta;
		w = clampf(w, 0, 1);
		
		var n_pos = Vector2.ZERO.lerp(target_pos, smoothstep(0, 1, w));
		if delta > 0:
			platform.constant_linear_velocity = (n_pos - platform.position) / delta
		platform.position = n_pos;
	else:
		platform.constant_linear_velocity = Vector2.ZERO;
	
	
	pass
