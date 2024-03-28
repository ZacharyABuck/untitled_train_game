extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var auto_fire_timer = $AutoFireTimer

var active_car

var basic_bullet = preload("res://scenes/basic_bullet.tscn")

const speed = 300

func _ready():
	PlayerInfo.active_player = self

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

func _physics_process(delta):
	get_input()
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
		auto_fire_timer.start()

func shoot():
	if get_tree().paused == false:
		var new_bullet = basic_bullet.instantiate()
		new_bullet.global_position = global_position
		new_bullet.type = "friendly"
		new_bullet.target = get_global_mouse_position()
		get_parent().bullets.add_child(new_bullet)


func _on_auto_fire_timer_timeout():
	if Input.is_action_pressed("shoot"):
		shoot()


func _on_car_detector_area_entered(area):
	if area.get_parent().is_in_group("car"):
		active_car = area.get_parent()
		active_car.sprite.modulate = Color.WHITE

func _on_car_detector_area_exited(area):
	if area.get_parent() == active_car:
		active_car.sprite.modulate = active_car.starting_color
