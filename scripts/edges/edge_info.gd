extends Node

var edge_roster = {
	"fan_the_hammer" = {
		"name" = "[center]Fan the Hammer[/center]",
		"category" = "Gunslinger",
		"flavor" = "Shoot so fast your enemies won't know what hit em! Upgrade today for lightning fast rootin' tootin'",
		"description" = "[center]Shoot Speed +20%[/center]",
		"scene" = load("res://scenes/edges/fan_the_hammer.tscn"),
		"sprite" = load("res://sprites/edges/fan_the_hammer_icon.png"),
	},
	"fleet_of_foot" = {
		"name" = "[center]Fleet of Foot[/center]",
		"category" = "Survivalist",
		"flavor" = "The preferred upgrade for speed enthusiasts. Engineers and Conductors agree: if the Zombie can't catch you, it can't eat you!",
		"description" = "[center]Movement Speed +20%[/center]",
		"scene" = load("res://scenes/edges/fleet_of_foot.tscn"),
		"sprite" = load("res://sprites/edges/fleet_of_foot_icon.png"),
	}
}

var selection_active = false
var selected_edge = null

# enemy_spawner.gd <-- example of picking random stuff

# Edge data points
# name
# category -- Gunslinger, Survivalist, Tinkerer (for now; they won't do anything yet)
# description -- Just a colloquial description maybe?
# sprite -- icon
# packed scene (which contains all the code/effects)

# -- Player Stats --
# !! Move all Player Stats to player_info and make a base vs. current
# ranged_damage
# melee_damage
# max_hp (and update current HP) <-- Components
# attack speed <-- Timer
# projetile speed
# melee attack speed <-- not yet implemented
# move speed (player.speed) <-- move to PlayerInfo

# -- Turret Stats -- 
# targeting range? <-- figure out how to do this
# attack speed
# projectile speed
# damage
