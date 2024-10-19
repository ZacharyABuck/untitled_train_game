extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"last_gadget" = null,
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_pistol_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 5.00,
		"unlocked" = true,
	},
	"scatter_shot_turret" = {
		"name" = "Scatter Shot Turret",
		"last_gadget" = null,
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_scatter_shot_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 7.00,
		"unlocked" = false,
	},
	"scatter_shot_turret_more_scatter" = {
		"name" = "More Scatter",
		"last_gadget" = "scatter_shot_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_scatter_shot_turret_more_scatter.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 10.00,
	},
	"scatter_shot_turret_poison_bullets" = {
		"name" = "Poison Bullets",
		"last_gadget" = "scatter_shot_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_scatter_shot_turret_poison_bullets.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 10.00,
	},
	"shock_turret" = {
		"name" = "Shock Turret",
		"last_gadget" = null,
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_shock_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 7.00,
		"unlocked" = false,
	},
	"shock_turret_quick_loading" = {
		"name" = "Quick Loading",
		"last_gadget" = "shock_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_shock_turret_quick_reload.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 10.00,
	},
	"rifle_turret" = {
		"name" = "Rifle Turret",
		"last_gadget" = "pistol_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 7.00,
	},
	"rifle_turret_quick_loading" = {
		"name" = "Quick Reload",
		"last_gadget" = "rifle_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret_quick_loading.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 10.00,
	},
	"rifle_turret_more_damage" = {
		"name" = "More Damage",
		"last_gadget" = "rifle_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret_more_damage.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 10.00,
	},
	"explosive_turret" = {
		"name" = "Explosive Turret",
		"last_gadget" = null,
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 7.00,
		"unlocked" = false,
	},
	"explosive_turret_long_range" = {
		"name" = "Longer Range",
		"last_gadget" = "explosive_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret_long_range.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 10.00,
	},
	"explosive_turret_more_damage" = {
		"name" = "More Damage",
		"last_gadget" = "explosive_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret_more_damage.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 10.00,
	},
	"flame_turret" = {
		"name" = "Flame Turret",
		"last_gadget" = null,
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_flame_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 7.00,
		"unlocked" = false,
	},
	"flame_turret_wide_area" = {
		"name" = "Wide Area",
		"last_gadget" = "flame_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_flame_turret_wide_area.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 10.00,
	},
	"gattling_turret" = {
		"name" = "Gattling Turret",
		"last_gadget" = null,
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_gattling_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 7.00,
		"unlocked" = false,
	},
	"gattling_turret_more_damage" = {
		"name" = "More Damage",
		"last_gadget" = "gattling_turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_gattling_turret_more_damage.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 10.00,
	},
}

func find_random_locked_gadget():
	var locked_gadgets = []
	for i in gadget_roster:
		if gadget_roster[i].has("unlocked") and gadget_roster[i]["unlocked"] == false:
			locked_gadgets.append(i)
	var random_gadget = locked_gadgets.pick_random()
	
	return random_gadget

