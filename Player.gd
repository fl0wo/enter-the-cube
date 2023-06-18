extends Spatial
onready var map = get_node('/root/WorldModelGenerator')

func _ready():
	pass # Replace with function body.

func isColliding(): return false

func _process(dt):
	update_player_position()

func update_player_position():
	translation = map.get_player_world_position()

func _on_StaticBody_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.
