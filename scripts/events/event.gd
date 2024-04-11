extends Area2D
class_name Event

var triggered: bool = false
var type: String

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(event_triggered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#triggers when collision shape is entered
func event_triggered(object):
	match type:
		"ambush":
			if object.get_parent().is_in_group("car") and triggered == false:
				print("Event Triggered: Ambush")
				triggered = true
				TrainInfo.train_engine.brake_force = 5
				LevelInfo.active_level.alert_label.show()
				var new_spawner = EnemySpawner.new()
				LevelInfo.active_level.add_child(new_spawner)
				new_spawner.spawn_enemy(5, "bandit", null)
		"zombie_horde":
			if object.get_parent().is_in_group("car") and triggered == false:
				print("Event Triggered: Zombie Horde")
				for i in $Zombies.get_children():
					i.target = PlayerInfo.active_player
					i.state = "moving"
					i.call_deferred("reparent", LevelInfo.active_level.enemies)

func event_finished():
	TrainInfo.train_engine.brake_force = 0
	LevelInfo.active_level.alert_label.hide()
