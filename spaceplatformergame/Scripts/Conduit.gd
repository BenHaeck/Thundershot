extends PowerSource

class_name Conduit

var power_sources: Array[PowerSource] = [];
var active = false;
func _ready() -> void:
	for i in range(0, get_child_count()):
		var n = get_child(i);
		if is_instance_of(n, PowerSource):
			power_sources.append(n);
	pass
	
func _process(delta: float):
	#var sum = 0;
	active = false
	for n in power_sources:
		if n.get_active():
			active = true;
			break;
	

func get_active():
	return active;
