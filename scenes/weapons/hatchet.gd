extends Ranged_Weapon

func _ready():
	base_attack_delay = 1.0
	base_projectile_speed = 400
	base_damage = 4.0
	base_lifetime = 1.0
	base_bullet = preload("res://scenes/projectiles/hatchet_projectile.tscn")
	weapon_id = "hatchet"
	
	_set_current_variables_and_connect_timer()
