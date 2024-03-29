extends RigidBody2D

@onready var bullet_area = $Area2D


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
			bullet_area.set_collision_layer_value(5, true)
			bullet_area.set_collision_mask_value(4, true)
		"enemy":
			bullet_area.set_collision_layer_value(6, true)
			bullet_area.set_collision_mask_value(3, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
		move_and_collide(linear_velocity)

#If the bullet encounters a Hitbox, apply damage and destroy the bullet.
func _on_area_2d_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = damage
		hitbox.damage(attack)
		queue_free()
