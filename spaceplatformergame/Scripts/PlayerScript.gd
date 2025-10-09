extends CharacterBody2D

class_name Player

const MOVE_SPEED:float = 150/2;
const SPEED_DELTA: float = 700/2;
const SLOW_DELTA: float = 900/2;
const AIR_SPEED_DELTA_MULT: float = 0.56;
const GRAVITY: float = 600/4;
const FALL_GRAVITY: float = 600/2;

const FALL_SPEED: float = 250;
const WALL_SLIDE_SPEED: float = 32;
const WALL_SLIDE_CONTROL: float = 20;

const WALL_SLIDE_FRICTION: float = 500;

const WALL_JUMP_IMPULSE: Vector2 = Vector2(64, 94);

const JUMP_HEIGHT: float = 24;
const JUMP_CANCEL_LOCK: float = 28;
const JUMP_IMPULSE: float = sqrt(2*JUMP_HEIGHT*GRAVITY);

const COYOTE_TIME: float = 0.125;


const SHOOT_BOUNCE:float = 35;
const SHOOT_WALL_BOUNCE:float = 64*0.6;

const SHOOT_DAMPEN: float = 0.25;
const BULLET_SPEED: float = 300;
const BULLET_OFFSET: float = 8;
const SHOOT_RECOV:float = 0.5;

const RF_TRANSITION_VELOCITY = 18;



@export var bullet: PackedScene;

var can_shoot = false;

var jump_anti_queue = false;
var current_shoot_recov:float = 0;
var current_coyote_time:float = 0;
var jump_type = 0;

var dead = false;

var facing_dir = 0;

#var current_action: PlayerAction = PlayerAction.Arial;

@onready var current_state = $States/Arial;

@onready var grounded_state = $States/Grounded;
@onready var arial_state = $States/Arial;
@onready var recoil_state = $States/Recoil;
@onready var wall_sliding_state = $States/WallSliding;

@onready var  sprite = $Sprite;

@export var has_lightning_gun = true;

func _ready() -> void:
	$HitListener.hit.connect(on_hit)
	sprite.play();
	
	if LevelTracking.starting_location == " ":
		LevelTracking.player_has_gun = has_lightning_gun;
	pass
	
func _process(delta: float) -> void:
	if dead:
		get_tree().reload_current_scene()
	pass

func _physics_process(delta: float) -> void:
	# calculate things that inform the state
	current_coyote_time = maxf(current_coyote_time - delta, 0);
	current_shoot_recov = maxf(current_shoot_recov - delta, 0);
	
	var dir = Vector2(Input.get_axis("MLeft", "MRight"), Input.get_axis("MUp", "MDown"));
	
	var jump_pressed = Input.is_action_pressed("Jump");
	if !jump_pressed:
		jump_anti_queue = false;
	
	
	var use_sd = SPEED_DELTA;
	
	var standing = is_on_floor();
	
	if dir.x * velocity.x < 0:
		use_sd += SLOW_DELTA;
	if !standing:
		use_sd *= AIR_SPEED_DELTA_MULT
	
	if standing or is_on_wall():
		if is_on_floor():
			jump_type = 0;
		else:
			jump_type = sign(get_wall_normal().x);
		current_coyote_time = COYOTE_TIME;
	
	if current_state.update_facing_dir:
		set_facing_dir(dir.x);
	
	# state stuff
	if standing:
		current_state = grounded_state;
		can_shoot = true;
	elif is_on_wall():
		current_state = wall_sliding_state;
		if dir.x == 0:
			velocity.x -= get_wall_normal().x * 2;
		set_facing_dir(-get_wall_normal().x);
	elif can_shoot:
		current_state = arial_state;
	else:
		current_state = recoil_state;
	
	
	# actions
	
	if current_state.action_reset:
		can_shoot = true;
	
	if current_state.coyote_enabled and current_coyote_time > 0 and jump_pressed and !jump_anti_queue:
		if jump_type == 0:
			velocity.y = -JUMP_IMPULSE;
		else:
			velocity.y = -WALL_JUMP_IMPULSE.y;
			velocity.x = WALL_JUMP_IMPULSE.x * jump_type;
		jump_anti_queue = true;
		current_coyote_time = 0;
		
	if current_state.jump_cancel and !jump_pressed:
		velocity.y = maxf(velocity.y, -JUMP_CANCEL_LOCK);
		
	if current_state.can_shoot and can_shoot and Input.is_action_pressed("PlFire") and current_shoot_recov <= 0 and LevelTracking.player_has_gun:
		fire()

	
	update_velocity(dir, use_sd, delta * 0.5);
	move_and_slide();
	update_velocity(dir, use_sd, delta * 0.5);
	update_state(dir);
	pass
	
