extends Node2D

var hard_point
var car



# Called when the node enters the scene tree for the first time.
func _ready():
	hard_point = get_parent()
	car = hard_point.car


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CurrentRun.world.current_player_info.active_player != null:
		if car.index == CurrentRun.world.current_player_info.active_player.active_car and \
		CurrentRun.world.current_player_info.active_player.health_component.health < CurrentRun.world.current_player_info.active_player.health_component.MAX_HEALTH:
			heal_player(GadgetInfo.gadget_roster["medical_station"]["heal_amount"]*delta)
		else:
			$AnimationPlayer.stop()
			$Ring.hide()

func heal_player(amount):
	CurrentRun.world.current_player_info.current_health += amount
	CurrentRun.world.current_player_info.active_player.health_component.health += amount
	CurrentRun.world.current_player_info.active_player.health_component.healthbar.value = CurrentRun.world.current_player_info.active_player.health_component.health
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("flash_ring")
		$Ring.show()
