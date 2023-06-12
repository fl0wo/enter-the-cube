extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var direction = Vector3.ZERO
const speed = 20

func isColliding(): return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	if Input.is_action_pressed("ui_right"):
		direction = Vector3(1, 0, 0)
	if Input.is_action_pressed("ui_left"):
		direction = Vector3(-1, 0, 0)
	if Input.is_action_pressed("ui_up"):
		direction = Vector3(0, 0, -1)
	if Input.is_action_pressed("ui_down"):
		direction = Vector3(0, 0, 1)
		
	if isColliding():
		direction = Vector3.ZERO	
	else:
		self.translation = self.translation + direction * dt * speed


func _on_StaticBody_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.
