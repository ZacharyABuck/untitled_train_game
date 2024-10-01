extends Event

var alert_text: String = "Tentacle Trap!"
var occupied_cars: Array = []
var tentacles_killed: int = 0
@onready var tentacle_killed_sfx = $TentacleKilledSFX
@onready var triggered_sfx = $TriggeredSFX

@onready var tentacles = $Tentacles
var tentacle = preload("res://scenes/events/tentacle.tscn")

func trap_triggered(_area):
	if triggered == false:
		triggered_sfx.play()
		set_alert_text_and_play(alert_text)
		event_triggered()
		CurrentRun.world.current_train_info.train_engine.brake_force = 5
		print("Event Triggered: Tentacle Trap")
		
		trigger_tentacles()

func trigger_tentacles():
	for t in tentacles.get_children():
		#pick random car
		var rng = CurrentRun.world.current_train_info.cars_inventory.keys().pick_random()
		while occupied_cars.has(rng):
			rng = CurrentRun.world.current_train_info.cars_inventory.keys().pick_random()
		occupied_cars.append(rng)
		var car = CurrentRun.world.current_train_info.cars_inventory[rng]["node"]
		t.global_position = car.character_spawn_point.global_position
		#spawn on random side of train
		var opposite_side = [true, false].pick_random()
		if opposite_side:
			t.rotation = -car.global_rotation
		else:
			t.rotation = car.global_rotation
		#set initial scale
		t.sprite.scale.x = 0
		t.scale_up()

func tentacle_killed():
	tentacle_killed_sfx.play()
	tentacles_killed += 1
	if tentacles_killed >= 3:
		event_finished()
