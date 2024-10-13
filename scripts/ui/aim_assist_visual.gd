extends Node2D

@onready var sprite = $Sprite2D
@onready var line = $Line2D


var target
var player

func _ready():
	player = CurrentRun.world.current_player_info.active_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_visual_component()
	handle_fade()
	
	if "state" in get_parent().get_parent() and get_parent().get_parent().state == "dead":
		hide()

func move_visual_component():
	var player_weapon = player.current_ranged_weapon
	target = get_parent().move_target(get_parent().get_parent(), player.global_position, \
	get_parent().get_parent().velocity, player_weapon.current_projectile_speed).global_position
	if target != null:
		sprite.global_position = target
		line.points[0] = get_parent().get_parent().global_position
		line.points[1] = target

func handle_fade():
	var minimum = 0.0
	var maximum = 1.0
	
	var mouse_pos = get_global_mouse_position()
	modulate.a =  clamp(maximum - sprite.global_position.distance_to(mouse_pos)*.005, minimum, maximum)
