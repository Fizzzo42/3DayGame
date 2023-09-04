extends CanvasLayer

const MONSTER_UPGRADE_INTERVAL = 30
var time_elapsed = 0
@onready var gametime_label = %GameTime

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		var pauseScreen = preload("res://scenes/ui/PausedScreen.tscn").instantiate()
		get_parent().add_child(pauseScreen)
		get_tree().paused = true

func on_timer_timeout():
	time_elapsed += 1
	update_ui()
	check_monsters_upgrade()
	player_hp_regen()
	handle_steam_achievments()

func update_ui():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		gametime_label.text = str(time_elapsed / 60) + ":" + ("%02d" % floor(time_elapsed % 60))
		
func check_monsters_upgrade():
	if time_elapsed % MONSTER_UPGRADE_INTERVAL == 0:
		get_node("/root/ProgressionTracker").upgrade_monsters()

func player_hp_regen():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player_nodes[0].regen_hp()

func handle_steam_achievments():
	if time_elapsed > 0 and time_elapsed <= 600 and time_elapsed % 30 == 0:
		var achievment_name = str("%03d" % floor(time_elapsed))
		Steam.setAchievement(achievment_name)
		Steam.storeStats()
		print('Added achievment: ' + achievment_name)
