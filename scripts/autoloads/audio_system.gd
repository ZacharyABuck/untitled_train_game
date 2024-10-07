extends Node

var sounds = {
	basic_button_click = preload("res://sounds/ui/basic_click.wav"),
	tick = preload("res://sounds/ui/menu-select-tick.wav"),
	big_select = preload("res://sounds/ui/big_select.mp3"),
	hit = preload("res://sounds/combat/hit_01.wav"),
	player_hit = preload("res://sounds/combat/oof.wav"),
	gunshot = preload("res://sounds/combat/gunshot_01.wav"),
	
}

func play_audio(sound_id):
	var sound = sounds[sound_id]
	
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	
	new_player.stream = sound
	new_player.bus = "SFX"
	new_player.volume_db = -10
	
	new_player.play()
	
	await new_player.finished
	new_player.queue_free()

func play_audio_2d(sound_id, pos):
	var sound = sounds[sound_id]
	
	var new_player = AudioStreamPlayer2D.new()
	new_player.global_position = pos
	add_child(new_player)
	
	new_player.stream = sound
	new_player.bus = "SFX"
	new_player.volume_db = -10
	
	new_player.play()
	
	await new_player.finished
	new_player.queue_free()
