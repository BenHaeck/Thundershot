extends AnimatedSprite2D

@onready var generator: PowerSource = HFuncs.get_generator(self);

@export var active_animation = "Active"
@export var inactive_animation = "Inactive"

func _ready() -> void:
	play();
	pass
	
func _process(delta: float) -> void:
	var wanted_animation;
	if generator.get_active():
		wanted_animation = "Active";
	else:
		wanted_animation = "Inactive";
	
	if wanted_animation != animation:
		play(wanted_animation)
