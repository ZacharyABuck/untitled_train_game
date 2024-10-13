extends StaticBody2D

@onready var health_component = $HealthComponent
@onready var furnace_health_bar = $HealthBarControl/FurnaceHealthBar
@onready var health_bar_control = $HealthBarControl

signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentRun.world.current_train_info.furnace = self
	dead.connect(CurrentRun.root.show_restart_button)

func _process(_delta):
	health_bar_control.global_position = global_position
