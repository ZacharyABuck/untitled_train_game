extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var auto_fire_timer = $AutoFireTimer
@onready var health_bar = $HealthBar
@onready var gunshot = $GunshotSound
@onready var health_component = $HealthComponent

var active_car
var bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")
var can_shoot = true
var current_ranged_weapon
var base_gun_scene = "res://scenes/weapons/revolver_basic.tscn"

# -- BASE FUNCTIONS -- #
func _ready():
	PlayerInfo.active_player = self
	health_component.MAX_HEALTH = PlayerInfo.base_max_health
	health_component.ARMOR_VALUE = PlayerInfo.base_armor
	_instantiate_ranged_weapon(base_gun_scene)
	
func _process(delta):
	pass

func _physics_process(_delta):
	global_rotation_degrees = 0
	sprite.look_at(get_global_mouse_position())
	get_input()
	move_and_slide()


# -- INPUT FUNCTIONS -- #
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * PlayerInfo.current_movespeed
	if get_global_mouse_position().x < global_position.x:
		#sprite.scale.x = -.7
		pass
	else:
		pass
		#sprite.scale.x = .7
	if velocity.is_equal_approx(Vector2.ZERO):
		sprite.play("standing")
	else:
		sprite.play("running")

func _input(event):
	if event.is_action_pressed("shoot"):
		_shoot()
	if event.is_action_pressed("strike"):
		_strike()


# -- ATTACK FUNCTIONS -- #
func _shoot():
	current_ranged_weapon.shoot()

func _strike():
	# current_melee_weapon.strike()
	print("Strike button pressed.")



# -- EQUIPMENT FUNCTIONS -- #
func _instantiate_ranged_weapon(gun_scene_location):
	# Clear the existing ranged weapon so we can load the new one.
	if is_instance_valid(current_ranged_weapon):
		current_ranged_weapon.queue_free()
	
	var gun_scene = load(gun_scene_location)
	current_ranged_weapon = gun_scene.instantiate()
	
	# Modify base weapon by flat bonus and multiplier of character.
	var damage = current_ranged_weapon.base_damage
	damage += PlayerInfo.current_ranged_damage_bonus
	damage *= PlayerInfo.current_ranged_damage_multiplier
	current_ranged_weapon.base_damage = damage
	add_child(current_ranged_weapon)


# -- MOVEMENT FUNCTIONS -- #
func _on_car_detector_area_entered(area):
	if area.get_parent().is_in_group("car"):
		active_car = area.get_parent().index
		TrainInfo.cars_inventory[active_car]["node"].sprite.modulate = Color.WHITE
		call_deferred("reparent", TrainInfo.cars_inventory[active_car]["node"])
		for i in TrainInfo.cars_inventory:
			if i != active_car:
				TrainInfo.cars_inventory[i]["node"].sprite.modulate = TrainInfo.cars_inventory[i]["node"].starting_color

func _on_car_detector_area_exited(area):
	if area.get_parent().is_in_group("car"):
		TrainInfo.cars_inventory[active_car]["node"].sprite.modulate = TrainInfo.cars_inventory[active_car]["node"].starting_color
