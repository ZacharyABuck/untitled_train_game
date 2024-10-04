extends Enemy

@onready var hurtbox = $HurtboxComponent/Hurtbox
@onready var collision = $CollisionShape2D
@onready var attack_component = $MeleeAttackComponent
@onready var wall_detector = $WallDetector
@onready var explode_timer = $ExplodeTimer

var area_of_effect = preload("res://scenes/fx/area_of_effect_fx.tscn")

var active_car
var boarded = false

func _ready():
	find_stats("monstrosity")
	
	if state != "idle":
		target = find_target()

func _physics_process(_delta):
	if target == null and state != "idle":
		target = find_target()

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "dead":
		active_car = body.get_parent().index
		call_deferred("reparent", CurrentRun.world.current_train_info.cars_inventory[active_car]["node"])
		state = "boarding"
		explode_timer.start()

func _on_explode_timer_timeout():
	explode()

func explode():
	CurrentRun.world.current_level_info.active_level.enemy_killed()
	var new_aoe = area_of_effect.instantiate()
	new_aoe.global_position = global_position
	new_aoe.damage = damage
	CurrentRun.world.current_level_info.active_level.add_child(new_aoe)
	queue_free()
