extends NPC

@onready var shop_button = $ShopButton
@onready var items_container = %ItemsContainer

@onready var shop_ui = $ShopUI

var furnace_health = preload("res://scenes/ui/shop_furnace_health.tscn")
var edge_panel = preload("res://scenes/ui/shop_edge.tscn")

var items_spawned: bool = false
var item_chosen: bool = false

func _on_player_detector_body_entered(body):
	if body is Player and !item_chosen:
		shop_button.show()


func _on_player_detector_body_exited(body):
	if body is Player:
		shop_button.hide()


func _on_shop_button_pressed():
	if !items_spawned:
		items_spawned = true
		#spawn furnace health
		var new_furnace_health = furnace_health.instantiate()
		items_container.add_child(new_furnace_health)
		new_furnace_health.get_child(0).pressed.connect(heal_furnace)
		
		#spawn new edge
		var new_edge = edge_panel.instantiate()
		items_container.add_child(new_edge)
		var random_edge = EdgeInfo.edge_roster.keys().pick_random()
		while CurrentRun.world.current_edge_info.edge_inventory.has(random_edge):
			random_edge = EdgeInfo.edge_roster.keys().pick_random()
		new_edge.populate(random_edge)
		new_edge.get_child(0).pressed.connect(edge_selected.bind(new_edge.edge))
		
		#spawn new upgrade
		var new_upgrade = edge_panel.instantiate()
		items_container.add_child(new_upgrade)
		var random_upgrade = EdgeInfo.edge_roster.keys().pick_random()
		while !CurrentRun.world.current_edge_info.edge_inventory.has(random_upgrade):
			random_upgrade = EdgeInfo.edge_roster.keys().pick_random()
		new_upgrade.populate(random_upgrade)
		var level = CurrentRun.world.current_edge_info.edge_inventory[random_upgrade]["level"]
		new_upgrade.name_label.text = new_upgrade.name_label.text + " | Level " + str(level) + " to level " + str(level + 1)
		new_upgrade.get_child(0).pressed.connect(edge_selected.bind(new_upgrade.edge))
		
	shop_ui.show()

func disable():
	item_chosen = true
	shop_button.hide()
	shop_ui.hide()

func heal_furnace():
	disable()
	var furnace = CurrentRun.world.current_train_info.furnace
	furnace.health_component.heal(1000)

func edge_selected(edge):
	disable()
	var player = CurrentRun.world.current_player_info.active_player
	player.edge_handler.add_edge(edge)

func _on_texture_button_pressed():
	shop_ui.hide()
