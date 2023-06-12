extends CSGBox


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _input(ev):
	if (ev is InputEventMouseButton):
		# rotate_z(deg2rad(90)) # twin
		var tween = get_node("Tween")
	
		tween.interpolate_property(self, "rotation_degrees",rotation, Vector3(
			rotation.x,rotation.y,rotation.z + 45
		), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
