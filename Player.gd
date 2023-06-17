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
	pass

func _on_StaticBody_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.
