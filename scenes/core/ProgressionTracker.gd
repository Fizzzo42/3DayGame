extends Node

var monster_spawn_timer_timeout
var monster_movement_speed

var player_axe_size
var player_axe_attack_speed
var player_movement_speed
var player_num_of_swords_spawn
var player_attack_range_finder
var player_hp_regen

func _ready():
	reset()
	_initialize_Steam()

func _initialize_Steam() -> void:
	var INIT: Dictionary = Steam.steamInit(false)
	print("Did Steam initialize?: "+str(INIT))


func upgrade_player(player_upgrade: PlayerUpgradeType.PLAYER_UPGRADE):
	match player_upgrade:
		PlayerUpgradeType.PLAYER_UPGRADE.AXE_SIZE:
			player_axe_size += 0.1
		PlayerUpgradeType.PLAYER_UPGRADE.AXE_ATTACK_SPEED:
			player_axe_attack_speed += 0.3
		PlayerUpgradeType.PLAYER_UPGRADE.MOVEMENT_SPEED:
			player_movement_speed += 15
		PlayerUpgradeType.PLAYER_UPGRADE.NUM_OF_SWORDS_SPAWN:
			player_num_of_swords_spawn += 3
		PlayerUpgradeType.PLAYER_UPGRADE.ATTACK_RANGE_FINDER:
			player_attack_range_finder += 5
		PlayerUpgradeType.PLAYER_UPGRADE.HP_REGEN:
			player_hp_regen += 0.2
		_:
			print('WRONG UPGRADE!!!')

func upgrade_monsters():
	match randi() % 2:
		0:
			monster_spawn_timer_timeout /= 1.5
		1:
			monster_movement_speed += 9

func reset():
	monster_spawn_timer_timeout = 0.2
	monster_movement_speed = 60
	player_axe_size = 1
	player_axe_attack_speed = 1
	player_movement_speed = 100
	player_num_of_swords_spawn = 3
	player_attack_range_finder = 30
	player_hp_regen = 0
