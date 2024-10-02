extends Node2D

@onready var sprite = $Sprite2D
@onready var player_detector = $PlayerDetector


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
		
	await get_tree().create_timer(.5).timeout
	for area in player_detector.get_overlapping_areas():
		if area.get_parent().is_in_group("item"):
			area.get_parent().queue_free()

func _on_player_detector_body_entered(body):
	if body is Player:
		picked_up.emit(weapon, type)
		queue_free()
