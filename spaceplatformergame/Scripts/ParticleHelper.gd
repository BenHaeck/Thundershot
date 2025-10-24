extends CPUParticles2D


@export var destroy_when_disabled = true;
@export var destructionTimer = 1;

var current_destruction_time = 0;

func _process(delta: float) -> void:
	if emitting:
		current_destruction_time = 0;
	else:
		current_destruction_time += delta;
	
	if current_destruction_time > destructionTimer:
		queue_free()
		
		
