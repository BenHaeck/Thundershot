extends CharacterBody2D

@export var dir = HFuncs.DirectionX.right;

@onready var ray = $RayCast2D
@onready var sprite = $Sprite2D



@export var charge_speed = 0
@export var speed = 90
@export var acceleration = 120*1.5;
@export var animation_name: String = "default"
@export var hit_animation_name: String = "electrified"

@export var hitbox: NodePath = "";
@onready var hitbox_node: Hitbox = get_node_or_null(hitbox)

var charge = 0;
@export var charge_time = 2;
@export var disable_hitbox_if_charged = false;


func _ready() -> void:
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
	if !ray.is_colliding() or is_on_wall():
		dir = float(dir) * -1;
		position.x += dir * 0.25
		ray.position.x = absf(ray.position.x) * dir
		velocity.x = 0;
		
	var use_speed;
	if charge > 0:
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
		
	velocity.x = move_toward(velocity.x, use_speed * dir, acceleration * delta);
	sprite.scale.x = absf(sprite.scale.x) * dir
	move_and_slide()
	pass
	
func hit(body: Node2D):
	charge = charge_time;
	#print("Wimble")
