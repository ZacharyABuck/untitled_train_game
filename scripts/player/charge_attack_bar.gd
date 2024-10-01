extends ProgressBar

@onready var charge_ready_label = $ChargeReadyLabel
@onready var charge_ready_sfx = $ChargeReadySFX


func _process(delta):
	if value < max_value:
		value += CurrentRun.world.current_player_info.current_charge_recovery_rate*delta
		charge_ready_label.hide()
	elif !charge_ready_label.visible:
		charge_ready()
	
	#trigger tutorial
	if value >= max_value:
		CurrentRun.root.tutorial_ui.trigger_tutorial("charge_attack")

func charge_ready():
	charge_ready_label.show()
	charge_ready_sfx.play()
