extends Line2D

@export var sag_amount = 32;
@export var anim_speed = 2;

@export var vert_num = 10;

@onready var power_source: PowerSource = HFuncs.get_generator(self)

@onready var active_color: Color = Color.CYAN;
@onready var inactive_color: Color = self_modulate

var anim = 1;

func _ready() -> void:
	var start = points[0]
	var end = points[1];
	
	for i in range(0, len(points)):
		var t = float(i) / (len(points) - 1);
		points[i] = start.lerp(end, t);
		var th = 2*(t - 0.5);
		points[i].y += sag_amount * (1 - th * th)
		pass
		
func _process(delta: float) -> void:
	if power_source.get_active():
		anim = (anim + delta * anim_speed);
		anim -= floorf(anim / (PI*2)) * PI*2
	else:
		anim = 0;
	self_modulate = inactive_color.lerp(active_color, 0.5 - 0.5*cos(anim))
	pass
	
