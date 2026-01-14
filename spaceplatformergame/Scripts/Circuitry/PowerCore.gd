extends PowerSource

class_name Generator

var hit_color = Color.RED;

var charge:float = 0;

#@onready var sprite = $Sprite2D

@onready var light = $Light
@onready var light_scale = light.scale;
@onready var light_alpha = light.color.a;
@onready var particleSystem = $Particles;
@onready var meter = $Meter
@export var charge_time:float = 1;

func _ready() -> void:
	$HitListener.hit.connect(on_hit)
	

func _process(delta: float) -> void:
	#sprite.self_modulate = Color.WHITE.lerp(hit_color, charge / charge_time)
	
	# charge as a scale between 0 and 1
	var percent = (charge / charge_time)
	
	# light
	light.scale = light_scale * percent;
	light.color.a = light_alpha * percent;
	light.visible = charge > 0;
	
	# meter and particle system
	particleSystem.emitting = charge > 0;
	meter.set_value(percent)
	
	# decrement charge
	charge = maxf(charge - delta, 0);
	
	

func on_hit(hb: Node2D):
	#print("aa")
	charge = charge_time;
	pass
	
func get_active():
	return charge > 0.0;
