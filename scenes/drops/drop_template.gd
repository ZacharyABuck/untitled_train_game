extends RigidBody2D
class_name Drop

@export var value: float
var speed: int = 0
@export_enum("moving_to_player", "initial_force") var state: String

@export var sfx: AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_force()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == "moving_to_player":
		var target = CurrentRun.world.current_player_info.active_player
		move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
		speed += 25

func initial_force():
	var tween = get_tree().create_tween()
	var random_offset = Vector2(randf_range(-50,50), randf_range(-50,50))
	tween.tween_property(self, "global_position", global_position+random_offset, .1).set_ease(Tween.EASE_IN)
	state = "moving_to_player"

func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		$PlayerDetector.set_collision_mask_value(1, false)
		player_pickup_drop(value)
		$Sprite2D.hide()
		if sfx:
			sfx.play()
			await sfx.finished
			queue_free()
		else:
			queue_free()

func player_pickup_drop(_v):
	pass