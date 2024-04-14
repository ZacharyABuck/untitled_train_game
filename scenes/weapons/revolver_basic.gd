extends Ranged_Weapon

func _ready():
	base_attack_delay = 1.0
	base_projectile_speed = 30
	base_damage = 2
	base_lifetime = 3.0
	base_bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")
	
	_set_current_variables_and_connect_timer()
