extends CharacterBody2D

@export_enum("idle", "running") var state: String

var character_name
var speed: int = 50
var car
var target: Vector2
@onready var sprite = $AnimatedSprite2D
@onready var idle_timer = $IdleTimer
@onready var move_timer = $MoveTimer


func _ready():
	car = get_parent()
