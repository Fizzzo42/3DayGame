extends Node

const SPAWN_RADIUS = 380

@export var enemy_scenes: Array[PackedScene]

var _tracker: Node

func _ready():
	_tracker = get_node("/root/ProgressionTracker")
	$Timer.timeout.connect(spawn_enemy)
	refresh_timer_timeout()


func spawn_enemy():
	if enemy_scenes.is_empty():
		return
	refresh_timer_timeout()
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return

	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + random_direction * SPAWN_RADIUS

	var enemy = enemy_scenes[randi() % enemy_scenes.size()].instantiate() as Node2D
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)


func refresh_timer_timeout():
	$Timer.wait_time = _tracker.monster_spawn_timer_timeout
