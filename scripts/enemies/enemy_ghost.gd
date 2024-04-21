extends RigidBody2D

var target

var money_stolen: bool = false

var start_pos: Vector2

var steal_amount: int = 3

var enemy_stats = EnemyInfo.enemy_roster["ghost"]
var speed = enemy_stats["speed"]
var money = enemy_stats["money"]
var experience = enemy_stats["experience"]
var state = "moving"

signal ghost_freed

# Called when the node enters the scene tree for the first time.
func _ready():
	var key = TrainInfo.cars_inventory.keys().pick_random()
	target = TrainInfo.cars_inventory[key]["node"]
	start_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if target != null and money_stolen == false and state == "moving":
		look_at(target.global_position)
		move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
		if global_position.distance_to(target.global_position) <= 5:
			money_stolen = true
			target = start_pos
			PlayerInfo.money -= steal_amount
	if target != null and money_stolen and state == "moving":
		look_at(target)
		move_and_collide(global_position.direction_to(target)*(speed*delta))
		if global_position.distance_to(target) <= 5:
			ghost_freed.emit()
			queue_free()

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		if money_stolen:
			PlayerInfo.money += steal_amount
		ghost_freed.emit()
		queue_free()
