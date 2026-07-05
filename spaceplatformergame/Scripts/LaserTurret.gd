extends Node2D

@export var tracking_rate: float = 1.4;
@export var laser_charge_time:float = 1.5;

@onready var laser: Node2D = $Laser
@onready var laser_shape: CollisionShape2D = $Laser/LaserHB/Hitbox/CollisionShape2D
@onready var ray: RayCast2D = $RayCast2D
@onready var player: Node2D = get_tree().root.find_child("Player", true, false)
# Called when the node enters the scene tree for the first time.
#var sees_player: bool = false

var laser_power:float = 0;

@onready var player_lag_position = global_position;
func _ready() -> void:
	$StaticBody2D/HitListener.hit.connect(was_hit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# makes the ray track the player
	ray.target_position = player.global_position - ray.global_position
	
	# turn the lasers on and off based on whether
	# it can see the player
	var sees_player: bool = !ray.is_colliding()
	laser_power += (1 if sees_player else -1) * delta / laser_charge_time
	laser_power = clampf(laser_power, 0, 1);
	laser_shape.disabled = laser_power < 0.5
	laser.modulate.a = laser_power
	
	# makes laser track the player imperfectly
	player_lag_position = HFuncs.exp_approach(player_lag_position, player.global_position, tracking_rate*delta)
	
	laser.rotation = (-global_position + player_lag_position).angle()
	pass


func was_hit (body):
	laser_power = 0;
	pass
