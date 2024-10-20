extends RigidBody2D
class_name Hazard

@export var grabbable: bool
var grabbed = false
var lasso_projectile
signal activate

func _physics_process(_delta):
	if grabbable and grabbed and lasso_projectile != null:
		global_position = lasso_projectile.grab_position.global_position

func hit_by_lasso():
	if grabbable:
		grabbed = true
	else:
		activate.emit()
