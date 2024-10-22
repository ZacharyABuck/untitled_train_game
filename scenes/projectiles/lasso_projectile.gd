extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var grab_position = $GrabPosition

var spin_speed: float = 1000
var initial_speed: float = 60000
var deceleration: float = 50
var speed: float
var final_speed: float = 40000
var target
var grabbed_hazard

var state = "windup"

func _ready():
	speed = initial_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == "windup":
		sprite.rotation_degrees += spin_speed*delta
	elif state == "release":
		sprite.rotation_degrees = 0
		velocity = global_position.direction_to(target)*(speed*delta)
		move_and_slide()
		if global_position.distance_to(target) <= 10 or grabbed_hazard != null:
			state = "return"
		speed = clamp(speed - deceleration, final_speed, initial_speed)
	elif state == "return":
		target = CurrentRun.world.current_player_info.active_player.global_position
		velocity = global_position.direction_to(target)*(speed*delta)
		move_and_slide()
		if global_position.distance_to(target) <= 10:
			state = "finished"
	elif state == "finished":
		queue_free()

func _on_grab_area_body_entered(body):
	if body is Hazard and grabbed_hazard == null:
		grabbed_hazard = body
		body.lasso_projectile = self
		body.hit_by_lasso()
