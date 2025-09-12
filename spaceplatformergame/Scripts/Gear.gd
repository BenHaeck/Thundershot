extends Sprite2D

@onready var generator = HFuncs.get_generator(self);

@export var rps:float = 1;

func _process(delta: float) -> void:
	if generator.get_active():
		rotation += rps * delta * 2 * PI;
