extends Spatial
onready var map = get_node('/root/WorldModelGenerator')
var face_cube_to_rotation = [
	[-36, 45, 0], # 0 V
	[36, 135, 180], # 1
	[36, 45, 60], # 2 V
	[36, 45, -60], # 3 v
	[-36, 135, -120], # 4 v
	[-36, -45, 120], # 5
]

func _ready():
	pass

func _process(delta):
	# Follow with a slerp the cube rotation
	var face_index = map.get_player_world_face_index()

	var target_rotation = Vector3(
		face_cube_to_rotation[face_index][0],
		face_cube_to_rotation[face_index][1],
		face_cube_to_rotation[face_index][2]
	)
	face_cube_to_rotation[face_index];

	# float lerp_angle(from: float, to: float, weight: float)
	rotation_degrees = Vector3(
		rad2deg(lerp_angle(
			deg2rad(rotation_degrees.x),
			deg2rad(target_rotation.x),
			0.1
		)),
		rad2deg(lerp_angle(
			deg2rad(rotation_degrees.y),
			deg2rad(target_rotation.y),
			0.1
		)),
		rad2deg(lerp_angle(
			deg2rad(rotation_degrees.z),
			deg2rad(target_rotation.z),
			0.1
		))
	)
