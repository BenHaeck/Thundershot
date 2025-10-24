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
	var percent = (charge / charge_time)
	
	light.scale = light_scale * percent;
	
	light.visible = charge > 0;
	light.color.a = light_alpha * percent;
	charge = maxf(charge - delta, 0);
	
	particleSystem.emitting = charge > 0;
	#meter.visible = charge > 0;
	
	meter.set_value(percent)
	
	
	

func on_hit(hb: Node2D):
	#print("aa")
	charge = charge_time;
	pass
	
func get_active():
	return charge > 0.0;
