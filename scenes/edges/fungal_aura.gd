extends Edge

var buff_scene = preload("res://scenes/buffs/buff_poison.tscn")

var current_buffs = []

func handle_level_up():
	$BuffArea/CollisionShape2D.shape.radius *= 1.2
	$Aura.scale *= 1.2

func area_entered(area):
	if area.get_parent() is Turret:
		var new_buff = buff_scene.instantiate()
		new_buff.timed = false
		area.get_parent().gun.call_deferred("add_child", new_buff)
		current_buffs.append(new_buff)

func area_exited(area):
	if area.get_parent() is Turret:
		for child in area.get_parent().gun.get_children():
			if current_buffs.has(child):
				current_buffs.erase(child)
				child.queue_free()
