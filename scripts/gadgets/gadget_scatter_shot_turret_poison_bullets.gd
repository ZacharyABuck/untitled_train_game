extends Turret

var poison_buff_scene: PackedScene = preload("res://scenes/buffs/buff_poison.tscn")

func _ready():
	super()

	var new_buff = poison_buff_scene.instantiate()
	new_buff.timed = false
	gun.call_deferred("add_child", new_buff)
