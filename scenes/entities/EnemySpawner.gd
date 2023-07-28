extends Node

const SPAWN_RADIUS = 380

@export var enemy_scene: PackedScene

func _ready():
	refresh_timer_timeout()
	$Timer.timeout.connect(spawn_enemy)


func spawn_enemy():
	refresh_timer_timeout()
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
		
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + random_direction * SPAWN_RADIUS
	
	var enemy = enemy_scene.instantiate() as Node2D
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)

func refresh_timer_timeout():
	$Timer.wait_time = get_node("/root/ProgressionTracker").monster_spawn_timer_timeout
