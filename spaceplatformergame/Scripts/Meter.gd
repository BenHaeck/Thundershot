extends Sprite2D

@onready var bar = $Sprite2D

@onready var bar_size = $Sprite2D.scale.x
@export var fade_length = 0.5;
var should_be_visible = false;

var fade = 0;

func _process(delta: float):
	var fade_dir = -1
	if should_be_visible:
		fade_dir = 1;
		
	fade = clampf(fade + delta * fade_dir / fade_length, 0, 1);
	modulate.a = fade;
		

func set_value (value: float):
	should_be_visible = 0.0 < value && value < 1.0;
	bar.scale.x = bar_size * value;


	
