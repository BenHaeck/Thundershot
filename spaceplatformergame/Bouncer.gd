extends StaticBody2D

@export var wind_length = 0.2;
@export var bounce_speed = 100;
var active_time = 0;
@onready var shape = $Area2D/CollisionShape2D;
func _ready() -> void:
	$HitListener.hit.connect(bullet_hit);
	$Area2D.body_entered.connect(area_hit);
	pass
	
func _process(delta: float) -> void:
	active_time = maxf(active_time - delta, 0);
	shape.disabled = active_time <= 0;
	
func bullet_hit (body: Node2D):
	active_time = wind_length;
	pass
	
func area_hit(body: Node2D):
	if is_instance_of(body, Player):
		body.velocity.y = -bounce_speed;
	pass
