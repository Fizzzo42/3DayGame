extends CanvasLayer

@onready var restart_button = %RestartButton
@onready var quit_button = %QuitButton

func _ready():
	restart_button.pressed.connect(restart_button_pressed)
	quit_button.pressed.connect(quit_button_pressed)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		queue_free()

func restart_button_pressed():
	get_node("/root/ProgressionTracker").reset()
	get_tree().paused = false
	get_node("/root/SceneHolder").restart_game()

func quit_button_pressed():
	get_tree().quit()
