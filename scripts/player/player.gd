extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var auto_fire_timer = $AutoFireTimer
@onready var health_bar = $HealthBar
@onready var health_component = $HealthComponent
@onready var edge_handler = $EdgeHandler
@onready var running_sfx = $RunningSFX
@onready var repair_sfx = $RepairSFX



var active_car
var bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")
var can_shoot = true
var current_ranged_weapon
var base_gun_scene = "res://scenes/weapons/revolver_basic.tscn"
var repairing: bool = false
var repair_rate: float = 0.01

# -- BASE FUNCTIONS -- #
func _ready():
	PlayerInfo.active_player = self
	health_component.MAX_HEALTH = PlayerInfo.base_max_health
	health_component.ARMOR_VALUE = PlayerInfo.base_armor
	_instantiate_ranged_weapon(base_gun_scene)
	ExperienceSystem.level_up.connect(self.handle_level_up)

func _process(delta):
	if Input.is_action_pressed("repair"):
		repair()
	else:
		stop_repair()

func _physics_process(_delta):
	global_rotation_degrees = 0
	sprite.look_at(get_global_mouse_position())
	get_input()
	move_and_slide()


# -- INPUT FUNCTIONS -- #
func get_input():
	
	# -- DIRECTIONAL INPUT -- #
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * PlayerInfo.current_movespeed
	
	# -- MOVEMENT ANIMATIONS -- #
	if !repairing:
		if velocity.is_equal_approx(Vector2.ZERO):
			sprite.play("standing")
			running_sfx.stop()
		else:
			sprite.play("running")
			if !running_sfx.playing:
				running_sfx.play()

func _input(event):
	#mouse events when ui is closed
	if LevelInfo.active_level.ui_open == false and GadgetInfo.selected_gadget == null:
		if event.is_action_pressed("shoot") and !repairing:
			_shoot()
		elif event.is_action_pressed("strike") and !repairing:
			_strike()
		elif event.is_action_pressed("repair"):
			repair()
	#if ui is open
	elif event is InputEventMouseButton and event.pressed and \
	LevelInfo.active_level.ui_open == true and GadgetInfo.selected_gadget == null:
		LevelInfo.active_level.close_all_ui()

	if event.is_action_released("repair"):
		stop_repair()

# -- ATTACK FUNCTIONS -- #
func _shoot():
	current_ranged_weapon.shoot()

func _strike():
	# current_melee_weapon.strike()
	pass

# -- REPAIR -- #
func repair():
	if TrainInfo.cars_inventory[active_car]["node"].health < TrainInfo.cars_inventory[active_car]["node"].max_health:
		repairing = true
		TrainInfo.cars_inventory[active_car]["node"].repair(repair_rate)
		sprite.play("repairing")
		if !repair_sfx.playing:
			repair_sfx.play()

func stop_repair():
	repairing = false
	repair_sfx.stop()

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
	current_ranged_weapon.base_attack_delay = current_ranged_weapon.base_attack_delay * PlayerInfo.current_attack_delay_modifier

	add_child(current_ranged_weapon)

func refresh_current_ranged_weapon_stats():
	var damage = current_ranged_weapon.base_damage
	damage += PlayerInfo.current_ranged_damage_bonus
	damage *= PlayerInfo.current_ranged_damage_multiplier
	current_ranged_weapon.current_damage = damage
	current_ranged_weapon.current_attack_delay = current_ranged_weapon.base_attack_delay * PlayerInfo.current_attack_delay_modifier
	
	print("Current ranged weapon attack delay: ", current_ranged_weapon.current_attack_delay)


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


# -- EDGE AND LEVEL FUNCTIONS -- #

func handle_level_up():
	refresh_current_ranged_weapon_stats()
