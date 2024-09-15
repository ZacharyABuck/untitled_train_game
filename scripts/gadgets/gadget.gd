extends Node2D
class_name Gadget

var hard_point
var car

# Called when the node enters the scene tree for the first time.
func _ready():
	hard_point = get_parent()
	car = hard_point.car


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
