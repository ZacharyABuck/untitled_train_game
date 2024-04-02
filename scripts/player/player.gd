extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var auto_fire_timer = $AutoFireTimer
@onready var health_bar = $HealthBar


var active_car

var basic_bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")

var can_shoot = true

const speed = 300

func _ready():
	PlayerInfo.active_player = self
	health_bar.max_value = PlayerInfo.max_health
	health_bar.value = PlayerInfo.max_health

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if get_global_mouse_position().x < global_position.x:
		sprite.scale.x = -.3
	else:
		sprite.scale.x = .3
	if velocity.is_equal_approx(Vector2.ZERO):
		sprite.play("standing")
	else:
		sprite.play("running")

func _process(delta):
	health_bar.value = PlayerInfo.health
	if health_bar.value == health_bar.max_value:
		health_bar.hide()
	else:
		health_bar.show()

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot") and can_shoot:
		shoot()
		auto_fire_timer.start()

func shoot():
	can_shoot = false
	if get_tree().paused == false:
		var new_bullet = basic_bullet.instantiate()
		new_bullet.global_position = global_position
		new_bullet.target = get_global_mouse_position()
		new_bullet.valid_hitbox_types = {"enemy":true, "player":false, "car":false, "terrain":false}
		get_parent().bullets.add_child(new_bullet)

func _on_auto_fire_timer_timeout():
	can_shoot = true
	if Input.is_action_pressed("shoot"):
		shoot()

func _on_car_detector_area_entered(area):
	if area.get_parent().is_in_group("car"):
		active_car = area.get_parent().index
		TrainInfo.cars_inventory[active_car]["node"].sprite.modulate = Color.WHITE

func _on_car_detector_area_exited(area):
	if area.get_parent().index == active_car:
		TrainInfo.cars_inventory[active_car]["node"].sprite.modulate = TrainInfo.cars_inventory[active_car]["node"].starting_color
