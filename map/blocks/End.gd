extends Spatial

onready var map = get_node('/root/WorldModelGenerator')
var instance_scnn = load("res://presets/End.tscn");

class_name End

func _init():
	pass

func can_continue_on_impact(entity):
	# should check if the entity is the user or not
	# On hit play next level animation and re-generate the map
	print('Won')
	return true;

func set_position(pos:Vector3):
	# TODO: create the instance only if not already created.
	# Otherwise just change translation
	var block = instance_scnn.instance()
	block.translation = pos;
	return block;
