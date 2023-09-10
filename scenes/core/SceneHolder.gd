extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_scene = preload("res://scenes/core/Main.tscn").instantiate()
	add_child(main_scene)

func restart_game():
	for child in get_children():
		remove_child(child) # Crashes without explicitly removing from the scene.
		child.queue_free()

	var main_scene = preload("res://scenes/core/Main.tscn").instantiate()
	add_child(main_scene)
