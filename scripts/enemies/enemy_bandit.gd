extends RigidBody2D


@onready var attack_timer = $AttackTimer

var basic_bullet = preload("res://scenes/basic_bullet.tscn")

var enemy_stats = EnemyInfo.enemy_roster["bandit"]
var speed = enemy_stats["speed"]
var health = enemy_stats["health"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]

var target
var state = "moving"

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_target = TrainInfo.cars_inventory.keys().pick_random()
	target = TrainInfo.cars_inventory[random_target]["node"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	if state == "moving":
		move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
		if global_position.distance_to(target.global_position) <= randi_range(300,400):
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


func _on_hitbox_component_area_entered(area):
	pass # Replace with function body.
