extends CanvasLayer

@onready var edge_container = $MarginContainer/GridContainer/EdgeContainer
@onready var world = $".."
@onready var weapon_list = $WeaponList


# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for edge in EdgeInfo.edge_roster:
		#set edge name
		var hbox = edge_container.get_child(index)
		hbox.get_child(0).text = edge
		
		#set edge level
		hbox.get_child(1).text = "0"
		
		#connect button
		hbox.get_child(2).pressed.connect(level_up_edge.bind(edge))
		
		index += 1
	
	for weapon in WeaponInfo.weapons_roster:
		var weapon_info = WeaponInfo.weapons_roster[weapon]
		weapon_list.add_item(weapon, weapon_info["sprite"])

func _input(event):
	if event.is_action_pressed("Debug Menu"):
		if visible:
			world.unpause_game()
			hide()
		else:
			world.pause_game()
			show()

func level_up_edge(edge_reference):
	if world.current_player_info.active_player != null:
		var player = world.current_player_info.active_player
		player.edge_handler.add_edge(edge_reference)
	else:
		print("no player")

func refresh_labels():
	await get_tree().create_timer(.5).timeout
	for hbox in edge_container.get_children():
		if world.current_edge_info.edge_inventory.has(hbox.get_child(0).text):
			hbox.get_child(1).text = str(world.current_edge_info.edge_inventory[hbox.get_child(0).text]["level"])

func _on_level_auto_complete_button_pressed():
	CurrentRun.world.level_complete()
	hide()

func _on_take_damage_button_pressed():
	if CurrentRun.world.current_player_info.active_player:
		var attack = Attack.new()
		attack.attack_damage = 10
		CurrentRun.world.current_player_info.active_player.hurtbox_component.damage(attack, null)

func _on_gain_xp_button_pressed():
	if CurrentRun.world.current_player_info.active_player:
		ExperienceSystem.give_experience.emit(10)


func _on_weapon_list_item_clicked(index, at_position, mouse_button_index):
	var weapon_id = weapon_list.get_item_text(index)
	if CurrentRun.world.current_player_info.active_player:
		CurrentRun.world.current_player_info.active_player._instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon_id]["scene"], 0, 0, 0)
