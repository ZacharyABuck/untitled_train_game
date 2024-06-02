extends PanelContainer

@onready var icon = $HBoxContainer/Icon
@onready var reward_label = $HBoxContainer/MarginContainer/VBoxContainer/RewardLabel

func populate(sprite, reward_value):
	icon.texture = sprite
	reward_label.text = "[center]" + "Reward: $" + str(reward_value) + "[/center]"


func _on_despawn_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .5)
	await tween.finished
	queue_free()
