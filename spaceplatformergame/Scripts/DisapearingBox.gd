extends Node2D

@export var hit_charge: float = 2;
@export var disable_alpha: float = 0.5;
@onready var shape = $Hitbox/CollisionShape2D;
@onready var sprite = $Hitbox/Sprite2D;
var charge_timer = 0;

func _ready() -> void:
	$Hitbox/HitListener.hit.connect(shot);
	pass
	
func _process(delta: float) -> void:
	charge_timer = maxf(charge_timer - delta, 0);
	if charge_timer > 0:
		sprite.self_modulate.a = disable_alpha;
	else:
		sprite.self_modulate.a = 1;
	shape.disabled = charge_timer > 0;
	pass
	
	
func shot(body: Node2D):
	charge_timer = hit_charge;
	pass
