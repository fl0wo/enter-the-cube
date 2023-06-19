extends Node

export(int) var WORLD_SIZE = 10
var MULT_FACTOR = 20/WORLD_SIZE
const CELL_SIZE = 1
export(int) var SPAWN_CUBE_FACE = 0;
# Player position
var player_position := Vector3()
var player_faces_indexes := [SPAWN_CUBE_FACE]
var first_move := false
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
		SPAWN_CUBE_FACE,
		WORLD_SIZE / 2, 
		WORLD_SIZE / 2
	)
	
	
func move_player() -> bool:
	if(!player_last_direction):
		return false;
	
	# Get the current cell of the player
	var current_cell = graph_data[int(player_position.x)][int(player_position.y)][int(player_position.z)]
	var prev_face = get_player_world_face_index()
	# Check the direction and update the player's position
	
	var translated_direction = adjust_player_position(
		current_cell,
		player_last_direction.direction
	)
	
	if(translated_direction):
		var cur_face = get_player_world_face_index()
		if(cur_face != prev_face):
			player_faces_indexes.append(cur_face);
			first_move = false
			player_last_direction.direction = translated_direction
	else:
		player_last_direction = null
	return true

func pick_direction(direction:String) -> bool:
	if(!player_last_direction or true):
		player_last_direction = {
			"face" : get_player_world_face_index(),
			"direction": direction # maybe instead we should calculate the translated direction
		}
		first_move = true
		return true;
	print(player_last_direction)
	return false;

func adjust_player_position(current_cell,direction):
	if(!player_last_direction):
		return false;

	var face_index = get_player_world_face_index()
	var prev_face_index = get_player_world_face_index(1)

	var translated_direction = translate_direction(
		first_move,
		direction,
		face_index,
		prev_face_index
	)
	
	var desired_position = current_cell[translated_direction]

	var desired_cell = graph_data[desired_position.x][desired_position.y][desired_position.z]
	
	if("block" in desired_cell and desired_cell.block and desired_cell.block.has_method('can_continue_on_impact')):
		if(desired_cell.block.can_continue_on_impact(self)):
			player_position = desired_position
		else:
			player_last_direction = null
			first_move = false
			return false
	else:
		player_position = desired_position
	
	return translated_direction

const translated_directions = [
		[
			# Face Number 0
			# from 0
			{
				"up":"up",
				"down":"down",
				"left":"left",
				"right":"right"
			},
			"teleport", # from 1
			"right", # from 2
			"up", # from 3
			"left", # from 4
			"down" # from 5
		],
		[
			# Face Number 1
			"teleport", # from 0
			{"up":"up","down":"down","left":"right","right":"left"}, # from 1
			"right", # from 2
			"up", # from 3
			"left", # from 4
			"down" # from 5
		],
		[
			# Face Number 2
			"down", # from 0
			"up", # from 1
			{"up":"left","down":"right","left":"down","right":"up"}, # from 2
			"left", # from 3
			"teleport", # from 4
			"right" # from 5
		],
		[
			# Face Number 3
			"down", # from 0
			"up", # from 1
			"right", # from 2
			{"up":"up","down":"down","left":"left","right":"right"}, # from 3
			"left", # from 4
			"teleport" # from 5
		],
		[
			# Face Number 4
			"down",# from 0
			"up", # from 1
			"teleport", # from 2
			"left", # from 3
			{"up":"left","down":"right","left":"up","right":"down"}, # from 4
			"right" # from 5
		],
		[
			# Face Number 5
			"down", # from 0 
			"up", # from 1 
			"right", # from 2 
			"teleport", # from 3
			"left", # from 4
			{"up":"down","down":"up","left":"left","right":"right"} # from 5
		]
	];

func translate_direction(first_move,direction,face_index,prev_face_index):
	if(first_move): return translated_directions \
		[face_index] \
		[face_index] \
		[direction]

	var translated_direction_info = translated_directions \
		[face_index] \
		[prev_face_index]

	if(prev_face_index!=face_index):
		return translated_direction_info

	return translated_direction_info[direction]


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
			-col + WORLD_SIZE/2
		)
		
	if(face == 1):
		return Vector3(
			row - WORLD_SIZE/2 + CELL_SIZE,
			- WORLD_SIZE / 2 - CELL_SIZE,
			-col + WORLD_SIZE/2 - CELL_SIZE
		)
		
	if(face == 2):
		return Vector3(
			col - WORLD_SIZE/2 + CELL_SIZE, # colonna
			-row + WORLD_SIZE/2 - CELL_SIZE, # riga
			+WORLD_SIZE/2 + CELL_SIZE # fissa
		)
		
	if(face == 4):
		return Vector3(
			col - WORLD_SIZE/2 + CELL_SIZE, # colonna
			-row + WORLD_SIZE/2, # riga
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


func shift_position(
		position:Vector3,
		direction:String,
		distance:int) -> Vector3:
			
	var face_index = position.x
	var prev_face_index = position.x
	var current_position = cell_of(position)
	var actual_pos;
	
	for i in range(distance):
		var translated_direction = translate_direction(
			i==0,
			direction,
			face_index,
			prev_face_index
		)
		actual_pos = current_position[translated_direction]
		current_position = cell_of(actual_pos)
		if (actual_pos.x != face_index):
			prev_face_index = face_index
			face_index = actual_pos.x
			
	return actual_pos;

func get_player_world_face_index(prev:int=0) -> int:
	if(prev==0):
		return int(player_position.x);
		
	var id = player_faces_indexes.size()-(1+prev);
	if(id >= 0 && id < player_faces_indexes.size()):
		return player_faces_indexes[id]
	else:
		return get_player_world_face_index()

func get_player_model_position():
	return player_position

func set_player_position(pos:Vector3):
	player_position = pos;
	player_faces_indexes[player_faces_indexes.size()-1] = pos.x;

func cell_of(position:Vector3):
	return graph_data[int(position.x)][int(position.y)][int(position.z)]
