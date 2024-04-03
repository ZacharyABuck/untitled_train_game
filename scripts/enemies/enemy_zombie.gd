extends RigidBody2D

@onready var attack_timer = $AttackTimer
@onready var animations = $ZombieSpriteSheet
@onready var attack_area = $PlayerDetector
@onready var hurtbox = $HurtboxComponent/Hurtbox
@onready var collision = $CollisionShape2D

var enemy_stats = EnemyInfo.enemy_roster["zombie"]
var speed = enemy_stats["speed"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]

var target
var active_car
var state = "moving"
var boarded = false

func _ready():
	target = PlayerInfo.active_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	match state:
		"moving":
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
			look_at(target.global_position)
			animations.play("moving")
		"boarding":
			move_and_collide(global_position.direction_to(Vector2(target.global_position.x, global_position.y))*(speed*delta))
			animations.play("idle")
		"attacking":
			move_and_collide(global_position.direction_to(target.global_position)*(0*delta))
		"dead":
			hurtbox.disabled = true
			collision.disabled = true

func attack():
	animations.play("attacking")

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

func _on_zombie_sprite_sheet_animation_finished():
	if animations.animation == "attacking":
		if target == PlayerInfo.active_player:
			PlayerInfo.health -= damage
		if state == "attacking":
			attack()
	if animations.animation == "death":
		queue_free()

func _on_player_detector_body_exited(body):
	if body.is_in_group("player"):
		state = "moving"
