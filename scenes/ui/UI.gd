extends CanvasLayer

const MONSTER_UPGRADE_INTERVAL = 30
var time_elapsed = 0
@onready var gametime_label = %GameTime

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	time_elapsed += 1
	update_ui()
	check_monsters_upgrade()

func update_ui():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		gametime_label.text = str(time_elapsed / 60) + ":" + ("%02d" % floor(time_elapsed % 60))
		
func check_monsters_upgrade():
	if time_elapsed % MONSTER_UPGRADE_INTERVAL == 0:
		get_node("/root/ProgressionTracker").upgrade_monsters()
