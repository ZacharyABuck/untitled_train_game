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

var default_poison_damage: float = 1.0
var default_fire_damage: float = 2.0

var character

#make sure enemy is parent of this
func _ready():
	character = get_parent()
	health_component = character.health_component

func check_status(buffs):
	if buffs.has("poison") and buffs["poison"] > 0:
		poison_tick_timer.disconnect("timeout", _on_poison_tick_timer_timeout)
		poison_tick_timer.timeout.connect(_on_poison_tick_timer_timeout.bind(buffs["poison"]))
		apply_poison()
	if buffs.has("fire") and buffs["fire"] > 0:
		fire_tick_timer.disconnect("timeout", _on_fire_tick_timer_timeout)
		fire_tick_timer.timeout.connect(_on_fire_tick_timer_timeout.bind(buffs["fire"]))
		apply_fire()
	if buffs.has("shock") and buffs["shock"] == true:
		apply_shock()

func apply_poison():
	is_poisoned = true
	if poison_tick_timer.is_stopped():
		poison_tick_timer.start()
	if poison_timer:
		poison_timer.start()

func _on_poison_tick_timer_timeout(damage):
	var poison_tick = Attack.new()
	
	if damage > 0:
		poison_tick.attack_damage = damage + CurrentRun.world.current_player_info.global_poison_damage
	else:
		poison_tick.attack_damage = default_poison_damage + CurrentRun.world.current_player_info.global_poison_damage
	health_component.damage(poison_tick, null)
	spawn_particles(poison_fx)
	
	if !is_poisoned:
		poison_tick_timer.stop()

func _on_poison_timer_timeout():
	is_poisoned = false

func apply_shock():
	is_shocked = true
	if shock_timer:
		shock_timer.start()
	spawn_particles(shock_fx)
	shock()

func shock():
	if is_shocked:
		character.shock_speed_multiplier = .75
	else:
		character.shock_speed_multiplier = 1

func _on_shock_timer_timeout():
	is_shocked = false
	shock()

func spawn_particles(fx):
	var new_fx = fx.instantiate()
	CurrentRun.world.current_level_info.active_level.add_child(new_fx)
	new_fx.global_position = character.global_position
	new_fx.emitting = true

func apply_fire():
	is_burning = true
	if fire_tick_timer.is_stopped():
		fire_tick_timer.start()
	fire_timer.start()

func _on_fire_timer_timeout():
	is_burning = false

func _on_fire_tick_timer_timeout(damage):
	var fire_tick = Attack.new()
	print(damage)
	print("global: " + str(CurrentRun.world.current_player_info.global_fire_damage))
	if damage > 0:
		fire_tick.attack_damage = damage + CurrentRun.world.current_player_info.global_fire_damage
	else:
		fire_tick.attack_damage = default_fire_damage + CurrentRun.world.current_player_info.global_fire_damage
	print("fire damage: " + str(fire_tick.attack_damage))
	health_component.damage(fire_tick, null)
	spawn_particles(fire_fx)
	
	if !is_burning:
		fire_tick_timer.stop()
