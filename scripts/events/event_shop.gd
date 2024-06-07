extends Event

var alert_text: String = "Shop"

@onready var item_list = $CanvasLayer/ShopContainer/ItemList

var items_count: int = 1

var items_roster = {
	"Repair Train" = {
		"cost" = 20,
		"icon" = preload("res://sprites/train/hard_point_icon.png"),
	},
}




func _ready():
	generate_items()
	await get_tree().create_timer(.5).timeout
	if $Sprite2D/TrackDetector.is_colliding():
		if $Sprite2D/TrackDetector.get_collider().get_collision_layer_value(2) == true:
			$Sprite2D.global_position.x += 300

func generate_items():
	for i in items_count:
		var random_item = items_roster.keys().pick_random()
		var text = random_item + "   $" + str(items_roster[random_item]["cost"])
		item_list.add_item(text, items_roster[random_item]["icon"])
		item_list.set_item_metadata(i, random_item)

func _on_item_clicked(index, _at_position, _mouse_button_index):
	var item = item_list.get_item_metadata(index)
	if items_roster[item]["cost"] <= CurrentRun.world.current_player_info.current_money:
		CurrentRun.world.current_player_info.current_money -= items_roster[item]["cost"]
		match item:
			"Repair Train":
				repair_train()
		item_list.remove_item(index)
	Engine.set_time_scale(.2)

func repair_train():
	print("Repair Train")
	for i in CurrentRun.world.current_train_info.cars_inventory:
		CurrentRun.world.current_train_info.cars_inventory[i]["node"].health = CurrentRun.world.current_train_info.cars_inventory[i]["node"].max_health

func shop_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		print("Event Triggered: Shop")
		set_alert_text_and_play(alert_text)
		CurrentRun.world.current_train_info.train_engine.brake_force = 0
		$Sprite2D/EnterButton.show()

func _on_enter_button_pressed():
	$Sprite2D/EnterButton.hide()
	CurrentRun.world.current_level_info.active_level.ui_open = true
	Engine.set_time_scale(.2)
	$CanvasLayer.show()

func _on_leave_button_pressed():
	print("Leave Button Pressed")
	Engine.set_time_scale(1)
	CurrentRun.world.current_level_info.active_level.ui_open = false
	$CanvasLayer.hide()
	event_finished()
