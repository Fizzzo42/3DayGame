extends Node

"""
Time:
	Monster Spawn Rate ---------------
	Monster Movement Speed ------------
	Monster Pulsating (animation, NOT MANDATORY, MAYBE CRAZY MODE!!!!)

Buffs:
	Faster Attack -------------
	Bigger Axe -------------
	Attack Range Finder ----------
	Movement Speed -------------
	More Swords -----------
	Idle Game (SEPERATE!!!)

"""

var monster_spawn_timer_timeout = 0.5
var monster_movement_speed = 50

var player_axe_size = 1
var player_axe_attack_speed = 1
var player_movement_speed = 100
var player_num_of_swords_spawn = 5
var player_attack_range_finder = 30


func upgrade_player(player_upgrade: PlayerUpgradeType.PLAYER_UPGRADE):
	match player_upgrade:
		PlayerUpgradeType.PLAYER_UPGRADE.AXE_SIZE:
			player_axe_size += 0.25
		PlayerUpgradeType.PLAYER_UPGRADE.AXE_ATTACK_SPEED:
			player_axe_attack_speed += 0.25
		PlayerUpgradeType.PLAYER_UPGRADE.MOVEMENT_SPEED:
			player_movement_speed += 30
		PlayerUpgradeType.PLAYER_UPGRADE.NUM_OF_SWORDS_SPAWN:
			player_num_of_swords_spawn += 5
		PlayerUpgradeType.PLAYER_UPGRADE.ATTACK_RANGE_FINDER:
			player_attack_range_finder += 5
		_:
			print('WRONG UPGRADE!!!')

func upgrade_monsters():
	match randi() % 2:
		0:
			monster_spawn_timer_timeout /= 1.5
		1:
			monster_movement_speed += 7
