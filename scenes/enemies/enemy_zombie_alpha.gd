extends RigidBody2D

@onready var animated_sprite = $Zombie_Animation
@onready var attack_timer = $Attacktimer

var enemy_stats = EnemyInfo.enemy_roster["zombie_alpha"]
var speed = enemy_stats["speed"]
var health = enemy_stats["health"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]


var target
var active_car
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
			animated_sprite.play("moving")
		"boarding":
			move_and_collide(global_position.direction_to(Vector2(target.global_position.x, global_position.y))*(speed*delta))
			attack_timer.stop()
			animated_sprite.play("moving")
		"attacking":
			animated_sprite.play("attacking")
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))

func _on_attack_timer_timeout():
	for i in $PlayerDetector.get_overlapping_bodies():
		if i.is_in_group("player"):
			state = "attacking"
			attack()
		else:
			state = "moving"

func attack():
	if target == PlayerInfo.active_player:
		PlayerInfo.health -= damage
		print(PlayerInfo.health)

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "boarding":
		active_car = body.get_parent().index
		state = "boarding"
		speed = speed - (speed * .75)

func _on_wall_detector_body_exited(body):
	if state == "boarding" and body.get_parent().is_in_group("car"):
		state = "moving"
		boarded = true
		speed = enemy_stats["speed"]

func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		target = body
		state = "attacking"
		attack()
		attack_timer.start()

func _on_player_detector_body_exited(body):
	if body.is_in_group("player"):
		state = "moving"
