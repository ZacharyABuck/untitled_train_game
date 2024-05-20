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
var experience = enemy_stats["experience"]

var target
var active_car
@export_enum("moving", "boarding", "finish_boarding", "attacking", "idle", "dead") var state: String
var boarded = false

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
		elif state == "boarding" and active_car != null:
			var car = TrainInfo.cars_inventory[active_car]["node"]
			var pos = car.boarding_final_position.global_position
			animations.play("boarding")
		elif state == "finish_boarding":
			animations.play("finish_boarding")
		else:
			state = "moving"
			animations.play("moving")
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
			look_at(target.global_position)
	if state == "idle":
		animations.play("idle")
	if state == "dead":
		attack_timer.stop()
		hurtbox.disabled = true

#board train
func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "boarding":
		active_car = body.get_parent().index
		call_deferred("reparent", TrainInfo.cars_inventory[active_car]["node"])
		state = "boarding"

func finish_boarding():
	if state == "boarding":
		boarded = true
		state = "finish_boarding"
		var car = TrainInfo.cars_inventory[active_car]["node"]
		car.boarding_sfx.play()
		var point = car.boarding_points.get_child(0)
		for i in car.boarding_points.get_children():
			if position.distance_to(i.position) < position.distance_to(point.position):
				point = i
		look_at(point.global_position)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", point.position, .6)

func _on_zombie_sprite_sheet_animation_finished():
	if animations.animation == "death":
		print("death animation finished")
		queue_free()
	if animations.animation == "boarding":
		print("boarding animation finished")
		TrainInfo.cars_inventory[active_car]["node"].take_damage(damage)
		if TrainInfo.cars_inventory[active_car]["node"].health <= 0:
			finish_boarding()
		else:
			animations.play("boarding")
	if animations.animation == "finish_boarding":
		state = "moving"
		speed = enemy_stats["speed"]
		set_collision_mask_value(3, true)
