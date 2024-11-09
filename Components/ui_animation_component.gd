extends Node
class_name UIAnimationComponent

@export var center_pivot: bool = true
@export var hover_scale: Vector2 = Vector2(1,1)
@export var hover_trans: Tween.TransitionType
@export var hover_time: float

@export var animate_in: bool = false
@export var animate_in_time: float
@export var animate_in_trans: Tween.TransitionType

var target: Control
var default_scale: Vector2

func _ready():
	target = get_parent()
	
	if animate_in:
		target.hide()
	
	target.mouse_entered.connect(hover_on)
	target.mouse_exited.connect(hover_off)
	
	call_deferred("setup")
	target.resized.connect(setup)

func setup():
	if center_pivot:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	await get_tree().create_timer(.3).timeout
	if animate_in:
		target.scale = Vector2.ZERO
		target.show()
		var scale_tween = create_tween()
		scale_tween.tween_property(target, "scale", Vector2(1,1), animate_in_time).set_trans(animate_in_trans).set_ease(Tween.EASE_OUT)

func hover_on():
	AudioSystem.play_audio("tick", -10)
	play_tween("scale", hover_scale, hover_time, hover_trans)

func hover_off():
	play_tween("scale", default_scale, hover_time, hover_trans)

func play_tween(property: String, final_value, time: float, trans: Tween.TransitionType):
	var tween = create_tween()
	tween.tween_property(target, property, final_value, time).set_trans(trans)
