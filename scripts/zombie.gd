extends RigidBody2D

@onready var attack_timer = $AttackTimer

var speed = 400

var health = 3
var damage = 1
var money = 2

var target
var state = "moving"

var boarded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	target = PlayerInfo.active_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		"moving":
			linear_velocity = global_position.direction_to(target.global_position) * (speed*delta)
			attack_timer.stop()
		"boarding":
			linear_velocity = global_position.direction_to(Vector2(target.global_position.x, global_position.y)) * (speed*delta)

func _physics_process(delta):
	if state == "moving" or "boarding":
		move_and_collide(linear_velocity)


func _on_attack_timer_timeout():
	for i in $PlayerDetector.get_overlapping_bodies():
		if i.is_in_group("player"):
			state = "attacking"
		else:
			state = "moving"
	if state == "attacking":
		attack()

func attack():
	PlayerInfo.health -= damage
	print(PlayerInfo.health)

func take_damage(amount):
	health -= amount
	if health <= 0:
		PlayerInfo.money += money
		queue_free()


func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false:
		state = "boarding"
		speed = 50

func _on_wall_detector_body_exited(body):
	if state == "boarding" and body.get_parent().is_in_group("car"):
		state = "moving"
		boarded = true
		speed = 400

func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		state = "attacking"
		attack_timer.start()


func _on_player_detector_body_exited(body):
	if body.is_in_group("player"):
		state = "moving"
