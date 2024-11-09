extends NPC

@onready var shop_button = $ShopButton
@onready var items_container = %ItemsContainer
@onready var edge_menu = %EdgeMenu
@onready var edge_selected_position = %EdgeSelectedPosition
@onready var edge_exchange_container = $ShopUI/Blur/EdgeExchangeContainer
@onready var too_many_label = $ShopUI/Blur/TooManyLabel


@onready var blur = $ShopUI/Blur

@onready var shop_ui = $ShopUI

var furnace_health = preload("res://scenes/ui/shop_furnace_health.tscn")
var edge_shop_panel = preload("res://scenes/ui/shop_edge.tscn")
var edge_panel = preload("res://scenes/edges/edge_panel.tscn")

var items_spawned: bool = false
var item_chosen: bool = false

var selected_edge

func _on_player_detector_body_entered(body):
	if body is Player and !item_chosen:
		shop_button.show()


func _on_player_detector_body_exited(body):
	if body is Player:
		shop_button.hide()


func _on_shop_button_pressed():
	AudioSystem.play_audio("book_open", -10)
	if !items_spawned:
		items_spawned = true
		#spawn furnace health
		var new_furnace_health = furnace_health.instantiate()
		items_container.add_child(new_furnace_health)
		new_furnace_health.get_child(0).pressed.connect(heal_furnace)
		
		#spawn new edge
		var new_edge = edge_shop_panel.instantiate()
		items_container.add_child(new_edge)
		new_edge.name_label.text = "[center]New Edge[/center]"
		new_edge.get_child(0).pressed.connect(populate_new_edges)
		
		#spawn new upgrade
		if !CurrentRun.world.current_edge_info.edge_inventory.keys().is_empty():
			var new_upgrade = edge_shop_panel.instantiate()
			items_container.add_child(new_upgrade)
			new_upgrade.name_label.text = "[center]Edge Upgrade[/center]"
			new_upgrade.get_child(0).pressed.connect(populate_edge_upgrades)
		
	shop_ui.show()

# Edge Menu
func populate_new_edges():
	blur_fade_in()
	var chosen_edges: Array = []
	for i in 3:
		var random_edge = EdgeInfo.edge_roster.keys().pick_random()
		var index = 1
		var valid = false
		while valid == false:
			if chosen_edges.has(random_edge) or CurrentRun.world.current_edge_info.edge_inventory.has(random_edge):
				random_edge = EdgeInfo.edge_roster.keys().pick_random()
				index += 1
				if index >= EdgeInfo.edge_roster.keys().size():
					break
			else:
				valid = true
		if valid:
			var new_panel = spawn_edge_panel(random_edge)
			edge_menu.add_child(new_panel)
		chosen_edges.append(random_edge)
		
		await get_tree().create_timer(.2).timeout

func populate_edge_upgrades():
	blur_fade_in()
	var chosen_edges: Array = []
	var size = CurrentRun.world.current_edge_info.edge_inventory.keys().size()
	for i in min(size, 3):
		var random_edge = CurrentRun.world.current_edge_info.edge_inventory.keys().pick_random()
		var valid = false
		while valid == false:
			if chosen_edges.has(random_edge):
				random_edge = EdgeInfo.edge_roster.keys().pick_random()
			else:
				valid = true
		if valid:
			var new_panel = spawn_edge_panel(random_edge)
			edge_menu.add_child(new_panel)
		chosen_edges.append(random_edge)

		await get_tree().create_timer(.2).timeout

func spawn_edge_panel(edge):
	var new_panel = edge_panel.instantiate()
	new_panel.hide()
	new_panel.set_info(edge)
	new_panel.clicked.connect(edge_selected)
	return new_panel

func edge_selected(edge, replace):
	if replace:
		CurrentRun.world.current_player_info.active_player.edge_handler.remove_edge(edge)
		CurrentRun.world.current_player_info.active_player.edge_handler.add_edge(selected_edge)
		disable()
	else:
		if CurrentRun.world.current_edge_info.edge_inventory.keys().size() >= 4:
			for i in edge_menu.get_children():
				if i.edge != edge:
					i.queue_free()
				else:
					trigger_edge_exchange(i)
		else:
			CurrentRun.world.current_player_info.active_player.edge_handler.add_edge(edge)
			for i in edge_menu.get_children():
				i.queue_free()

			disable()

func trigger_edge_exchange(selected_panel):
	edge_exchange_container.show()
	too_many_label.show()
	selected_edge = selected_panel.edge
	var pos_tween = create_tween()
	pos_tween.tween_property(selected_panel, "position", edge_selected_position.position, 1).set_trans(Tween.TRANS_CUBIC)
	
	for edge in CurrentRun.world.current_edge_info.edge_inventory.keys():
		var new_panel = spawn_edge_panel(edge)
		edge_exchange_container.add_child(new_panel)
		new_panel.is_being_replaced = true

func blur_fade_in():
	blur.show()
	var tween = create_tween()
	tween.tween_property(blur, "color", Color.WHITE, .5)

func blur_fade_out():
	var tween = create_tween()
	tween.tween_property(blur, "color", Color.TRANSPARENT, .5)
	await tween.finished
	blur.hide()

func disable():
	AudioSystem.play_audio("basic_button_click", -10)
	item_chosen = true
	shop_button.hide()
	shop_ui.hide()
	edge_exchange_container.hide()
	too_many_label.hide()
	blur_fade_out()

func heal_furnace():
	disable()
	var furnace = CurrentRun.world.current_train_info.furnace
	furnace.health_component.heal(1000)

func _on_texture_button_pressed():
	shop_ui.hide()
