extends Spatial

onready var map = get_node('/root/WorldModelGenerator')
var wall_scnn = load("res://presets/Wall.tscn");

class_name Wall

# Number of hit before this wall gets destroyed
var durability = -1;

func _init(durability:int=-1):
	durability = durability

func can_continue_on_impact(entity):
	# should check if the entity is the user or not
	if durability == 0:
		return true;
	if durability < 0:
		return false;
	durability-=1;
	return false;

func set_position(pos:Vector3):
	# TODO: create the instance only if not already created.
	# Otherwise just change translation
	var wall_instance = wall_scnn.instance()
	wall_instance.translation = pos;
	return wall_instance;
