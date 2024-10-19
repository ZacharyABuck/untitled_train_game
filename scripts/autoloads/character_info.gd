extends Node

var characters_roster = {
	"Timbo" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"Doniel" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"Piotr" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"Brawndo" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"Zick" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"Pattleson" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"Abe" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"B'ourdalain" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
	"Franch" = {
		"icon" = preload("res://sprites/characters/Franch Token.png"),
	},
}

var mercs_roster = {
	"bulletsmith" = {
		"sprite" = preload("res://sprites/characters/bourdalain.png"),
		"ranks" = {
			"0" = {
				"damage" = {
					"name" = "Turret Damage Increase 20%",
					"value" = 1.2,
				},
			},
			"1" = {
				"damage" = {
					"name" = "Turret Damage Increase 20%",
					"value" = 0.2,
					"cost" = 15.00,
				},
				"attack_delay" = {
					"name" = "Turrets Shoot Faster 10%",
					"value" = 0.1,
					"cost" = 15.00,
				},
			},
			"2" = {
				"damage" = {
					"name" = "Turret Damage Increase 30%",
					"value" = 0.3,
					"cost" = 20.00,
				},
				"ricochet" = {
					"name" = "Turret Bullets Bounce",
					"value" = 1,
					"cost" = 20.00,
				},
			},
		},
	},
	"manufacturer" = {
		"sprite" = preload("res://sprites/characters/bourdalain.png"),
		"ranks" = {
			"0" = {
				"scatter_shot" = {
					"name" = "Turret Scatter Shot Increase +1",
					"value" = 1,
					"cost" = 15.00,
				},
			},
			"1" = {
				"damage" = {
					"name" = "Turret Damage Increase 30%",
					"value" = 0.3,
					"cost" = 15.00,
				},
				"ricochet" = {
					"name" = "Turret Bullets Bounce",
					"value" = 1,
					"cost" = 20.00,
				},
			},
			"2" = {
				"scatter_shot" = {
					"name" = "Turret Scatter Shot Increase +1",
					"value" = 1,
					"cost" = 20.00,
				},
			},
		},
	},
	"toxicologist" = {
		"sprite" = preload("res://sprites/characters/bourdalain.png"),
		"ranks" = {
			"0" = {
				"poison" = {
					"name" = "Poison Bullets",
					"value" = true,
				},
			},
			"1" = {
				"poison_cloud" = {
					"name" = "Poison Cloud",
					"value" = true,
					"cost" = 15.00,
				},
			},
		},
	},
}

