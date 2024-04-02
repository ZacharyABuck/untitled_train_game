extends RigidBody2D
class_name BulletComponent

@export var BULLET_HITBOX := Area2D
@export var ANIMATIONS := AnimatedSprite2D
@export var DAMAGE := 2

var bullet_area
var animations
var damage
# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_area = BULLET_HITBOX
	animations = ANIMATIONS
	damage = DAMAGE
	animations.play("travel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
