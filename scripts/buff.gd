extends Area2D

var active_buffs: Dictionary

func _on_area_entered(area):
	var receiver = area
	WeaponInfo.attach_buffs(active_buffs, receiver.active_buffs)

func _on_area_exited(area):
	var receiver = area
	WeaponInfo.detach_buffs(active_buffs, receiver.active_buffs)
