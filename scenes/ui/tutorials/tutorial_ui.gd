extends CanvasLayer

var root

var tutorials_roster = {
	"world_map" = {
		"scene" = preload("res://scenes/ui/tutorials/tutorial_world_map.tscn"),
		"triggered" = false,
	},
	"basic_controls" = {
		"scene" = preload("res://scenes/ui/tutorials/tutorial_basic_controls.tscn"),
		"triggered" = false,
	},
	"train_damage" = {
		"scene" = preload("res://scenes/ui/tutorials/tutorial_train_damage.tscn"),
		"triggered" = false,
	},
	"charge_attack" = {
		"scene" = preload("res://scenes/ui/tutorials/tutorial_charge_attack.tscn"),
		"triggered" = false,
	},
}

var active_tutorial

func _ready():
	root = get_parent()

func trigger_tutorial(id):
	if root.tutorials_on and tutorials_roster[id]["triggered"] == false:
		tutorials_roster[id]["triggered"] = true
		var new_tutorial = tutorials_roster[id]["scene"].instantiate()
		
		$MarginContainer.position = Vector2(0, get_viewport().size.y*.5)
		
		$MarginContainer/DialogueContainer.add_child(new_tutorial)
		active_tutorial = new_tutorial
		new_tutorial.end_tutorial.connect(end_tutorial)
		
		show()
		
		var tween = create_tween()
		tween.tween_property($MarginContainer, "position", Vector2.ZERO, .5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func end_tutorial():
	if active_tutorial:
		active_tutorial.queue_free()
	hide()
