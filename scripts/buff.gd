extends Area2D

var active_buffs: Array = []
var attack_delay_bonus: float = 0

func _on_area_entered(area):
	var receiver = area
	for buff in active_buffs:
		if !receiver.active_buffs.has(buff):
			receiver.active_buffs.append(buff)
			receiver.attack_delay_bonus = attack_delay_bonus
			if buff == "poison":
				receiver.toggle_poison_fx(true)

func _on_area_exited(area):
	var receiver = area
	for buff in active_buffs:
		if receiver.active_buffs.has(buff):
			receiver.active_buffs.erase(buff)
			receiver.attack_delay_bonus = 0
			if buff == "poison":
				receiver.toggle_poison_fx(false)
