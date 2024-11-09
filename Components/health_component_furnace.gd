extends HealthComponent

func _ready():
	super()
	if CurrentRun.world.current_train_info.current_furnace_health > 0:
		health = CurrentRun.world.current_train_info.current_furnace_health
		healthbar.value = health

func damage(attack : Attack):
	super(attack)
	CurrentRun.world.current_train_info.current_furnace_health = health

func heal(amount):
	super(amount)
	CurrentRun.world.current_train_info.current_furnace_health = health

func _handle_death():
	character.dead.emit()
