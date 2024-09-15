extends Node2D

@onready var sprite = $Sprite2D

var weapon
signal picked_up

func initialize(random_weapon):
	picked_up.connect(CurrentRun.world.current_level_info.active_level.weapon_picked_up)
	sprite.texture = WeaponInfo.weapons_roster[random_weapon]["sprite"]
	weapon = random_weapon


func _on_player_detector_body_entered(body):
	if body is Player:
		picked_up.emit(weapon)
		queue_free()
