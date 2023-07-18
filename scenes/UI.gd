extends CanvasLayer

var time_start = 0
@onready var gametime_label = $MarginContainer/GameTime

# Called when the node enters the scene tree for the first time.
func _ready():
	init_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_time()


func init_time():
	time_start = Time.get_unix_time_from_system()


func process_time():
	var time_elapsed = int(Time.get_unix_time_from_system() - time_start)
	gametime_label.text = str(time_elapsed / 60) + ":" + ("%02d" % floor(time_elapsed % 60))
