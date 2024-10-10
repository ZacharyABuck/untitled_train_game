extends PanelContainer

@onready var mission_label = $HBoxContainer/MarginContainer/VBoxContainer/MissionLabel
@onready var icon = $HBoxContainer/Icon
@onready var reward_label = $HBoxContainer/MarginContainer/VBoxContainer/RewardLabel

func populate(mission_success, sprite, reward_value):
	icon.texture = sprite
	if mission_success:
		reward_label.text = "[center]" + "Reward: " + str(reward_value) + " scrap[/center]"
	else:
		mission_label.text = "[center]Mission Failed[/center]"
		mission_label.modulate = Color.RED
		reward_label.text = ""


func _on_despawn_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .5)
	await tween.finished
	queue_free()
