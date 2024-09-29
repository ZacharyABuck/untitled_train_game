extends PanelContainer

signal keep_current_weapon

func populate():
	var current_weapon = CurrentRun.world.current_player_info.active_player.current_ranged_weapon
	var weapon_id = CurrentRun.world.current_player_info.active_player.current_ranged_weapon.weapon_id
	
	$"../CurrentWeapon".text = "[center]Current Weapon[/center]"
	$VBoxContainer/NameLabel.text = "[center]" + str(WeaponInfo.weapons_roster[weapon_id]["name"]) + "[/center]"
	$VBoxContainer/HBoxContainer/TextureRect.texture = WeaponInfo.weapons_roster[weapon_id]["sprite"]
	
	$VBoxContainer/HBoxContainer/VBoxContainer/Damage.text = \
		"[center]Damage: " + str(current_weapon.current_damage) + "[/center]"
	$VBoxContainer/HBoxContainer/VBoxContainer/Cooldown.text = \
		"[center]Cooldown: " + str(current_weapon.current_attack_delay) + "[/center]"
	$VBoxContainer/HBoxContainer/VBoxContainer/BulletSpeed.text = \
		"[center]Bullet Speed: " + str(current_weapon.current_projectile_speed*.1) + "[/center]"

func populate_charge_attack():
	var current_charge_attack = CurrentRun.world.current_player_info.active_player.current_charge_attack
	var charge_attack_id = CurrentRun.world.current_player_info.current_charge_attack_reference
	
	$"../CurrentWeapon".text = "[center]Current Special[/center]"
	$VBoxContainer/NameLabel.text = "[center]" + str(WeaponInfo.charge_attacks_roster[charge_attack_id]["name"]) + "[/center]"
	$VBoxContainer/HBoxContainer/TextureRect.texture = WeaponInfo.charge_attacks_roster[charge_attack_id]["sprite"]
	
	$VBoxContainer/HBoxContainer/VBoxContainer/Damage.text = \
		"[center]Damage: " + str(current_charge_attack.damage) + "[/center]"
	$VBoxContainer/HBoxContainer/VBoxContainer/Cooldown.text = ""
	$VBoxContainer/HBoxContainer/VBoxContainer/BulletSpeed.text = ""

func _on_button_pressed():
	if !keep_current_weapon.is_connected(CurrentRun.world.current_level_info.active_level.keep_current_weapon):
		keep_current_weapon.connect(CurrentRun.world.current_level_info.active_level.keep_current_weapon)
	keep_current_weapon.emit()


func _on_button_mouse_entered():
	$HoverSFX.play()
