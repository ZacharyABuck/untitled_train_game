extends Ranged_Weapon

func _ready():
	base_attack_delay = .7
	base_projectile_speed = 1000
	base_damage = 1.5
	base_lifetime = 3.0
	base_bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")
	
	_set_current_variables_and_connect_timer()
