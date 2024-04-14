extends Node

var edge_roster = {
	"fan_the_hammer" = {
		"name" = "Fan the Hammer",
		"category" = "Gunslinger",
		"description" = "Increase ranged attack speed by +X%",
		"scene" = load("XXXX"),
		"sprite" = load("XXXX"),
	},
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
