extends StaticBody2D

@onready var health_component = $HealthComponent

signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentRun.world.current_train_info.furnace = self
	dead.connect(CurrentRun.root.show_restart_button)
