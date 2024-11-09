extends Node2D


var active_level
var root
var active_map
var track_cells = []
var map_positions = []

var enemy_spawn_system

var destination

var difficulty = 1.0
var wave_count: int = 1

var level_parameters = {
	"distance" = 4,
	"direction" = null,
	"terrain" = null,
}

var events = {
	"0" = {
		"distance" = 2,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	"1" = {
		"distance" = 3,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	#"2" = {
		#"distance" = 4,
		#"triggered" = false,
		#"type" = null,
		#"area" = null,
	#},
	#"3" = {
		#"distance" = 5,
		#"triggered" = false,
		#"type" = null,
		#"area" = null,
	#},
	#"4" = {
		#"distance" = 6,
		#"triggered" = false,
		#"type" = null,
		#"area" = null,
	#},
}

var attack_inventory = {
	#attack_id = {
		#shooter - from bullet
		#damage - base value from bullet
		#poison?
		#fire?
		#shock duration?
		#ricochet - base value from bullet
}

func create_attack_stats(initial_stats):
	var id = randi()
	attack_inventory[id] = initial_stats
	return id

func update_attack_stats(id, stats):
	if attack_inventory.has(id):
		for stat in stats.keys():
			if attack_inventory[id].has(stat):
				attack_inventory[id][stat] += stats[stat]
			else:
				attack_inventory[id][stat] = stats[stat]

func clear_variables():
	track_cells.clear()
	map_positions.clear()
	active_map = null


var money = preload("res://scenes/drops/money.tscn")
var spawned_gadget = preload("res://scenes/gadgets/spawned_gadget.tscn")

func calculate_random_drop(character):
	spawn_drop(spawned_gadget, character.global_position, character.money)

func spawn_drop(drop, pos, value):
	var new_drop = drop.instantiate()
	new_drop.value = value
	new_drop.global_position = pos
	active_level.call_deferred("add_child", new_drop)

#var poison_cloud = preload("res://scenes/projectiles/poison_cloud.tscn")
#signal bullet_hit
#func bullet_hit_target(hurtbox, shooter):
	#if shooter != null:
		#if shooter.active_buffs.has("poison_cloud"):
			#var new_cloud = poison_cloud.instantiate()
			#new_cloud.global_position = hurtbox.global_position
			#CurrentRun.world.current_level_info.active_level.bullets.call_deferred("add_child", new_cloud)
