extends Edge

var armor_amount: int = 3

func _ready():
	CurrentRun.world.current_train_info.furnace.health_component.ARMOR_VALUE += armor_amount
	print("Furnace Armor: " + str(CurrentRun.world.current_train_info.furnace.health_component.ARMOR_VALUE))
	
	super()

func handle_level_up():
	CurrentRun.world.current_train_info.furnace.health_component.ARMOR_VALUE += armor_amount
	print("Furnace Armor: " + str(CurrentRun.world.current_train_info.furnace.health_component.ARMOR_VALUE))
