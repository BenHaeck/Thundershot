extends Area2D

class_name Hitbox
var life_time = 10;

var velocity = Vector2.ZERO;

@onready var sprite: Node2D = get_node_or_null("Sprite2D");

@export var limited_lifetime = true;
@export var peircing = false;
@export var rotate_with_vel = false;

func _ready() -> void:
	body_entered.connect(on_hit);
	area_entered.connect(on_hit_a);
	pass

func _process(delta: float):
	position += velocity * delta
	if limited_lifetime:
		life_time -= delta;
		if life_time < 0:
			queue_free();
			
	if sprite != null:
		sprite.rotation = atan2(velocity.y, velocity.x);
	pass
	
func on_hit(body: Node2D):
	var hl: HitListener = body.get_node_or_null("HitListener");
	if hl != null:
		hl.hit.emit(self);
		#print("Hit")
		
	if !peircing and rotate_with_vel:
		queue_free();
	pass
	
func on_hit_a(area: Area2D):
	var hl: HitListener = area.get_node_or_null("HitListener");
	if hl != null:
		hl.hit.emit(self);
		#print("Hit")
	
	if !peircing:
		queue_free();
		
	pass
