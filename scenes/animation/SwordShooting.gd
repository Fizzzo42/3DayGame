extends Area2D
class_name SwordShooting

const ACCELERATION_SPEED = 5 # low = slower
const MIN_SHOOTOUT_RANGE = 100
const MAX_SHOOTOUT_RANGE = 200
const ROTATION_SPEED = 5
var target_position = Vector2(0, 0)


func _ready():
	self.body_entered.connect(enemy_entered)
	var player = get_player() as Player
	target_position = player.global_position + Vector2.from_angle(randf_range(0, 360)) * randi_range(MIN_SHOOTOUT_RANGE + 10 * get_node("/root/ProgressionTracker").player_num_of_swords_spawn, MAX_SHOOTOUT_RANGE + 10 * get_node("/root/ProgressionTracker").player_num_of_swords_spawn)
	global_position = player.global_position
	
	

func _process(delta):
	global_position = global_position.lerp(target_position, 1 - exp(-delta * ACCELERATION_SPEED))
	rotation+= delta * ROTATION_SPEED


func enemy_entered(enemy: Node2D):
	if not enemy.is_class('CharacterBody2D'):
		return
	
	var player = get_player() as Player
	
	if player != null:
		player.increase_xp(1 + 2 / get_node("/root/ProgressionTracker").player_num_of_swords_spawn)
	
	enemy.queue_free()

func get_player():
	return get_tree().get_first_node_in_group("player")
