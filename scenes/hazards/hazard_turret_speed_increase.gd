extends Hazard

var active_buffs = {"attack_delay": 1}

var equipped_gadget

func _physics_process(delta):
	super(delta)
	
	if equipped_gadget != null:
		global_position = equipped_gadget.global_position

func _on_gadget_detector_area_entered(area):
	if area.get_parent() is Gadget:
		equipped_gadget = area.get_parent()
		WeaponInfo.attach_buffs(active_buffs, area.get_parent().active_buffs)
		disable_collision()
		$Sprite2D.hide()
		
		#deactivate after 5 seconds
		await get_tree().create_timer(5).timeout
		WeaponInfo.detach_buffs(active_buffs, area.get_parent().active_buffs)
		queue_free()

func disable_collision():
	$GadgetDetector/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
