extends Node2D

var health_component

@onready var shock_timer = $ShockTimer
@onready var poison_tick_timer = $PoisonTickTimer
@onready var poison_timer = $PoisonTimer
@onready var fire_timer = $FireTimer
@onready var fire_tick_timer = $FireTickTimer

var is_poisoned: bool = false
var is_shocked: bool = false
var is_burning: bool = false

var poison_fx = preload("res://scenes/fx/poison_fx.tscn")
var shock_fx = preload("res://scenes/fx/shock_fx.tscn")
var fire_fx = preload("res://scenes/fx/fire_fx.tscn")

var character

#make sure enemy is parent of this
func _ready():
	character = get_parent()

func apply_poison():
	is_poisoned = true
	if poison_tick_timer.is_stopped():
		poison_tick_timer.start()
	if poison_timer:
		poison_timer.start()

func apply_shock():
	is_shocked = true
	shock_timer.start()
	spawn_particles(shock_fx)
	shock()

func apply_fire():
	is_burning = true
	if fire_tick_timer.is_stopped():
		fire_tick_timer.start()
	fire_timer.start()

func shock():
	if is_shocked:
		character.speed = character.enemy_stats["speed"] * .5
	else:
		character.speed = character.enemy_stats["speed"]
		if character.elite:
			character.speed += EnemyInfo.elite_modifiers["speed"]

func _on_shock_timer_timeout():
	is_shocked = false
	shock()

func spawn_particles(fx):
	var new_fx = fx.instantiate()
	CurrentRun.world.current_level_info.active_level.add_child(new_fx)
	new_fx.global_position = character.global_position
	new_fx.emitting = true

func _on_poison_tick_timer_timeout():
	var poison_damage = CurrentRun.world.current_player_info.poison_damage
	var poison_tick = Attack.new()
	poison_tick.attack_damage = poison_damage
	health_component.damage(poison_tick, null)
	spawn_particles(poison_fx)
	
	if !is_poisoned:
		poison_tick_timer.stop()

func _on_poison_timer_timeout():
	is_poisoned = false

func _on_fire_timer_timeout():
	is_burning = false

func _on_fire_tick_timer_timeout():
	var fire_damage = CurrentRun.world.current_player_info.fire_damage
	var fire_tick = Attack.new()
	fire_tick.attack_damage = fire_damage
	health_component.damage(fire_tick, null)
	spawn_particles(fire_fx)
	
	if !is_burning:
		fire_tick_timer.stop()
