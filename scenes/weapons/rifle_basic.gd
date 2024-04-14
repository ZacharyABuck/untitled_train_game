extends Ranged_Weapon

func _ready():
	base_attack_delay = 3.0
	base_projectile_speed = 60
	base_damage = 10
	base_lifetime = 3.0
	base_bullet = preload("res://scenes/projectiles/basic_bullet.tscn")
	
	_set_current_variables_and_connect_timer()
