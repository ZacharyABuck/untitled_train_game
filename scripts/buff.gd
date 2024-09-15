extends Area2D

var active_buffs: Array = []

func _on_area_entered(area):
	var receiver = area
	for buff in active_buffs:
		if !receiver.active_buffs.has(buff):
			receiver.active_buffs.append(buff)
			
			if buff == "poison":
				receiver.toggle_poison_fx(true)

func _on_area_exited(area):
	var receiver = area
	for buff in active_buffs:
		if receiver.active_buffs.has(buff):
			receiver.active_buffs.erase(buff)
			
			if buff == "poison":
				receiver.toggle_poison_fx(false)
