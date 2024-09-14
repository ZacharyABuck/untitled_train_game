extends RigidBody2D

@onready var attack_timer = $AttackTimer
@onready var animations = $ZombieSpriteSheet
@onready var hurtbox = $HurtboxComponent/Hurtbox
@onready var collision = $CollisionShape2D
@onready var attack_component = $MeleeAttackComponent
@onready var wall_detector = $WallDetector
@onready var health_component = $HealthComponent

var elite: bool = false
var enemy_stats = EnemyInfo.enemy_roster["zombie"]
var speed = enemy_stats["speed"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]
var experience = enemy_stats["experience"]

var target
var active_car
@export_enum("moving", "boarding", "finish_boarding", "attacking", "idle", "dead") var state: String
var boarded = false

var shocked: bool = false
@onready var shock_indicator = $ShockIndicator


func _ready():
	if state != "idle":
		target = find_target()
	if elite:
		upgrade()

func upgrade():
	animations.modulate = Color.RED
	speed += EnemyInfo.elite_modifiers["speed"]
	damage += EnemyInfo.elite_modifiers["damage"]
	health_component.health += EnemyInfo.elite_modifiers["health"]

func _physics_process(_delta):
	if target == null and state != "idle":
		target = find_target()
	check_shock()

func check_shock():
	if shocked:
		shock_indicator.show()
	else:
		shock_indicator.hide()

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