func set_facing_dir(dirX: float):
	if dirX != 0:
		dirX = sign(dirX);
		facing_dir = dirX;
		sprite.flip_h = dirX == -1;
	pass
	
func fire():
	
	var b = bullet.instantiate();
	var fire_dir = (get_global_mouse_position() - global_position).normalized()
	b.global_position = global_position + fire_dir * BULLET_OFFSET;
	b.velocity = BULLET_SPEED * fire_dir;
	
	#if !is_on_floor():
	#	if velocity.y > 0: velocity.y *= SHOOT_DAMPEN;
	#else:
	#	velocity.y = -SHOOT_BOUNCE;
	
	velocity.y = -SHOOT_BOUNCE;
	get_parent().add_child(b);
	
	if current_state == wall_sliding_state:
		velocity.x = SHOOT_WALL_BOUNCE * get_wall_normal().x;
	
	can_shoot = false;
	
	set_facing_dir(fire_dir.x);
	current_state = recoil_state;
	current_shoot_recov = SHOOT_RECOV;
	pass

func update_state(dir):
	if is_on_floor():
		if dir.x != 0:
			#if sprite.animation != "Running":
			sprite.animation = "Running";
		else:
			sprite.animation = "Idle";
	else:
		if is_on_wall():
			sprite.animation = "WallSlide";
			return;
		if !can_shoot:
			sprite.animation = "Gunshot";
			return;
		if velocity.y < -RF_TRANSITION_VELOCITY:
			sprite.animation = "Rising"
		elif velocity.y > RF_TRANSITION_VELOCITY:
			sprite.animation = "Falling";
		else:
			sprite.animation = "Midair";
	pass
	
func update_velocity(dir, speed_delta, delta):
	if current_state.movement_control:
		velocity.x = move_toward(velocity.x, dir.x * MOVE_SPEED, speed_delta * delta);
	#velocity.x = HFuncs.exp_approach(velocity.x, dir.x * MOVE_SPEED, delta * 20);
	
	var current_gravity;
	var current_fall_speed = FALL_SPEED;
	
	
	if velocity.y < 0:
		#if !Input.is_action_pressed("Jump"):
			#velocity.y += JUMP_CANCEL_GRAVITY * delta;
		#	current_gravity = JUMP_CANCEL_GRAVITY;
		#else:
			#velocity.y += GRAVITY * delta;
		current_gravity = GRAVITY;
	else:
		#velocity.y += FALL_GRAVITY * delta;
		current_gravity = FALL_GRAVITY;
		
	if is_on_wall():
		
		#match int(dir.y):
		#	-1:
		#		current_fall_speed = 0;
		#	0, 1:
		#		current_fall_speed = WALL_SLIDE_SPEED;
		
		current_fall_speed = WALL_SLIDE_SPEED + WALL_SLIDE_CONTROL * dir.y
		
		if velocity.y > 0:
			current_gravity = WALL_SLIDE_FRICTION;
	velocity.y = move_toward(velocity.y, current_fall_speed, current_gravity * delta);
	
func on_hit(hb):
	dead = true;
	
	pass
	
enum PlayerAction{
	Grounded,
	Arial,
	Shoot,
	WallSlide
}
