extends Ranged_Weapon

func _ready():
	base_attack_delay = .3
	base_projectile_speed = 1000
	base_damage = 1.5
	base_lifetime = 2.0
	base_bullet = preload("res://scenes/projectiles/rifle_bullet.tscn")
	weapon_id = "mondragon"
	
	_set_current_variables_and_connect_timer()
