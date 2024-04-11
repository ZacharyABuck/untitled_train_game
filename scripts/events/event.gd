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

func event_finished():
	TrainInfo.train_engine.brake_force = 0
	LevelInfo.active_level.alert_label.hide()
