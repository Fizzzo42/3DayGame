extends Node2D
class_name AttackAnimation

var initial_rotation

func _ready():
	$Node2D/Area2D.body_entered.connect(enemy_entered)
	rotation = initial_rotation
	
	var player_axe_size = get_node("/root/ProgressionTracker").player_axe_size
	scale = Vector2(player_axe_size, player_axe_size)
	$AnimationPlayer.speed_scale = get_node("/root/ProgressionTracker").player_axe_attack_speed

func _process(delta):
	var player = get_player() as Player
	
	if player == null:
		return
	
	global_position = player.global_position


func enemy_entered(enemy: Node2D):
	var player = get_player() as Player
	
	if player != null:
		player.increase_xp(10)
	
	enemy.queue_free()

func get_player():
	return get_tree().get_first_node_in_group("player")
