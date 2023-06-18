extends Node

onready var map = get_node('/root/WorldModelGenerator');

export (int) var refresh_freq_ms = 50;
var cur_passed_ms = 0;

func _ready():
	pass

func _process(delta):
	cur_passed_ms+=(delta * 1000);

	if(cur_passed_ms>refresh_freq_ms):
		cur_passed_ms = (cur_passed_ms-refresh_freq_ms);
		map.move_player();
