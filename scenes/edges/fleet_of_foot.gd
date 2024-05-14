extends Edge
var edge_name = "Fleet of Foot"
# 20% increased move speed
var move_speed_multiplier: float = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	update_player_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func handle_level_up():
	update_player_info()

func update_player_info():
	PlayerInfo.current_movespeed *= move_speed_multiplier
	print("Updated player attack delay modifier: ", PlayerInfo.current_movespeed)
