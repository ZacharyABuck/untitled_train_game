extends RigidBody2D

@onready var attack_timer = $AttackTimer
@onready var animations = $ZombieSpriteSheet
@onready var hurtbox = $HurtboxComponent/Hurtbox
@onready var collision = $CollisionShape2D
@onready var attack_component = $MeleeAttackComponent
@onready var wall_detector = $WallDetector

var enemy_stats = EnemyInfo.enemy_roster["zombie"]
var speed = enemy_stats["speed"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]
var experience = enemy_stats["experience"]

var target
var active_car
@export_enum("moving", "boarding", "finish_boarding", "attacking", "idle", "dead") var state: String
var boarded = false

func _ready():
	if state != "idle":
		target = PlayerInfo.active_player

func _on_wall_detector_body_entered(body):
	if body.get_parent().is_in_group("car") and boarded == false and state != "dead":
		active_car = body.get_parent().index
		call_deferred("reparent", TrainInfo.cars_inventory[active_car]["node"])
		state = "boarding"
