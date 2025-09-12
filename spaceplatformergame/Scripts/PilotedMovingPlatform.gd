extends Node2D

@export var move_speed:float = 400;
@export var acceleration:float = 0.5;
@export var friction = true;
#@export var move_amount = 32;

@onready var platform:StaticBody2D = $StaticBody2D
@onready var target_position = platform.position;

var velocity = Vector2.ZERO;

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dir_to_target = -(platform.position - target_position).normalized()
	velocity = velocity.move_toward(dir_to_target*move_speed, move_speed * acceleration * delta);
	
	if platform.position.distance_squared_to(target_position) < velocity.length_squared() * delta * delta:
		platform.position = target_position;
		velocity = Vector2.ZERO;
		
	platform.constant_linear_velocity = velocity;
	
	velocity = dir_to_target*move_toward(dir_to_target.dot(velocity), move_speed, move_speed * acceleration * delta)
	
	platform.position += velocity * delta;
	
	#var n_position = platform.position + velocity * delta;
	#if (velocity * delta).dot(target_position - platform.position) < 0:
	#	velocity -= dir_to_target.orthogonal() * dir_to_target.orthogonal().dot(velocity);
	#platform.position = n_position;
		
	
	
	#if platform.position != target_position:
	#	var temp_pos = platform.position.move_toward(target_position, move_speed*delta);
	#	if delta != 0:
	#		platform.constant_linear_velocity = (temp_pos - platform.position) / delta
	#	platform.position = temp_pos;
	#else:
	#	platform.constant_linear_velocity = Vector2.ZERO;
	pass
	

	
