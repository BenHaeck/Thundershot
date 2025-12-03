extends PowerSource

@export var charge:float = 0;
@export var charge_max:float = 5;
@export var currently_active = false;

@onready var meter = $Meter

func _process(delta: float) -> void:
	var dir;
	if currently_active:
		dir = -1;
	else:
		dir = 1;
	charge += dir * delta;
	
	if charge < 0:
		currently_active = false;
	elif charge > charge_max:
		currently_active = true;
		
	meter.set_value(clampf(charge / charge_max, 0, 1))

func get_active():
	return currently_active;
