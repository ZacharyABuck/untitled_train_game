extends Enemy
class_name MeleeEnemy

@export var wall_detector: Area2D
@export var hurtbox: CollisionShape2D
@export var attack_component: MeleeAttackComponent

var active_car
var boarded = false

func _ready():
	super()
	
	if wall_detector:
		wall_detector.body_entered.connect(_on_wall_detector_body_entered)
	
func _process(delta):
	super(delta)
	if wave_enemy:
		if target == null:
			if last_car + 1 == cars_reached:
				target = CurrentRun.world.current_train_info.furnace
			else:
				target = find_next_nav_point()
	elif target == null:
		target = find_random_target()

func _physics_process(delta):
	if target != null and not target is PhysicsBody2D and global_position.distance_to(target.global_position) < 50:
		target = null
		cars_reached += 1

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "dead":
		active_car = body.get_parent().index
		board()

func board():
	call_deferred("reparent", CurrentRun.world.current_train_info.cars_inventory[active_car]["node"])
	state = "boarding"
