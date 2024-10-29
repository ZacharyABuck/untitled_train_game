extends Edge

var increase_amount: float = 10
var furnace

func _ready():
	furnace = CurrentRun.world.current_train_info.furnace
	
	handle_level_up()

func handle_level_up():
	furnace.health_component.MAX_HEALTH += increase_amount
	furnace.health_component.healthbar.max_value = furnace.health_component.MAX_HEALTH

