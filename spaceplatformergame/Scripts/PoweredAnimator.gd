extends AnimatedSprite2D

@onready var generator: PowerSource = HFuncs.get_generator(self);

func _ready() -> void:
	play();
	pass
	
func _process(delta: float) -> void:
	if generator.get_active():
		animation = "Active";
	else:
		animation = "Inactive";
