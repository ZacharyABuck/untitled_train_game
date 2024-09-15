extends Ranged_Weapon

func _ready():
	base_attack_delay = 1.5
	base_projectile_speed = 1000
	base_damage = 5
	base_lifetime = 3.0
	base_bullet = preload("res://scenes/projectiles/rifle_bullet.tscn")
	weapon_id = "rifle"
	
	_set_current_variables_and_connect_timer()
