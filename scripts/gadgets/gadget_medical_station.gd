extends Node2D

var hard_point
var car



# Called when the node enters the scene tree for the first time.
func _ready():
	hard_point = get_parent()
	car = hard_point.car


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if car.index == PlayerInfo.active_player.active_car and \
	PlayerInfo.active_player.health_component.health < PlayerInfo.active_player.health_component.MAX_HEALTH:
		heal_player(GadgetInfo.gadget_roster["medical_station"]["heal_amount"]*delta)
	else:
		$AnimationPlayer.stop()
		$Ring.hide()

func heal_player(amount):
	PlayerInfo.active_player.health_component.health += amount
	PlayerInfo.active_player.health_component.healthbar.value = PlayerInfo.active_player.health_component.health
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("flash_ring")
		$Ring.show()
