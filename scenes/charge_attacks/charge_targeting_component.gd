extends Node2D

var target_size: int
var starting_size: int = 512
var final_size: int

@onready var target_circle = $TargetCircle
@onready var shrinking_circle = $ShrinkingCircle

var width_tween: Tween
var height_tween: Tween

@onready var success_sfx = $TargetingSuccessSFX
@onready var success_particles = $SuccessParticles


# Called when the node enters the scene tree for the first time.
func _ready():
	target_circle.hide()
	shrinking_circle.hide()
	target_size = target_circle.texture.width

func _process(_delta):
	global_position = get_global_mouse_position()

func shrink():
	shrinking_circle.texture.width = starting_size
	shrinking_circle.texture.height = starting_size
	
	target_circle.show()
	shrinking_circle.show()
	
	Engine.time_scale = 0.2
	
	width_tween = create_tween()
	height_tween = create_tween()

	width_tween.tween_property(shrinking_circle.texture, "width", 1, 0.2)
	height_tween.tween_property(shrinking_circle.texture, "height", 1, 0.2)

func finish() -> int:
	Engine.time_scale = 1
	
	target_circle.hide()
	shrinking_circle.hide()
	
	width_tween.kill()
	height_tween.kill()
	
	final_size = shrinking_circle.texture.width
	var final_score = abs(abs(final_size)-abs(target_size))
	
	return final_score

func glow():
	success_particles.global_position = get_global_mouse_position()
	success_particles.emitting = true
