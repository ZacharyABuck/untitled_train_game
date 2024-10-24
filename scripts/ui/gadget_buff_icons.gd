extends Node2D

var active_buffs

func _process(_delta):
	global_rotation_degrees = 0
	
	if "active_buffs" in get_parent():
		active_buffs = get_parent().active_buffs
		check_buffs()

func check_buffs():
	for buff in active_buffs.keys():
		var icon = find_matching_icon(buff)
		var buff_is_active: bool = false
		
		if icon != null:
			if active_buffs[buff] is int or active_buffs[buff] is float:
				if active_buffs[buff] > 0:
					buff_is_active = true
			elif active_buffs[buff] is bool:
				if active_buffs[buff] == true:
					buff_is_active = true
		
		if buff_is_active:
			icon.show()
		else:
			icon.hide()

func find_matching_icon(buff):
	for icon in $HBoxContainer.get_children():
		if icon.name == buff:
			return icon
