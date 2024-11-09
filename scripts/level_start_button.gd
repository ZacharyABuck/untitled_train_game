extends Area2D


@onready var all_aboard_button = $AllAboardButton


func _on_body_entered(body):
	if body is Player:
		all_aboard_button.show()


func _on_body_exited(body):
	if body is Player:
		all_aboard_button.hide()


func _on_all_aboard_button_pressed():
	all_aboard_button.disabled = true
	
	await CurrentRun.root.fade_to_black(1)
	CurrentRun.world.despawn_level()
	
	var direction = Vector2(1,0)
	var terrain = LevelInfo.terrain_roster.keys().pick_random()
	var distance = 5

	CurrentRun.world.start_game(direction, distance, terrain)
	
