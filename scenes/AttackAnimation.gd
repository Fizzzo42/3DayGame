extends Node2D
class_name AttackAnimation

var initial_rotation

func _ready():
	%Area2D.body_entered.connect(enemy_entered)
	rotation = initial_rotation

func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return
	
	global_position = player.global_position


func enemy_entered(enemy: Node2D):
	enemy.queue_free()
