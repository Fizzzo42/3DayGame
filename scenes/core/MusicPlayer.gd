extends AudioStreamPlayer

var current_music_index = 0
var streams = [
	preload("res://assets/audio/kim-lightyear-legends-109307.mp3"), 
	preload("res://assets/audio/kim-lightyear-just-a-dream-wake-up-153991.mp3"),
	preload("res://assets/audio/kim-lightyear-angel-eyes-chiptune-edit-110226.mp3")
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	next_song()
	finished.connect(next_song)
	
func next_song():
	stream = streams[current_music_index % streams.size()]
	play()
	current_music_index += 1
