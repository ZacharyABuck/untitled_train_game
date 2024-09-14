extends Area2D

@export_enum("player", "turret") var buff_host

var active_buffs: Array = []

func _on_area_entered(area):
	var receiver = area
	for buff in active_buffs:
		if !receiver.active_buffs.has(buff):
			receiver.active_buffs.append(buff)

func _on_area_exited(area):
	var receiver = area
	for buff in active_buffs:
		if receiver.active_buffs.has(buff):
			receiver.active_buffs.erase(buff)
