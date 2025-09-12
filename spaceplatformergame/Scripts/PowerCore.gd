extends PowerSource

class_name Generator

var hit_color = Color.RED;

var charge:float = 0;

@onready var sprite = $Sprite2D

@export var charge_time:float = 1;

func _ready() -> void:
	$HitListener.hit.connect(on_hit)
	

func _process(delta: float) -> void:
	#sprite.self_modulate = Color.WHITE.lerp(hit_color, charge / charge_time)
	charge = maxf(charge - delta, 0);
	

func on_hit(hb: Node2D):
	#print("aa")
	charge = charge_time;
	pass
	
func get_active():
	return charge > 0.0;
