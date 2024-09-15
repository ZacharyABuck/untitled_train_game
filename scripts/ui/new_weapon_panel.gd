extends PanelContainer

var weapon
var random_damage
var random_attack_delay
var random_projectile_speed

signal equip_new_weapon

func populate(random_weapon):
	weapon = random_weapon
	var base_damage = WeaponInfo.weapons_roster[random_weapon]["base_damage"]
	var base_attack_delay = WeaponInfo.weapons_roster[random_weapon]["base_attack_delay"]
	var base_projectile_speed = WeaponInfo.weapons_roster[random_weapon]["base_projectile_speed"]
	
	random_damage = randi_range(-2,3)
	random_attack_delay = randi_range(-.2,.3)
	random_projectile_speed = randi_range(-50,100)
	
	$VBoxContainer/NameLabel.text = "[center]" + WeaponInfo.weapons_roster[random_weapon]["name"] + "[/center]"
	$VBoxContainer/HBoxContainer/TextureRect.texture = WeaponInfo.weapons_roster[random_weapon]["sprite"]
	
	$VBoxContainer/HBoxContainer/VBoxContainer/Damage.text = \
		"[center]Damage: " + str(base_damage + random_damage) + "[/center]"
	$VBoxContainer/HBoxContainer/VBoxContainer/Cooldown.text = \
		"[center]Cooldown: " + str(base_attack_delay + random_attack_delay) + "[/center]"
	$VBoxContainer/HBoxContainer/VBoxContainer/BulletSpeed.text = \
		"[center]Bullet Speed: " + str((base_projectile_speed+random_projectile_speed)*.1) + "[/center]"


func _on_button_pressed():
	if !equip_new_weapon.is_connected(CurrentRun.world.current_level_info.active_level.equip_new_weapon):
		equip_new_weapon.connect(CurrentRun.world.current_level_info.active_level.equip_new_weapon)
	equip_new_weapon.emit(weapon, random_damage, random_attack_delay, random_projectile_speed)


func _on_button_mouse_entered():
	$HoverSFX.play()
