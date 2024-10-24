extends Hazard

@onready var sprite = $Sprite2D
@onready var player_detector = $PlayerDetector

var weapon
signal picked_up

func _ready():
	picked_up.connect(CurrentRun.world.current_level_info.active_level.weapon_picked_up)

	weapon = WeaponInfo.weapons_roster.keys().pick_random()
	while weapon == "melee" or weapon == "hatchet":
		weapon = WeaponInfo.weapons_roster.keys().pick_random()
	
	sprite.texture = WeaponInfo.weapons_roster[weapon]["sprite"]

func _on_player_detector_body_entered(body):
	if body is Player:
		picked_up.emit(weapon)
		AudioSystem.play_audio("reload", -10)
		queue_free()
