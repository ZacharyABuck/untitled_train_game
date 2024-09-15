extends Enemy

@onready var hurtbox = $HurtboxComponent/Hurtbox
@onready var collision = $CollisionShape2D
@onready var attack_component = $MeleeAttackComponent
@onready var wall_detector = $WallDetector

var active_car
var boarded = false

func _ready():
	find_stats("big zombie")
	
	if state != "idle":
		target = find_target()

func _physics_process(_delta):
	if target == null and state != "idle":
		target = find_target()

func find_target():
	var rng = CurrentRun.world.current_player_info.targets.pick_random()
	while rng.is_in_group("cargo"):
		rng = CurrentRun.world.current_player_info.targets.pick_random()
	return rng

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "dead":
		active_car = body.get_parent().index
		call_deferred("reparent", CurrentRun.world.current_train_info.cars_inventory[active_car]["node"])
		state = "boarding"
