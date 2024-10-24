extends RigidBody2D
class_name Hazard

@export var grabbable: bool
@export var target_types: Dictionary = {
	"enemy": false,
	"gadget": false,
	"furnace": false,
}
var grabbed = false
var lasso_projectile

#only used if target is missed, the hazard will move towards closest target
var speed: float = 0.0
var max_speed: float = 2000.0
var acceleration: float = 25.0

func _physics_process(_delta):
	if grabbable and grabbed and lasso_projectile != null:
		global_position = lasso_projectile.grab_position.global_position

func hit_by_lasso():
	if grabbable:
		grabbed = true
