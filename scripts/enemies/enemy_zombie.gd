extends RigidBody2D

@onready var attack_timer = $AttackTimer
@onready var animations = $ZombieSpriteSheet
@onready var hurtbox = $HurtboxComponent/Hurtbox
@onready var collision = $CollisionShape2D
@onready var attack_component = $MeleeAttackComponent

var enemy_stats = EnemyInfo.enemy_roster["zombie"]
var speed = enemy_stats["speed"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]

var target
var active_car
#var state = "moving"
@export_enum("moving", "boarding", "attacking", "idle", "dead") var state: String
var boarded = false
var boarding_time = 5

func _ready():
	if state != "idle":
		target = PlayerInfo.active_player

func _process(_delta):
	pass

func _physics_process(delta):
	if state != "dead" and state != "idle":
		if attack_component.target_is_in_range(target) and boarded:
			state = "attacking"
			attack_component.attack_if_target_in_range(target)
		elif state == "boarding":
			move_and_collide(global_position.direction_to(Vector2(target.global_position.x, global_position.y))*(speed*delta))
			animations.play("idle")
		else:
			state = "moving"
			animations.play("moving")
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
			look_at(target.global_position)
	if state == "idle":
		animations.play("idle")

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "boarding":
		active_car = body.get_parent().index
		call_deferred("reparent", TrainInfo.cars_inventory[active_car]["node"])
		state = "boarding"
		speed = 0
		#speed = speed - (speed * .75)
		await get_tree().create_timer(boarding_time).timeout
		finish_boarding()

func finish_boarding():
	if state == "boarding":
		state = "moving"
		boarded = true
		speed = enemy_stats["speed"]
#
#func _on_wall_detector_body_exited(body):
	#if state == "boarding" and body.get_parent().is_in_group("car"):
		#state = "moving"
		#boarded = true
		#speed = enemy_stats["speed"]

func _on_zombie_sprite_sheet_animation_finished():
	if animations.animation == "death":
		queue_free()
