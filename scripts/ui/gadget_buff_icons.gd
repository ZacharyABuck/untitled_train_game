extends Node2D

func _process(_delta):
	global_rotation_degrees = 0

	check_buffs()

func check_buffs():
	for child in $HBoxContainer.get_children():
		child.hide()
	
	for child in get_parent().gun.get_children():
		if child is Buff and "stats" in child:
			var icon = find_matching_icon(child.stats)
			if icon != null:
				icon.show()

func find_matching_icon(stats):
	for buff in stats.keys():
		for icon in $HBoxContainer.get_children():
			if icon.name == buff:
				return icon
