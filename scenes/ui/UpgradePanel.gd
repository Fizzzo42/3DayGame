extends Panel
class_name UpgradePanel

var title
var description
var upgrade_type

signal upgrade_chosen

func _ready():
	%Title.text = title
	%Description.text = description
	gui_input.connect(on_gui_input_event)

func on_gui_input_event(event: InputEvent):
	if event.is_pressed():
		get_node("/root/ProgressionTracker").upgrade_player(upgrade_type)
		upgrade_chosen.emit()
