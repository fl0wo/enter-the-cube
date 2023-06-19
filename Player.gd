extends Spatial
onready var map = get_node('/root/WorldModelGenerator')
export (int) var movementSpeed = 15.0

func _ready():
	translation = map.get_player_world_position()

func isColliding(): return false

func _process(dt):
	update_player_position(dt)

func update_player_position(dt):
	translation = translation.linear_interpolate(
		map.get_player_world_position(),
		movementSpeed * dt
	)

func _on_StaticBody_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.
