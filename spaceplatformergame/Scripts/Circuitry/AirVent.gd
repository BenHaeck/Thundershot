extends Node2D

@onready var generator: PowerSource = HFuncs.get_generator(self);
var was_active = false
@export var invert_active = false;
@export var launch_strength = 20.0
@export var launch_time = 0.25;

var current_launch_time = 0;

@onready var air_area = $LaunchArea/CollisionShape2D
@onready var vent_sprite = $AnimatedSprite2D

@onready var particle_idle = $ParticleIdle
@onready var particle_burst = $ParticleBurst

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LaunchArea.body_entered.connect(launch);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var active = generator.get_active()
	
	if active != was_active:
		if active == invert_active:
			current_launch_time = launch_time
			vent_sprite.play("Opening")
			particle_burst.emitting = true;
			pass
		else:
			vent_sprite.play("Closing")
			pass
		pass
	
	particle_idle.emitting = active == invert_active
	air_area.disabled = current_launch_time <= 0;
	was_active = active
	current_launch_time = maxf(0, current_launch_time - delta)
	pass
	
func launch(node: Node2D):
	if is_instance_of(node, CharacterBody2D):
		#print(":3")
		
		node.velocity.y = -launch_strength;
