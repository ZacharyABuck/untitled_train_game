extends CharacterBody2D
class_name NPC

@export var wandering: bool = true
@export var speed: float = 2000.0
@export var sprite: AnimatedSprite2D
var target
var movement_rng_timer: Timer
var wander_wait_time: float = 4.0

func _ready():
	movement_rng_timer = Timer.new()
	add_child(movement_rng_timer)
	movement_rng_timer.wait_time = wander_wait_time
	movement_rng_timer.timeout.connect(movement_rng_timer_timeout)
	movement_rng_timer.start()

func _physics_process(delta):
	if wandering:
		if target != null:
			velocity = global_position.direction_to(target)*speed*delta
			sprite.look_at(target)
			move_and_slide()
			if global_position.distance_to(target) <= 5:
				target = null
	if velocity.is_equal_approx(Vector2.ZERO):
		if sprite.sprite_frames.animations.has("idle"):
			sprite.play("idle")
	elif sprite.sprite_frames.animations.has("running"):
		sprite.play("running")

func movement_rng_timer_timeout():
	var rng = randi_range(0,1)
	if rng == 1:
		target = Vector2(global_position.x+randf_range(-50,50), global_position.y+randf_range(-50,50))
