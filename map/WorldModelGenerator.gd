extends Node
class_name WorldModelGenerator
export(int) var WORLD_SIZE = 20
const CELL_SIZE = 1

# Player position
var player_position := Vector3()

# Each cell tells what it contains 0 nothing 1 the player
var world_data := []

# Each cell contains 4 x Vector3(dx,dy,dz)
#
#       up : Vector3(dx,dy,dz)
#		down: Vector3(dx,dy,dz)
#       left: Vector3(dx,dy,dz)
#       right: Vector3(dx,dy,dz)

# Each one of those  vector3 tells you IN WHAT CELL you should move the player
# if the player wants to go "up", "down", "left" or "right".
# For the cells in the border of a face of a cube, should move you in the right face.

var graph_data := []

func initWorld():
	# Initialize the graph_data structure
	for face in range(6):
		graph_data.append([])
		for i in range(WORLD_SIZE):
			graph_data[face].append([])
			for j in range(WORLD_SIZE):
			
				graph_data[face][i].append([])
				# Build the up, down, left, and right vectors
				var up = Vector3(face,i-1, j)
				var down = Vector3(face,i+1, j)
				var left = Vector3(face,i, j-1)
				var right = Vector3(face,i, j+1)

				graph_data[face][i][j] = {
					"up": up,
					"down": down,
					"left": left,
					"right": right
				}


	# Update the edges of the cube


	# Edge 1: Face 0-2
	for i in range(WORLD_SIZE):
		graph_data[0][i][0]["left"] = Vector3(2,0,i)
		graph_data[2][0][i]["up"] = Vector3(0,i,0)

	# Edge 2: Face 0-4
	for i in range(WORLD_SIZE):
		graph_data[0][i][WORLD_SIZE-1]["right"] = Vector3(4,0,i)
		graph_data[4][0][i]["up"] = Vector3(0,i,WORLD_SIZE-1)
	
	# Edge 3: Face 2-1
	for i in range(WORLD_SIZE):
		graph_data[2][WORLD_SIZE-1][i]["down"] = Vector3(1,i,0)
		graph_data[1][i][0]["left"] = Vector3(2,WORLD_SIZE-1,i)

	# Edge 4: Face 2-3
	for i in range(WORLD_SIZE):
		graph_data[2][i][WORLD_SIZE-1]["right"] = Vector3(3,i,0)
		graph_data[3][i][0]["left"] = Vector3(2,i,WORLD_SIZE-1)
	
	# Edge 5: Face 4-1
	for i in range(WORLD_SIZE):
		graph_data[4][WORLD_SIZE-1][i]["down"] = Vector3(1,i,WORLD_SIZE-1)
		graph_data[1][i][WORLD_SIZE-1]["right"] = Vector3(4,WORLD_SIZE-1,i)


	# Edge 6: Face 4-3
	for i in range(WORLD_SIZE):
		graph_data[4][i][WORLD_SIZE-1]["right"] = Vector3(3,i,WORLD_SIZE-1)
		graph_data[3][i][WORLD_SIZE-1]["right"] = Vector3(4,i,WORLD_SIZE-1)

	# Edge 7: Face 5-2
	for i in range(WORLD_SIZE):
		graph_data[5][i][0]["left"] = Vector3(2,i,0)
		graph_data[2][i][0]["left"] = Vector3(5,i,0)

	# Edge 8: Face 5-4
	for i in range(WORLD_SIZE):
		graph_data[5][i][WORLD_SIZE-1]["right"] = Vector3(4,i,0)
		graph_data[4][i][0]["left"] = Vector3(5,i,WORLD_SIZE-1)

	#Edge 9: Face 5-0
	for i in range(WORLD_SIZE):
		graph_data[5][0][i]["up"] = Vector3(0,0,i)
		graph_data[0][0][i]["up"] = Vector3(5,0,i)

	#Edge 10: Face 5-1
	for i in range(WORLD_SIZE):
		graph_data[5][WORLD_SIZE-1][i]["down"] = Vector3(1,0,i)
		graph_data[1][0][i]["up"] = Vector3(5,WORLD_SIZE-1,i)

	#Edge 11: Face 0-3
	for i in range(WORLD_SIZE):
		graph_data[0][WORLD_SIZE-1][i]["down"] = Vector3(3,0,i)
		graph_data[3][0][i]["up"] = Vector3(0,WORLD_SIZE-1,i)

	#Edge 12: Face 1-3
	for i in range(WORLD_SIZE):
		graph_data[1][WORLD_SIZE-1][i]["down"] = Vector3(3,WORLD_SIZE-1,i)
		graph_data[3][WORLD_SIZE-1][i]["down"] = Vector3(1,WORLD_SIZE-1,i)

	# Set the initial player position
	player_position = Vector3(
		5,
		WORLD_SIZE / 2, 
		WORLD_SIZE / 2
	)


func move_player(direction: String) -> bool:
	print('Player model at',player_position)
	
	# Get the current cell of the player
	var current_cell = graph_data[int(player_position.x)][int(player_position.y)][int(player_position.z)]

	# Check the direction and update the player's position
	if direction == "up":
		player_position = current_cell["up"]
	elif direction == "down":
		player_position = current_cell["down"]
	elif direction == "left":
		player_position = current_cell["left"]
	elif direction == "right":
		player_position = current_cell["right"]
	else:
		# Invalid direction
		return false

	return true


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
	var row = int(player_position.y)
	var col = int(player_position.z)
	# Calculate the position of the player in the world (as x, y, z coordinates)
	# The center of the world is in the origin 0,0,0
	if(face == 0):
		return Vector3(
			row - WORLD_SIZE/2,
			WORLD_SIZE / 2,
			-col + WORLD_SIZE/2 - CELL_SIZE
		)
		
	if(face == 1):
		return Vector3(
			row - WORLD_SIZE/2,
			- WORLD_SIZE / 2,
			-col + WORLD_SIZE/2
		)
		
	if(face == 2):
		return Vector3(
			col - WORLD_SIZE/2, # colonna
			-row + WORLD_SIZE/2 - CELL_SIZE, # riga
			+WORLD_SIZE/2 # fissa
		)
		
	if(face == 4):
		return Vector3(
			col - WORLD_SIZE/2, # colonna
			-row + WORLD_SIZE/2 - CELL_SIZE, # riga
			-WORLD_SIZE/2 # fissa
		)
		
		
	if(face == 3):
		return Vector3(
			+WORLD_SIZE/2, # fissa
			-row + WORLD_SIZE/2 - CELL_SIZE, # riga
			-col + WORLD_SIZE/2 # colonna
		)
		
		
	if(face == 5):
		return Vector3(
			-WORLD_SIZE/2, # fissa
			-row + WORLD_SIZE/2 - CELL_SIZE, # riga
			-col + WORLD_SIZE/2 # colonna
		)
	return Vector3.ZERO

# You can add more functions to modify the world data or perform other actions based on the player's position.

func get_player_world_face_index() -> int:
	return int(player_position.x)
