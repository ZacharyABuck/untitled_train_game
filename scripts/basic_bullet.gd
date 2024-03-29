extends RigidBody2D

@onready var area = $Area2D


var target
var type

var speed = 30

var damage = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(target)
	linear_velocity = global_position.direction_to(target) * speed
	match type:
		"friendly":
			area.set_collision_layer_value(5, true)
			area.set_collision_mask_value(4, true)
		"enemy":
			area.set_collision_layer_value(6, true)
			area.set_collision_mask_value(3, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
		move_and_collide(linear_velocity)


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		EnemyFunctions.take_damage(body, damage)
		#body.take_damage(damage)
		queue_free()
	if body.get_parent().is_in_group("car"):
		body.get_parent().take_damage(damage)
		queue_free()
