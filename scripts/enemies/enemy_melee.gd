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
	
	if state != "idle":
		target = find_target()

func _physics_process(_delta):
	if target == null and state != "idle":
		target = find_target()

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "dead":
		if wave_enemy:
			if last_car == cars_reached:
				active_car = body.get_parent().index
				board()
		else:
			active_car = body.get_parent().index
			board()

func board():
	call_deferred("reparent", CurrentRun.world.current_train_info.cars_inventory[active_car]["node"])
	state = "boarding"
