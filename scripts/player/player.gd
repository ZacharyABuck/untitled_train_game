extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var auto_fire_timer = $AutoFireTimer
@onready var health_bar = $HealthBar
@onready var gunshot = $GunshotSound

var active_car
var bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")
var can_shoot = true
const speed = 300

func _ready():
	PlayerInfo.active_player = self

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
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

func _physics_process(_delta):
	global_rotation_degrees = 0
	sprite.look_at(get_global_mouse_position())
	get_input()
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot") and can_shoot:
		shoot()
		auto_fire_timer.start()

func shoot():
	can_shoot = false
	if get_tree().paused == false:
		gunshot.play()
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = global_position
		new_bullet.target = get_global_mouse_position()
		new_bullet.valid_hitbox_types = {"enemy":true, "player":false, "car":false, "cover":false,"terrain":false}
		LevelInfo.active_level.bullets.add_child(new_bullet)

func _on_auto_fire_timer_timeout():
	can_shoot = true
	if Input.is_action_pressed("shoot"):
		shoot()

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
