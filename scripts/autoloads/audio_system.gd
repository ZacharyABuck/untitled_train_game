extends Node

var sounds = {
	basic_button_click = preload("res://sounds/ui/basic_click.wav"),
	tick = preload("res://sounds/ui/menu-select-tick.wav"),
	big_select = preload("res://sounds/ui/big_select.mp3"),
	hit = preload("res://sounds/combat/hit_01.wav"),
	player_hit = preload("res://sounds/combat/oof.wav"),
	gunshot = preload("res://sounds/combat/gunshot_01.wav"),
	quick_woosh = preload("res://sounds/ui/quick_woosh.wav"),
}

var sounds_inventory = {}
var max_sounds: int = 3

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_audio(sound_id, db):
	var sound = sounds[sound_id]
	
	if sounds_inventory.has(sound) and sounds_inventory[sound] >= max_sounds:
		pass
	else:
		
		var new_player = AudioStreamPlayer.new()
		add_child(new_player)
		if sounds_inventory.has(sound):
			sounds_inventory[sound] += 1
		else:
			sounds_inventory[sound] = 1
		
		new_player.stream = sound
		new_player.bus = "SFX"
		new_player.volume_db = db
		
		new_player.play()
		new_player.finished.connect(delete_audio_player.bind(new_player, sound))

func delete_audio_player(audio_player, sound):
	sounds_inventory[sound] = max(sounds_inventory[sound]-1 , 0)
	audio_player.queue_free()

func play_audio_2d(sound_id, pos, db):
	var sound = sounds[sound_id]
	
	if sounds_inventory.has(sound) and sounds_inventory[sound] >= max_sounds:
		pass
	else:
		var new_player = AudioStreamPlayer2D.new()
		new_player.global_position = pos
		add_child(new_player)
		if sounds_inventory.has(sound):
			sounds_inventory[sound] += 1
		else:
			sounds_inventory[sound] = 1
		
		new_player.stream = sound
		new_player.bus = "SFX"
		new_player.volume_db = db
		
		new_player.play()
		
		await new_player.finished
		sounds_inventory[sound] = max(sounds_inventory[sound]-1 , 0)
		new_player.queue_free()
		
