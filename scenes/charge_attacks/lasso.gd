extends Node2D

@export var projectile: PackedScene

var active_projectile
@onready var rope = $Rope
@onready var rope_path = $RopePath
@onready var rope_sprites = $RopeSprites
@onready var lasso_spinning_sound = $LassoSpinningSound
@onready var lasso_release_sound = $LassoReleaseSound

var rope_texture = preload("res://sprites/projectiles/rope_segment.png")

func windup():
	var new_projectile = projectile.instantiate()
	add_child(new_projectile)
	active_projectile = new_projectile
	lasso_spinning_sound.play()

func release():
	if active_projectile != null:
		lasso_spinning_sound.stop()
		lasso_release_sound.play()
		active_projectile.target = get_global_mouse_position()
		active_projectile.state = "release"

func _physics_process(_delta):
	if active_projectile != null:
		rope_path.curve.set_point_position(1, active_projectile.position)
		rope_path.curve.set_point_in(1, active_projectile.position.direction_to(global_position)*-50)
	else:
		rope_path.curve.set_point_position(1, Vector2.ZERO)
	
	for s in rope_sprites.get_children():
		s.queue_free()
	
	var baked_points = rope_path.curve.get_baked_points()
	var last_point
	for point in baked_points:
		var s = Sprite2D.new()
		s.texture = rope_texture
		if last_point != null:
			s.rotation = point.angle_to_point(last_point)
			s.rotation_degrees += 90
		s.position = point
		last_point = point
		rope_sprites.add_child(s)
