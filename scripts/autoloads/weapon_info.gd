extends Node

var weapons_roster = {
	"revolver" = {
		"name" = "Revolver",
		"scene" = load("res://scenes/weapons/revolver_basic.tscn"),
		"sprite" = preload("res://sprites/weapons/revolver.png"),
		"base_attack_delay" = .7,
		"base_projectile_speed" = 1000,
		"base_damage" = 2,
		"base_lifetime" = 3.0,
	},
	
	"rifle" = {
		"name" = "Rifle",
		"scene" = load("res://scenes/weapons/rifle_basic.tscn"),
		"sprite" = preload("res://sprites/weapons/rifle.png"),
		"base_attack_delay" = 1.5,
		"base_projectile_speed" = 1000,
		"base_damage" = 5,
		"base_lifetime" = 3.0,
	},
	
	"hatchet" = {
		"name" = "Hatchet",
		"scene" = load("res://scenes/weapons/hatchet.tscn"),
		"sprite" = preload("res://sprites/weapons/hatchet.png"),
		"base_attack_delay" = 1.0,
		"base_projectile_speed" = 400,
		"base_damage" = 4.0,
		"base_lifetime" = 1.0,
	},

	"mondragon" = {
		"name" = "Mondragón",
		"scene" = load("res://scenes/weapons/mondragon.tscn"),
		"sprite" = preload("res://sprites/weapons/mondragon.png"),
		"base_attack_delay" = .3,
		"base_projectile_speed" = 1000,
		"base_damage" = 1.0,
		"base_lifetime" = 2.0,
	},

	"shotgun" = {
		"name" = "Shotgun",
		"scene" = load("res://scenes/weapons/shotgun_basic.tscn"),
		"sprite" = preload("res://sprites/weapons/shotgun.png"),
		"base_attack_delay" = 1.5,
		"base_projectile_speed" = 600,
		"base_damage" = 1.0,
		"base_lifetime" = 1.0,
	},
	"flamethrower" = {
		"name" = "Flamethrower",
		"scene" = load("res://scenes/weapons/flamethrower.tscn"),
		"sprite" = preload("res://sprites/weapons/flamethrower.png"),
		"base_attack_delay" = 0.8,
		"base_projectile_speed" = 0,
		"base_damage" = 1.0,
		"base_lifetime" = .5,
	},
}

var charge_attacks_roster = {
	"explosive" = {
		"name" = "Explosive Attack",
		"scene" = preload("res://scenes/charge_attacks/charge_attack_explosive.tscn"),
		"sprite" = preload("res://sprites/weapons/bazooka.png"),
		"base_damage" = 10,
	},
	"poison_explosive" = {
		"name" = "Poison Bomb",
		"scene" = preload("res://scenes/charge_attacks/charge_attack_poison_explosive.tscn"),
		"sprite" = preload("res://sprites/weapons/poison_bomb.png"),
		"base_damage" = 8,
	},
	"zombie_bait" = {
		"name" = "Poison Bait",
		"scene" = preload("res://scenes/charge_attacks/charge_attack_zombie_bait.tscn"),
		"sprite" = preload("res://sprites/projectiles/meat.png"),
		"base_damage" = 0,
	},
}

func attach_buffs(buffs, receiver_buffs):
	for buff in buffs:
		#if value is a float
		if buff == "damage" or buff == "attack_delay" or buff == "scatter_shot":
			if receiver_buffs.has(buff):
				receiver_buffs[buff] += buffs[buff]
			else: receiver_buffs[buff] = buffs[buff]
		#if value is a bool
		else:
			receiver_buffs[buff] = true

func detach_buffs(buffs, receiver_buffs):
	for buff in buffs:
		#if value is a float
		if buff == "damage" or buff == "attack_delay" or buff == "scatter_shot":
			if receiver_buffs.has(buff):
				receiver_buffs[buff] -= max(buffs[buff], 0)
		#if value is a bool
		else:
			receiver_buffs[buff] = false
