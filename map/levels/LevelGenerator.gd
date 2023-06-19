extends Node

var map;
var all_blocks;

# Private
var start_position;

func init_vars(map):
	randomize();
	start_position = pick_random_cell(map);
	all_blocks=[];

func init_level(wall,end,map):
	init_vars(map)
	
	map.set_player_position(start_position)
	
	# Go backwords from the end to generate the walls in the right position
	var steps_to_win = int(rand_range(1,5)); # Depending on the difficulty
	var current_position = start_position;

	var last_direction = null

	for i in range(steps_to_win):
		last_direction = in_array_excluding(
			["up","down","left","right"],
			opposite_direction(last_direction)
		)[int(rand_range(0,3))]; # <- ^ -> v

		# Cell where the user should be in order to solve the puzzle
		var next_position = pick_random_cell_on_the_same_cross_of(
			current_position,
			map,
			last_direction
		);

		add_block(
			map,
			wall,
			# Shift by 1 the wall so the user can hit it occuping the right cell
			map.shift_position(next_position,opposite_direction(last_direction),1)
		);

		current_position = next_position;
	
	
	add_block(
		map,
		end,
		current_position
	);


	return all_blocks

func initBlocksRandomly(block,map):
	var walls_instances = []
	for i in range(6):
		for j in range(map.WORLD_SIZE-2):
			for k in range(map.WORLD_SIZE-2):
				if(j>2 and k>2):
					if(randi() % 20 == 0):
						map.graph_data[i][j][k].block = block
						walls_instances.append(
							block.set_position(map.map_frc_into_xyz(Vector3(i,j,k)))
						)
	return walls_instances;

func add_block(map,block,coords:Vector3):
	map.graph_data[coords.x][coords.y][coords.z].block = block
	all_blocks.append(block.set_position(map.map_frc_into_xyz(Vector3(coords.x,coords.y,coords.z))))
	
func pick_random_cell(map):
	return Vector3(
		int(rand_range(0,6)),
		int(rand_range(2,map.WORLD_SIZE-2)),
		int(rand_range(2,map.WORLD_SIZE-2))
	)

func pick_random_cell_on_the_same_cross_of(
		position,
		map,
		direction):
	var distance = int(rand_range(2,map.WORLD_SIZE*4-2)); # 2 to 4 times the size of each face of the cube (map)
	var new_position = map.shift_position(
		position,
		direction,
		distance
	)
	
	return new_position
	

func in_array_excluding(array,excluded):
	var new_array = []
	for i in range(array.size()):
		if(array[i] != excluded):
			new_array.append(array[i])
	return new_array

func opposite_direction(dir):
	if(dir == "up"):
		return "down"
	elif(dir == "down"):
		return "up"
	elif(dir == "left"):
		return "right"
	elif(dir == "right"):
		return "left"
	else:
		return null
