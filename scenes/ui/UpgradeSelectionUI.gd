extends CanvasLayer

func _ready():
	var scene = preload("res://scenes/ui/UpgradePanel.tscn")
	var panel1 = scene.instantiate()
	panel1.title = 'BIGGER AXE'
	panel1.description = 'Increases the Axe Size.'
	panel1.upgrade_type = PlayerUpgradeType.PLAYER_UPGRADE.AXE_SIZE
	panel1.upgrade_chosen.connect(upgrade_chosen)
	$MarginContainer/HBoxContainer.add_child(panel1)
	
func upgrade_chosen():
	get_tree().paused = false
	queue_free()
