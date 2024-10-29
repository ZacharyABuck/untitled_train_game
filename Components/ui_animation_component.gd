extends Node
class_name UIAnimationComponent

@export var center_pivot: bool = true
@export var hover_scale: Vector2 = Vector2(1,1)
@export var hover_trans: Tween.TransitionType
@export var hover_time: float

var target: Control
var default_scale: Vector2

func _ready():
	target = get_parent()
	
	target.mouse_entered.connect(hover_on)
	target.mouse_exited.connect(hover_off)
	
	call_deferred("setup")
	target.resized.connect(setup)

func setup():
	if center_pivot:
		target.pivot_offset = target.size / 2
	default_scale = target.scale

func hover_on():
	play_tween("scale", hover_scale, hover_time, hover_trans)

func hover_off():
	play_tween("scale", default_scale, hover_time, hover_trans)

func play_tween(property: String, final_value, time: float, trans: Tween.TransitionType):
	var tween = create_tween()
	tween.tween_property(target, property, final_value, time).set_trans(trans)
