extends Spatial
onready var map = get_node('/root/WorldModelGenerator')
var face_cube_to_rotation = [
	[-36, 45, 0], # 0 V
	[36, 45, 60], # 2 V
	[36, 45, -60], # 3 v
	[-36, 135, -120], # 4 v
	[-36, 135, 120], # 5
	[36, 135, 180], # 1
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
	var new_rotation = Vector3(
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
	rotation_degrees = new_rotation

	#var velocity Vector3.FORWARD var angular_acceleration 10 var speed 0
	#func _physics_process(delta): if (Input.ls_actton_pressed("ui_up') II Inpot.is_action_pressed("ot_left.9 II Inpot.is_action_pressed(•ot_rtght') II Inpot.is_oction_presseWot_down•)): speed 0.5 velocity - vector3(Inpot.get_oction_strengtt('ot_right") - Inpot.get_oction_strength("oi_left'). 0, Inpot.get_oction_strengtt('ot_down') - Inpot.get_oction_strength("otop")).normalized()
	#else: speed - 0
	#Olobel.text "rotation : • • String(red2deglatan2(-velocity.x, -velocity.z))) Oplayer/oesh.rototion.y lerp(Splayer/nesh.rotation.y, aton21-velatty.x, -velocity.z), delta angular_acceleratton) $ployer.nove_ond_sltde(velocity • speed, Vector3.UP)

