extends Node

export(int) var WORLD_SIZE = 20
const CELL_SIZE = 1

# Player position
var player_position := Vector3()
var player_faces_indexes := [0]
#                          from face, to direction
var player_last_direction;

# Each cell tells what it contains 0 nothing 1 the player
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
		0,
		WORLD_SIZE / 2, 
		WORLD_SIZE / 2
	)

func initBlocksRandomly(block):
	var walls_instances = []
	for i in range(6):
		for j in range(WORLD_SIZE-2):
			for k in range(WORLD_SIZE-2):
				if(j>2 and k>2):
					if(randi() % 20 == 0):
						graph_data[i][j][k].block = block
						walls_instances.append(
							block.set_position(map_frc_into_xyz(Vector3(i,j,k)))
						)
	return walls_instances;
func move_player() -> bool:
	if(!player_last_direction):
		return false;
		
	print('Player model at',player_position)
	
	# Get the current cell of the player
	var current_cell = graph_data[int(player_position.x)][int(player_position.y)][int(player_position.z)]
	var prev_face = get_player_world_face_index()
	# Check the direction and update the player's position
	
	var is_valid_direction = adjust_player_position(
		current_cell,
		player_last_direction.direction
	)
	
	if(is_valid_direction):
		var cur_face = get_player_world_face_index()
		if(cur_face != prev_face):
			player_faces_indexes.append(cur_face)
	else:
		player_last_direction = null
		
	return true

func pick_direction(direction:String) -> bool:
	print('Want to pick_direction')
	if(!player_last_direction or true):
		player_last_direction = {
			"face" : get_player_world_face_index(),
			"direction":direction
		}
		return true;
	print(player_last_direction)
	return false;

func adjust_player_position(current_cell,direction):
	var prev_face_index = get_player_world_face_index(1)
	var face_index = get_player_world_face_index()
	var hor = 1 if (prev_face_index > 1 or face_index > 1) else 0;
	
	print("Prev at",prev_face_index,"Now at",face_index)
	
	var translated_directions = [
		[
			{"up":"up","down":"down","left":"left","right":"right"}, # 0 vert v
			{"up":"up","down":"down","left":"left","right":"right"}, # 0 hor clock-wise v
		], 
		[
			{"up":"down","down":"up","left":"right","right":"left"}, # 1 vert v
			{"up":"down","down":"up","left":"right","right":"left"}, # 1 hor clock-wise v
		],
		[
			{"up":"left","down":"right","left":"down","right":"up"}, # 2 vert v
			{"up":"left","down":"right","left":"down","right":"up"}, # 2 hor clock-wise
		],
		[
			{"up":"up","down":"down","left":"left","right":"right"}, # 3 vert v
			{"up":"left","down":"right","left":"up","right":"down"}, # 3 hor clock-wise v

		],
		[
			{"up":"left","down":"right","left":"up","right":"down"}, # 4 vert v
			{"up":"right","down":"left","left":"up","right":"down"}, # 4 hor clock-wise v
			
		],
		[
			{"up":"down","down":"up","left":"left","right":"right"}, # 5 vert v
			{"up":"right","down":"left","left":"down","right":"up"}, # 5 hor clock-wise 
		]
	];
	
	if direction == "up":
		player_position = current_cell[translated_directions[face_index][hor]["up"]]
	elif direction == "down":
		player_position = current_cell[translated_directions[face_index][hor]["down"]]
	elif direction == "left":
		player_position = current_cell[translated_directions[face_index][hor]["left"]]
	elif direction == "right":
		player_position = current_cell[translated_directions[face_index][hor]["right"]]
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
	return map_frc_into_xyz(Vector3(face,row,col));

func map_frc_into_xyz(frc:Vector3) -> Vector3:
	var face = int(frc.x)
	var row = int(frc.y)
	var col = int(frc.z)
	if(face == 0):
		return Vector3(
			row - WORLD_SIZE/2 + CELL_SIZE,
			WORLD_SIZE / 2 + CELL_SIZE,
			-col + WORLD_SIZE/2 - CELL_SIZE
		)
		
	if(face == 1):
		return Vector3(
			row - WORLD_SIZE/2 + CELL_SIZE,
			- WORLD_SIZE / 2 - CELL_SIZE,
			-col + WORLD_SIZE/2 + CELL_SIZE
		)
		
	if(face == 2):
		return Vector3(
			col - WORLD_SIZE/2 + CELL_SIZE, # colonna
			-row + WORLD_SIZE/2 + CELL_SIZE, # riga
			+WORLD_SIZE/2 + CELL_SIZE # fissa
		)
		
	if(face == 4):
		return Vector3(
			col - WORLD_SIZE/2 + CELL_SIZE, # colonna
			-row + WORLD_SIZE/2 - CELL_SIZE, # riga
			-WORLD_SIZE/2 - CELL_SIZE # fissa
		)
		
		
	if(face == 3):
		return Vector3(
			+WORLD_SIZE/2 + CELL_SIZE, # fissa
			-row + WORLD_SIZE/2 - CELL_SIZE, # riga
			-col + WORLD_SIZE/2 + CELL_SIZE # colonna
		)
		
		
	if(face == 5):
		return Vector3(
			-WORLD_SIZE/2 - CELL_SIZE, # fissa
			-row + WORLD_SIZE/2, # riga
			-col + WORLD_SIZE/2 + CELL_SIZE/2 # colonna
		)
	return Vector3.ZERO


func get_player_world_face_index(prev:int=0) -> int:
	if(prev==0):
		return int(player_position.x);
		
	var id = player_faces_indexes.size()-(1+prev);
	if(id >= 0 && id < player_faces_indexes.size()):
		return player_faces_indexes[id]
	else:
		return 0;
