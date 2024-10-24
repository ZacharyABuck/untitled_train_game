extends Node2D
class_name Ranged_Weapon

@export var attack_delay_timer : Timer
@export var gunshot_sound : AudioStreamPlayer2D
@export var muzzle_flash: AnimatedSprite2D

@onready var player = CurrentRun.world.current_player_info.active_player

@export var weapon_id: String

# -- BASE WEAPON STATS -- #
var base_attack_delay: float
var base_projectile_speed: int
var base_damage: float
var base_lifetime: float
var can_shoot : bool = true
@export var base_bullet: PackedScene
var scatter_shot_amount: int = 0

# -- RANDOM MODS FROM DROPS -- #
var random_damage_mod: float = 0
var random_attack_delay_mod: float = 0
var random_projectile_speed_mod: int = 0

# -- CURRENT WEAPON STATS -- #
var current_attack_delay: float
var current_projectile_speed: int
var current_damage: float
var current_lifetime: float
var current_bullet

#these buffs go to player, who is the master of the buffs
var active_buffs: Dictionary

func _ready():
	if muzzle_flash:
		muzzle_flash.hide()
	base_attack_delay = WeaponInfo.weapons_roster[weapon_id]["base_attack_delay"]
	base_projectile_speed = WeaponInfo.weapons_roster[weapon_id]["base_projectile_speed"]
	base_damage = WeaponInfo.weapons_roster[weapon_id]["base_damage"]
	base_lifetime = WeaponInfo.weapons_roster[weapon_id]["base_lifetime"]
	_set_current_variables_and_connect_timer()

func _set_current_variables_and_connect_timer():
	current_attack_delay = (base_attack_delay + random_attack_delay_mod) * CurrentRun.world.current_player_info.current_attack_delay_modifier
	current_projectile_speed = base_projectile_speed + random_projectile_speed_mod
	current_damage = base_damage + random_damage_mod
	current_lifetime = base_lifetime
	current_bullet = base_bullet
	attack_delay_timer.wait_time = current_attack_delay
	attack_delay_timer.timeout.connect(_on_attack_timer_timeout)

func _process(_delta):
	if muzzle_flash and player:
		muzzle_flash.global_rotation = player.sprite.global_rotation

func shoot():
	if can_shoot:
		can_shoot = false
		if gunshot_sound:
			if weapon_id == "flamethrower":
				if !gunshot_sound.playing: gunshot_sound.play()
			else: gunshot_sound.play()
		player.camera.apply_shake(5.0)
		if muzzle_flash:
			show_muzzle_flash()
		
		var new_bullet = _build_bullet(current_bullet.instantiate())
		CurrentRun.world.current_level_info.active_level.bullets.add_child(new_bullet)
		
		WeaponInfo.attach_buffs(player.active_buffs, new_bullet.active_buffs)
		
		attack_delay_timer.wait_time = current_attack_delay
		attack_delay_timer.start()
		
		for shot in scatter_shot_amount:
			var scatter_shot = _build_bullet(current_bullet.instantiate())
			scatter_shot.target += Vector2(randi_range(-100,100), randi_range(-100,100))
			CurrentRun.world.current_level_info.active_level.bullets.add_child(scatter_shot)
		
		#handle running out of ammo
		if weapon_id != "melee" and weapon_id != "hatchet":
			CurrentRun.world.current_player_info.current_ranged_weapon_ammo_count -= 1
			CurrentRun.world.current_level_info.active_level.set_weapon_label(weapon_id, CurrentRun.world.current_player_info.current_ranged_weapon_ammo_count)
			if CurrentRun.world.current_player_info.current_ranged_weapon_ammo_count <= 0:
				CurrentRun.world.current_player_info.equip_new_weapon("melee", 0, 0, 0, 0)

func show_muzzle_flash():
	muzzle_flash.show()
	muzzle_flash.play("default")
	await muzzle_flash.animation_finished
	muzzle_flash.hide()

func _on_attack_timer_timeout():
	attack_delay_timer.stop()
	can_shoot = true
	if Input.is_action_pressed("shoot") and CurrentRun.world.current_player_info.state == "default":
		shoot()
	else:
		if gunshot_sound:
			gunshot_sound.stop()

func _build_bullet(b):
	b.global_position = CurrentRun.world.current_player_info.active_player.global_position
	b.speed = current_projectile_speed
	b.damage = current_damage
	b.valid_hitbox_types = {"enemy":true, "player":false, "car":false, "cover":false, "terrain":true}
	b.lifetime = current_lifetime
	b.shooter = player
	b.target = get_global_mouse_position()
	
	return b
