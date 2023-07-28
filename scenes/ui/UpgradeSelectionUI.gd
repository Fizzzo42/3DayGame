extends CanvasLayer


var possible_upgrades = [
		Upgrade.new('Attack Speed','Faster Axe Attack Speed',PlayerUpgradeType.PLAYER_UPGRADE.AXE_ATTACK_SPEED), 
		Upgrade.new('Big Axe','Biger Axe',PlayerUpgradeType.PLAYER_UPGRADE.AXE_SIZE), 
		Upgrade.new('Range Finder','Increases the Range Finder Radius',PlayerUpgradeType.PLAYER_UPGRADE.ATTACK_RANGE_FINDER),
		Upgrade.new('Sword Madness','SWOOOOOOOORRDDS',PlayerUpgradeType.PLAYER_UPGRADE.NUM_OF_SWORDS_SPAWN),
		Upgrade.new('Movement Speed','Increases Movement Speed',PlayerUpgradeType.PLAYER_UPGRADE.MOVEMENT_SPEED),
		Upgrade.new('HP Regen','Slowly regenerates HP',PlayerUpgradeType.PLAYER_UPGRADE.HP_REGEN),
	]

func _ready():
	var upgrades = get_three_random_upgrades()
	for upgrade in upgrades:
		var panel = create_upgrade_panel(upgrade)
		$MarginContainer/HBoxContainer.add_child(panel)
	
func upgrade_chosen():
	get_tree().paused = false
	queue_free()

func get_three_random_upgrades():
	possible_upgrades.shuffle()
	return possible_upgrades.slice(0,3)
	
func create_upgrade_panel(upgrade: Upgrade):
	var scene = preload("res://scenes/ui/UpgradePanel.tscn")
	var panel = scene.instantiate()
	panel.title = upgrade.title
	panel.description = upgrade.description
	panel.upgrade_type = upgrade.upgrade_type
	panel.upgrade_chosen.connect(upgrade_chosen)
	return panel
	
class Upgrade:
	var title
	var description
	var upgrade_type
	func _init(title, description, upgrade_type: PlayerUpgradeType.PLAYER_UPGRADE):
		self.title = title
		self.description = description
		self.upgrade_type = upgrade_type
