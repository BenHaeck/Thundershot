extends CharacterBody2D

@export var dir = HFuncs.DirectionX.right;

@onready var ray = $RayCast2D
@onready var ray_centered = $RayCast2DCentered
@onready var sprite = $Sprite2D



@export var charge_speed:float = 0
@export var speed:float = 90
@export var acceleration:float = 120*1.5;
@export var animation_name: String = "default"
@export var hit_animation_name: String = "electrified"

@export var hitbox: NodePath = "";
@onready var hitbox_node: Hitbox = get_node_or_null(hitbox)

var charge = 0;
@export var charge_time:float = 2;
@export var disable_hitbox_if_charged = false;

@onready var player = get_tree().root.find_child("Player", true, false)
@onready var sight_box = get_node_or_null("Sprite2D/SightBox")

const GRAVITY = 200;


func _ready() -> void:
	#print(player == null)
	dir = float(dir);
	var hit_listener = get_node_or_null("HitListener")
	if hit_listener != null:
		hit_listener.hit.connect(hit);
		
	sprite.play("default")
	pass
	
func _process(delta: float) -> void:
	charge = maxf(charge - delta, 0);
	
	pass
	
func _physics_process(delta: float) -> void:
	var sees_player = false;
	if sight_box != null and player != null:
		sees_player = sight_box.overlaps_body(player)
	var blocked = !ray.is_colliding() or is_on_wall()
	
	if !ray_centered.is_colliding():
		if ray.is_colliding():
			position.x += dir;
		else:
			position.x -= dir;
	
	var use_speed;
	var shocked = charge > 0
	if shocked:
		use_speed = charge_speed
		sprite.animation = hit_animation_name
	else:
		use_speed = speed
		sprite.animation = animation_name
	
	if disable_hitbox_if_charged and hitbox_node != null:
		if charge > 0:
			hitbox_node.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			hitbox_node.process_mode = Node.PROCESS_MODE_INHERIT
	if sees_player:
		#if !shocked:
		dir = sign(player.global_position.x - global_position.x)
		#print(str(!ray.is_colliding()) + " " + str(is_on_wall()) + " " + str(blocked))
		if blocked:
			velocity.x = 0;
		else:
			velocity.x = move_toward(velocity.x, use_speed * dir, acceleration * delta);
	else:
		if blocked:
			dir = float(dir) * -1;
			position.x += dir * 0.25
			#ray.position.x = absf(ray.position.x) * dir
			velocity.x = 0;
		velocity.x = move_toward(velocity.x, use_speed * dir, acceleration * delta);
	
	if dir != 0:
		sprite.scale.x = absf(sprite.scale.x) * dir
		ray.position.x = absf(ray.position.x) * dir
	velocity.y += GRAVITY * delta;
	move_and_slide()
	pass
	
func hit(body: Node2D):
	if is_instance_of(body, Hitbox):
		if body.damage_type == HitListener.DamageType.Electric:
			charge = charge_time;
			velocity.x = 0;
			
	#print("Wimble")
