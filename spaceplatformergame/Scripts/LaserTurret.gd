extends Node2D

@export var tracking_rate: float = 1.4;
@export var laser_charge_time:float = 1.5;
@export var invert_active: bool = false;

@onready var laser_gun: Node2D = $LaserGun;
@onready var laser: Node2D = $LaserGun/Laser
@onready var laser_shape: CollisionShape2D = $LaserGun/Laser/LaserHB/Hitbox/CollisionShape2D
@onready var ray: RayCast2D = $RayCast2D
@onready var player: Node2D = get_tree().root.find_child("Player", true, false)
# Called when the node enters the scene tree for the first time.
#var sees_player: bool = false

var laser_power:float = 0;

@onready var power_source: PowerSource = HFuncs.get_generator(self)

@onready var player_lag_position = global_position;
func _ready() -> void:
	$StaticBody2D/HitListener.hit.connect(was_hit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var powered: bool = true
	if power_source != null:
		powered = power_source.get_active() != invert_active
	# makes the ray track the player
	ray.target_position = player.global_position - ray.global_position
	
	# turn the lasers on and off based on whether
	# it can see the player
	if powered:
		var sees_player: bool = !ray.is_colliding()
		laser_power += (1 if sees_player else -1) * delta / laser_charge_time
		
		
		# makes laser track the player imperfectly
		player_lag_position = HFuncs.exp_approach(player_lag_position, player.global_position, tracking_rate*delta)
		
		laser_gun.rotation = (-global_position + player_lag_position).angle()
	else:
		laser_power = 0;
		pass
	laser_power = clampf(laser_power, 0, 1);
	laser_shape.disabled = laser_power < 0.5
	laser.modulate.a = laser_power
	pass


func was_hit (body):
	laser_power = 0;
	pass
