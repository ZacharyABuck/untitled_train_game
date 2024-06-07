extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_pistol_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 7,
	},
	"light_cover" = {
		"name" = "Light Cover",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_light_cover.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_barricade_single.png"),
		"cost" = 2,
	},
	"heavy_cover" = {
		"name" = "Heavy Cover",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_heavy_cover.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_heavy_cover_single.png"),
		"cost" = 4,
	},
	"medical_station" = {
		"name" = "Medical Station",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_medical_station.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_medical_station.png"),
		"cost" = 15,
		"heal_amount" = 1,
	},
	"shockwire" = {
		"name" = "Shockwire",
		"location" = "car",
		"scene" = load("res://scenes/gadgets/gadget_shockwire.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_shockwire_icon.png"),
		"cost" = 10,
	},
	"rifle_turret" = {
		"name" = "Rifle Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 20,
	},
	"explosive_turret" = {
		"name" = "Explosive Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 20,
	},
}

var default_roster = {
	"pistol_turret" = {},
	"light_cover" = {},
	"medical_station" = {},
	"shockwire" = {},
}

var turret_upgrade_roster = {
	"rifle_turret" = {},
	"explosive_turret" = {},
}

var light_cover_upgrade_roster = {
	"heavy_cover" = {},
}
