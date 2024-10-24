extends Hazard

var heal_amount: float = 5

var target

func _physics_process(delta):
	super(delta)
	
	if target != null:
		linear_velocity = global_position.direction_to(target.global_position)
		speed = clamp(speed + acceleration, 0, max_speed)
		move_and_collide(linear_velocity * speed * delta)

func furnace_detector_body_entered(body):
	if body is Furnace:
		body.health_component.heal(heal_amount)
		queue_free()

func player_detector_body_entered(body):
	if body is Player:
		var furnace = CurrentRun.world.current_train_info.furnace
		target = furnace
