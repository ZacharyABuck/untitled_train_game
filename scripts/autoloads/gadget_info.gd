extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_pistol_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 7,
	},
	"light_armor" = {
		"name" = "Light Armor",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_light_armor.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_barricade_single.png"),
		"cost" = 2,
	},
	"heavy_armor" = {
		"name" = "Heavy Armor",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_heavy_armor.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_heavy_cover_single.png"),
		"cost" = 4,
	},
	"medical_station" = {
		"name" = "Medical Station",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_medical_station.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_medical_station.png"),
		"cost" = 15,
	},
	"medical_station_long_range" = {
		"name" = "Longer Range",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_medical_station_long_range.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_medical_station.png"),
		"cost" = 20,
	},
	"medical_station_more_healing" = {
		"name" = "More Healing",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_medical_station_more_healing.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_medical_station.png"),
		"cost" = 20,
	},
	#"shockwire" = {
		#"name" = "Shockwire",
		#"location" = "car",
		#"scene" = load("res://scenes/gadgets/gadget_shockwire.tscn"),
		#"sprite" = load("res://sprites/gadgets/gadget_shockwire_icon.png"),
		#"cost" = 10,
	#},
	"shock_turret" = {
		"name" = "Shock Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_shock_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 10,
	},
	"rifle_turret" = {
		"name" = "Rifle Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 20,
	},
	"rifle_turret_quick_loading" = {
		"name" = "Quick Reload",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret_quick_loading.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 25,
	},
	"rifle_turret_more_damage" = {
		"name" = "More Damage",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret_more_damage.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 25,
	},
	"explosive_turret" = {
		"name" = "Explosive Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 20,
	},
	"explosive_turret_long_range" = {
		"name" = "Longer Range",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret_long_range.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 25,
	},
	"explosive_turret_more_damage" = {
		"name" = "More Damage",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret_more_damage.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 25,
	},
	"flame_turret" = {
		"name" = "Flame Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_flame_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 10,
	},
}

var upgrade_rosters = {
	default = ["pistol_turret", "light_armor", "medical_station", "flame_turret", "shock_turret"],
	pistol_turret = ["rifle_turret", "explosive_turret"],
	explosive_turret = ["explosive_turret_long_range", "explosive_turret_more_damage"],
	rifle_turret = ["rifle_turret_quick_loading", "rifle_turret_more_damage"],
	light_armor = ["heavy_armor"],
	medical_station = ["medical_station_long_range", "medical_station_more_healing"]
}
