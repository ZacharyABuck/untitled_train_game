extends VBoxContainer


var trainyard

func _ready():
	for i in get_children():
		if i is Button:
			i.pressed.connect(button_pressed.bind(i))

func button_pressed(button):
	var merc = button.get_meta("merc")
	var rank = button.get_meta("rank")
	var upgrade = button.get_meta("upgrade")
	
	var cost = CharacterInfo.mercs_roster[CurrentRun.world.current_character_info.mercs_inventory[merc]["type"]]["ranks"][rank][upgrade]["cost"]
	if CurrentRun.world.current_player_info.current_money >= cost:
		AudioSystem.play_audio("drill", -15)
		
		CurrentRun.world.current_player_info.current_money -= cost
		CurrentRun.world.update_money_label()
		
		CurrentRun.world.current_character_info.mercs_inventory[merc]["ranks"][rank] = \
			{upgrade : CharacterInfo.mercs_roster[CurrentRun.world.current_character_info.mercs_inventory[merc]["type"]]["ranks"][rank][upgrade]}
		
		trainyard.tech_tree_button_pressed(merc)
	else:
		button.button_pressed = false
