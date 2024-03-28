extends RigidBody2D

@onready var attack_timer = $AttackTimer


var basic_bullet = preload("res://scenes/basic_bullet.tscn")

var speed = 500

var health = 5
var money = 2

var target
var state = "moving"

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_target = TrainInfo.cars_inventory.keys().pick_random()
	target = TrainInfo.cars_inventory[random_target]["node"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity = global_position.direction_to(target.global_position) * (speed*delta)

func _physics_process(delta):
	if state == "moving":
		move_and_collide(linear_velocity)
		if global_position.distance_to(target.global_position) <= randi_range(300,400):
			linear_velocity = Vector2.ZERO
			state = "attacking"
			attack_timer.start()


func _on_attack_timer_timeout():
	if state == "attacking":
		attack()

func attack():
	var new_bullet = basic_bullet.instantiate()
	new_bullet.global_position = global_position
	new_bullet.type = "enemy"
	new_bullet.target = target.global_position
	get_parent().add_child(new_bullet)

func take_damage(amount):
	health -= amount
	if health <= 0:
		PlayerInfo.money += money
		queue_free()
