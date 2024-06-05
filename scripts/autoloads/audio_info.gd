extends Node

#CURRENTLY NOT IN USE

var audio_player_count: int = 10

var available = []
var queue = []

var sounds = {
	"canon" = preload("res://sounds/combat/canon_01.wav"),
	"explosion" = preload("res://sounds/combat/explosion_01.wav"),
	"gunshot_small" = preload("res://sounds/combat/gunshot_01.wav"),
	"gunshot_large" = preload("res://sounds/combat/gunshot_02.wav"),
	"hit" = preload("res://sounds/combat/hit_01.wav"),
	"hit_metal" = preload("res://sounds/combat/hit_metal.wav"),
	"oof" = preload("res://sounds/combat/oof.wav"),
	"whoosh" = preload("res://sounds/combat/woosh.wav"),
	"running" = preload("res://sounds/player/running_wood.wav"),
}

func _ready():
	for i in audio_player_count:
		var s = AudioStreamPlayer.new()
		add_child(s)
		available.append(s)
		s.finished.connect(stream_finished.bind(s))
		s.bus = "SFX"

func stream_finished(audio_player):
	available.append(audio_player)

func play(sound_path):
	queue.append(sound_path)

func _process(_delta):
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = sounds[queue.pop_front()]
		available[0].play()
		available.pop_front()
