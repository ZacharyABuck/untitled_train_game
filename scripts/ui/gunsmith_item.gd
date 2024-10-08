extends PanelContainer

var weapon: String
@onready var icon = $HBoxContainer/Icon
@onready var name_label = $HBoxContainer/VBoxContainer2/ItemName
@onready var cost_label = $HBoxContainer/VBoxContainer2/Cost
@onready var stats_label = $HBoxContainer/VBoxContainer/Stats


var cost: int = 10

var damage_mod: float
var attack_delay_mod: float
var projectile_speed_mod: int

signal clicked

func populate(new_weapon):
	weapon = new_weapon
	
	var random_stats = CurrentRun.world.current_player_info.find_random_weapon_stats()
	damage_mod = random_stats[0]
	attack_delay_mod = random_stats[1]
	projectile_speed_mod = random_stats[2]
	
	stats_label.text = "[center] Damage: " + str(WeaponInfo.weapons_roster[weapon]["base_damage"] + damage_mod) + "[/center]" +\
	"[center] Cooldown: " + str(WeaponInfo.weapons_roster[weapon]["base_attack_delay"] + attack_delay_mod) + "[/center]" +\
	"[center] Bullet Speed: " + str(WeaponInfo.weapons_roster[weapon]["base_projectile_speed"] + projectile_speed_mod) + "[/center]"
	
	icon.texture = WeaponInfo.weapons_roster[weapon]["sprite"]
	name_label.text = "[center]" + WeaponInfo.weapons_roster[weapon]["name"]
	
	cost_label.text = "[center]Cost: " + str(cost + damage_mod) + " scrap[/center]"

func button_pressed():
	if CurrentRun.world.current_player_info.current_scrap >= cost:
		CurrentRun.world.current_player_info.current_scrap -= cost
		CurrentRun.world.update_money_label()
		clicked.emit("weapon", weapon, damage_mod, attack_delay_mod, projectile_speed_mod)
		queue_free()

