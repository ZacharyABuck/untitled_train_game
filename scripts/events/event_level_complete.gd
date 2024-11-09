extends Event

var alert_text: String = "Kill Remaining Enemies!"
@onready var player_boundary = $Walls/PlayerBoundary
@onready var town_spawn_point = $TownSpawnPoint
var town = preload("res://scenes/town.tscn")
var town_spawned: bool = false

var car_count: int = 0
signal last_car_entered

func level_complete(_area):
	if triggered == false:
		car_count += 1
		triggered = true
		event_triggered()
		set_alert_text_and_play(alert_text)
		CurrentRun.world.arrived_at_destination(self)
	else:
		car_count += 1
		if car_count >= CurrentRun.world.current_train_info.train_stats["car_count"]:
			last_car_entered.emit()

func _on_outer_area_area_entered(area):
	if area.get_parent().is_in_group("car") and !town_spawned:
		town_spawned = true
		spawn_town()

func spawn_town():
	var new_town = town.instantiate()
	call_deferred("add_child", new_town)
	new_town.position = town_spawn_point.position
