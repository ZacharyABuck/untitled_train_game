extends RigidBody2D

@onready var attack_timer = $AttackTimer

var enemy_stats = EnemyInfo.enemy_roster["zombie"]
var speed = enemy_stats["speed"]
var health = enemy_stats["health"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]

var target
var state = "moving"
var boarded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	target = PlayerInfo.active_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	match state:
		"moving":
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
			attack_timer.stop()
		"boarding":
			move_and_collide(global_position.direction_to(Vector2(target.global_position.x, global_position.y))*(speed*delta))
			attack_timer.stop()
		"attacking":
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))

func _on_attack_timer_timeout():
	for i in $PlayerDetector.get_overlapping_bodies():
		if i.is_in_group("player"):
			state = "attacking"
			attack()
		else:
			state = "moving"

func attack():
	PlayerInfo.health -= damage
	print(PlayerInfo.health)

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "boarding":
		state = "boarding"
		speed = speed - (speed * .75)

func _on_wall_detector_body_exited(body):
	if state == "boarding" and body.get_parent().is_in_group("car"):
		state = "moving"
		boarded = true
		sleeping = true
		speed = enemy_stats["speed"]

func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		state = "attacking"
		attack()
		attack_timer.start()

func _on_player_detector_body_exited(body):
	if body.is_in_group("player"):
		state = "moving"