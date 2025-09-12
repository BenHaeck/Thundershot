extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func exp_approach(from, to, delta):
	return (from - to) * exp(-delta) + to;
	pass
	
func get_generator(node: Node):
	while node.name != "root":
		if is_instance_of(node, PowerSource):
			return node;
		node = node.get_parent();
	
	return null;
	
