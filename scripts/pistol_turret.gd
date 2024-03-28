extends Node2D

@onready var attack_timer = $AttackTimer
@onready var enemy_detector = $EnemyDetector
@onready var sprite = $Sprite2D
var basic_bullet = preload("res://scenes/basic_bullet.tscn")

var damage = 2

var target

var attack_cooldown = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_timer.wait_time = attack_cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		look_at(target.global_position)


func _on_attack_timer_timeout():
	if target != null:
		attack()
	if target == null:
		for i in enemy_detector.get_overlapping_bodies():
			if i.is_in_group("enemy"):
				target = i
				attack()

func attack():
	var new_bullet = basic_bullet.instantiate()
	new_bullet.global_position = global_position
	new_bullet.type = "friendly"
	new_bullet.target = target.global_position
	LevelInfo.active_level.bullets.add_child(new_bullet)
