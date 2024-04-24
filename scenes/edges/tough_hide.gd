extends Edge
var edge_name = "Tough Hide"
# +1 flat ranged damage bonus
var armor_bonus: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	update_player_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_level_up():
	update_player_info()

func update_player_info():
	PlayerInfo.current_armor  += armor_bonus
	print("Updated player armor: ", PlayerInfo.current_armor)
