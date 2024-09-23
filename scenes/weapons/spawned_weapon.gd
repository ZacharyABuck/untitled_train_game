extends Node2D

@onready var sprite = $Sprite2D

var type
var weapon
signal picked_up

func initialize(random_weapon, random_type):
	picked_up.connect(CurrentRun.world.current_level_info.active_level.weapon_picked_up)
	type = random_type
	weapon = random_weapon
	
	match type:
		"weapon":
			sprite.texture = WeaponInfo.weapons_roster[random_weapon]["sprite"]
		"charge_attack":
			sprite.texture = WeaponInfo.charge_attacks_roster[random_weapon]["sprite"]

func _on_player_detector_body_entered(body):
	if body is Player:
		picked_up.emit(weapon, type)
		queue_free()
