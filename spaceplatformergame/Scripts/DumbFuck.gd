extends Node2D
@export var health: int = 3;
@export var bullet_velocity: float = 40;
@export var bullet: PackedScene = null;
var player = null;
@export var bullet_recov: float = 3;
var current_bullet_recov:float = 0;

func _ready() -> void:
	var n = get_parent();
	while n.name != "root" and player == null:
		player = n.get_node_or_null("Player");
		n = n.get_parent();
	$Area2D/HitListener.hit.connect(on_hit);
	pass
	
func _process(delta: float) -> void:
	current_bullet_recov = maxf(current_bullet_recov - delta, 0);
	var active = is_instance_of(get_parent(), Area2D) and get_parent().has_overlapping_bodies()
	if active and health > 0:
		if current_bullet_recov <= 0:
			var b: Hitbox = bullet.instantiate();
			add_sibling(b);
			b.position = position;
			b.velocity = (player.global_position - global_position).normalized() * bullet_velocity;
			current_bullet_recov = bullet_recov
	
	pass

func on_hit(body: Node2D):
	health -= 1;
	if health <= 0:
		modulate = Color.GRAY;
	pass
