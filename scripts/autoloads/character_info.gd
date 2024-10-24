extends Node

var characters_roster = {
	"Timbo" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"Doniel" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"Piotr" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"Brawndo" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"Zick" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"Pattleson" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"Abe" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"B'ourdalain" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
	},
	"Franch" = {
		"icon" = preload("res://sprites/characters/bourdalain.png"),
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
					"cost" = 30.00,
				},
				"attack_delay" = {
					"name" = "Turrets Shoot Faster 10%",
					"value" = 0.1,
					"cost" = 30.00,
				},
			},
			"2" = {
				"damage" = {
					"name" = "Turret Damage Increase 30%",
					"value" = 0.3,
					"cost" = 50.00,
				},
				"ricochet" = {
					"name" = "Turret Bullets Bounce",
					"value" = 1,
					"cost" = 50.00,
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
				},
			},
			"1" = {
				"damage" = {
					"name" = "Turret Damage Increase 30%",
					"value" = 0.3,
					"cost" = 30.00,
				},
				"ricochet" = {
					"name" = "Turret Bullets Bounce",
					"value" = 1,
					"cost" = 40.00,
				},
			},
			"2" = {
				"scatter_shot" = {
					"name" = "Turret Scatter Shot Increase +1",
					"value" = 1,
					"cost" = 50.00,
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
					"value" = 1,
				},
			},
			"1" = {
				"poison" = {
					"name" = "Poison Damage Increase",
					"value" = 1,
					"cost" = 15.00,
				},
			},
			"2" = {
				"poison_cloud" = {
					"name" = "Poison Cloud",
					"value" = true,
					"cost" = 30.00,
				},
			},
		},
	},
	"pyrotech" = {
		"sprite" = preload("res://sprites/characters/bourdalain.png"),
		"ranks" = {
			"0" = {
				"fire" = {
					"name" = "Fire Bullets",
					"value" = 1,
				},
			},
			"1" = {
				"fire" = {
					"name" = "Fire Damage Increase",
					"value" = 1,
					"cost" = 15.00,
				},
			},
		},
	},
}

