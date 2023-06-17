extends Node

class_name WorldModelGenerator

# Public fields
export(int) var WORLD_SIZE = 20

# Constants for the world size
const CELL_SIZE = 1

# Data structure to hold world information
var world_data := []

# Player position
var player_position := Vector3()

func initWorld():
	# Initialize the world data structure
	for face in range(6):
		world_data.append([])
		for i in range(WORLD_SIZE):
			world_data[face].append([])
			for j in range(WORLD_SIZE):
				world_data[face][i].append(0)

	# Set the initial player position
	player_position = Vector3(WORLD_SIZE / 2, WORLD_SIZE / 2, 0)

func move_player(direction: Vector2) -> bool:
	# Calculate the new player position
	var new_position = player_position + Vector3(direction.x, direction.y, 0)

	# Check if the new position is within the world bounds
	if is_position_valid(new_position):
		# Update the player position
		player_position = new_position

		# Check if the player reached a face boundary
		if player_position.x < 0:
			shift_player(Vector3(WORLD_SIZE - 1, 0, 0))
		elif player_position.x >= WORLD_SIZE:
			shift_player(Vector3(-WORLD_SIZE + 1, 0, 0))
		elif player_position.y < 0:
			shift_player(Vector3(0, WORLD_SIZE - 1, 0))
		elif player_position.y >= WORLD_SIZE:
			shift_player(Vector3(0, -WORLD_SIZE + 1, 0))
		elif player_position.z < 0:
			shift_player(Vector3(0, 0, WORLD_SIZE - 1))
		elif player_position.z >= WORLD_SIZE:
			shift_player(Vector3(0, 0, -WORLD_SIZE + 1))

		return true

	return false

func shift_player(shift: Vector3):
	# Calculate the current face index
	var current_face = get_player_world_face_index()

	# Update the player position by shifting it
	player_position += shift

	# Calculate the new face index
	var new_face = get_player_world_face_index()



func is_position_valid(position: Vector3) -> bool:
	return position.x >= 0 and \
		position.x < WORLD_SIZE and \
		position.y >= 0 and \
		position.y < WORLD_SIZE and \
		position.z >= 0 and \
		position.z < WORLD_SIZE

func get_player_world_position() -> Vector3:
	# Calculate the face index based on the player's position
	var face = get_player_world_face_index()
	# Calculate the player's position within the face
	var i = player_position.x
	var j = player_position.y
	var k = player_position.z

	# Calculate the 3D position in the game world
	var world_position = Vector3()
	world_position.x = (j - WORLD_SIZE / 2) * CELL_SIZE
	world_position.y = (k - WORLD_SIZE / 2) * CELL_SIZE
	world_position.z = (i - WORLD_SIZE / 2) * CELL_SIZE

	return world_position

# You can add more functions to modify the world data or perform other actions based on the player's position.

func get_player_world_face_index() -> int:
	if player_position.x == WORLD_SIZE - 1:
		return 0
	elif player_position.x == 0:
		return 1
	elif player_position.y == WORLD_SIZE - 1:
		return 2
	elif player_position.y == 0:
		return 3
	elif player_position.z == WORLD_SIZE - 1:
		return 4
	elif player_position.z == 0:
		return 5
	return -1
