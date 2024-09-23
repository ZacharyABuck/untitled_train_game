extends Node2D

var balloon = preload("res://scenes/weapons/balloon.tscn")
var spawned_weapon = preload("res://scenes/weapons/spawned_weapon.tscn")

#spawn balloon
func _on_spawn_timer_timeout():
	var rng = CurrentRun.world.current_train_info.cars_inventory.keys().pick_random()
	var random_car = CurrentRun.world.current_train_info.cars_inventory[rng]["node"]
	var new_balloon = balloon.instantiate()
	
	new_balloon.global_position = Vector2(random_car.global_position.x, \
										random_car.global_position.y - 500)
	
	random_car.add_child(new_balloon)
	new_balloon.landed.connect(spawn_weapon)

func spawn_weapon(car):
	#random chance of weapon or charge attack
	var type = "weapon"
	var rng = randi_range(1,100)
	if rng >= 60:
		type = "charge_attack"
	
	var random_weapon
	if type == "charge_attack":
		random_weapon = WeaponInfo.charge_attacks_roster.keys().pick_random()
	else:
		random_weapon = WeaponInfo.weapons_roster.keys().pick_random()
	
	var new_weapon = spawned_weapon.instantiate()
	car.add_child(new_weapon)
	new_weapon.initialize(random_weapon, type)
