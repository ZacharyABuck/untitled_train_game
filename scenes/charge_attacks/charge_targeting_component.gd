extends Node2D

var target_size: int
var starting_size: int
var final_size: int

@onready var target_circle = $TargetCircle
@onready var shrinking_circle = $ShrinkingCircle

var width_tween: Tween
var height_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	target_size = target_circle.texture.width
	starting_size = shrinking_circle.texture.width

func _process(delta):
	global_position = get_global_mouse_position()

func shrink():
	show()
	
	width_tween = create_tween()
	height_tween = create_tween()
	
	shrinking_circle.texture.width = starting_size
	shrinking_circle.texture.height = starting_size
	
	width_tween.tween_property(shrinking_circle.texture, "width", 1, 1)
	height_tween.tween_property(shrinking_circle.texture, "height", 1, 1)

func finish() -> int:
	hide()
	
	width_tween.kill()
	height_tween.kill()
	
	final_size = shrinking_circle.texture.width
	
	return abs(abs(final_size)-abs(target_size))
