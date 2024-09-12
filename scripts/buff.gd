extends Area2D

@export_enum("player", "turret") var buff_host

var active_buffs: Array = []

func _on_area_entered(area):
	var receiver = area
	receiver.active_buffs = active_buffs

func _on_area_exited(area):
	var receiver = area
	receiver.active_buffs = []
