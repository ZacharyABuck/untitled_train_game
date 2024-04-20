extends Edge
var edge_name = "fan_the_hammer"
#20% attack speed
var attack_speed_multiplier: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	update_player_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _calculate_attack_speed_multiplier():
	var final_multiplier = 1 - attack_speed_multiplier
	return final_multiplier

func handle_level_up():
	update_player_info()

func update_player_info():
	PlayerInfo.current_attack_delay_modifier  *= _calculate_attack_speed_multiplier()
	print("Updated player attack delay modifier: ", PlayerInfo.current_attack_delay_modifier)
