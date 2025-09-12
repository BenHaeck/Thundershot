extends Sprite2D

@export var items: Items = Items.Gun;

func _ready() -> void:
	$Area2D.body_entered.connect(collided);
	pass
	
func collided(body: Node2D):
	if is_instance_of(body, Player):
		match items:
			Items.Gun:
				LevelTracking.player_has_gun = true;
		queue_free();
		
	pass
	

enum Items{
	Gun
}
