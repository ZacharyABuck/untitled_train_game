extends Hazard

var damage = 4

func _physics_process(delta):
	super(delta)
	
	if global_position.distance_to(CurrentRun.world.current_player_info.active_player.global_position) <= 25 and grabbed:
		queue_free()

func enemy_detector_area_entered(area):
	if area is HurtboxComponent and grabbed:
		AudioSystem.play_audio("rock_smash", -10)
		var new_hurtbox : HurtboxComponent = area
		var attack = Attack.new()
		attack.stats["damage"] = damage
		new_hurtbox.damage(attack)
		queue_free()
