extends Turret

var shock_buff_scene: PackedScene = preload("res://scenes/buffs/buff_shock.tscn")

func _ready():
	super()

	var new_buff = shock_buff_scene.instantiate()
	new_buff.timed = false
	gun.call_deferred("add_child", new_buff)
