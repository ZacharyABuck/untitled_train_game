extends Area2D

@onready var sprite = $Sprite2D

var active: bool = false
var gadget
signal clicked
signal hovered

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("shoot") and active:
		clicked.emit(gadget)

func _on_mouse_entered():
	if active:
		GadgetInfo.selected_gadget = gadget
		hovered.emit(GadgetInfo.gadget_roster[gadget]["name"], GadgetInfo.gadget_roster[gadget]["cost"])
		$AudioStreamPlayer.play()
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.2,1.2), .05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), .05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	GadgetInfo.selected_gadget = null
	hovered.emit(null, null)
