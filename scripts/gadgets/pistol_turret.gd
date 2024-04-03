extends Node2D

@onready var attack_timer = $AttackTimer
@onready var enemy_detector = $EnemyDetector
@onready var sprite = $Sprite2D
var target
var basic_bullet = preload("res://scenes/projectiles/basic_bullet.tscn")

var gadget_stats = GadgetInfo.gadget_roster["pistol_turret"]
var damage = gadget_stats["damage"]
var attack_cooldown = gadget_stats["attack_cooldown"]

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_timer.wait_time = attack_cooldown
	attack_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if target != null:
		look_at(target.global_position)

func _on_enemy_detector_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		target = area.get_parent()
		attack()
#
#func _on_enemy_detector_body_entered(body):
	#if body.is_in_group("enemy"):
		#target = body
		#attack()

func _on_attack_timer_timeout():
	if target != null:
		attack()
	if target == null:
		for i in enemy_detector.get_overlapping_bodies():
			if i.is_in_group("enemy"):
				target = i
				attack()
				break

func attack():
	var new_bullet = basic_bullet.instantiate()
	new_bullet.global_position = global_position
	new_bullet.type = "friendly"
	new_bullet.target = target.global_position
	LevelInfo.active_level.bullets.call_deferred("add_child", new_bullet)



