extends Spatial
onready var map = get_node('/root/WorldModelGenerator');

var face_cube_to_rotation = [
		  # Face 0
		[-36, 45, 0],
		  # Face 1
		[36, 135, 180],
		  # Face 2
		[36, 45, 60],
		# Face 3
		[36, 45, -60],
		# Face 4
		[-36, 135, -120],
		# Face 5
		[-36, -46, 120],
]

export (float) var camera_speed = 4

func _ready():
	pass

func _process(delta):
	# Follow with a slerp the cube rotation
	var prev_face_index = map.get_player_world_face_index(+1);
	var face_index = map.get_player_world_face_index()
	
	var target_rotation = Vector3(
		face_cube_to_rotation[face_index][0],
		face_cube_to_rotation[face_index][1],
		face_cube_to_rotation[face_index][2]
	)

	# float lerp_angle(from: float, to: float, weight: float)
	rotation_degrees = Vector3(
		rad2deg(lerp_angle2(
			deg2rad(rotation_degrees.x),
			deg2rad(target_rotation.x),
			delta * camera_speed
		)),
		rad2deg(lerp_angle2(
			deg2rad(rotation_degrees.y),
			deg2rad(target_rotation.y),
			delta * camera_speed
		)),
		rad2deg(lerp_angle2(
			deg2rad(rotation_degrees.z),
			deg2rad(target_rotation.z),
			delta * camera_speed
		))
	)
	print("from",deg2rad(rotation_degrees.y), "to",			deg2rad(target_rotation.y))

func lerp_angle2(from_angle: float, to_angle: float, weight: float) -> float:
	var difference = wrapf(to_angle - from_angle, -PI, PI)
	var shortest_distance = shortest_angular_distance(from_angle, to_angle)
	return wrapf(from_angle + shortest_distance * weight, -PI, PI)

func shortest_angular_distance(from_angle: float, to_angle: float) -> float:
	var difference = wrapf(to_angle - from_angle, -PI, PI)
	if difference > PI:
		difference -= 2 * PI
	elif difference < -PI:
		difference += 2 * PI
	return difference

