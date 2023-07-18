extends CharacterBody2D

const MAX_SPEED = 50

func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player():
	return (get_player_global_position() - global_position).normalized()


func on_body_entered(other_area: Node2D):
	var player_position = get_player_global_position()
	var propel_direction = player_position - global_position
	
	var player_node = get_player() as CharacterBody2D
	player_node.velocity = propel_direction * 50
	
	queue_free()

func get_player_global_position():
	var player_node = get_player() as Node2D
	if player_node != null:
		return player_node.global_position
	return Vector2.ZERO


func get_player():
	return get_tree().get_first_node_in_group("player")
