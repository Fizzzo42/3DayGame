extends CharacterBody2D
class_name Enemy

const SHOOT_BACK_SPEED = 1000
const MONSTER_HIT_DAMAGE = 20

func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * get_node("/root/ProgressionTracker").monster_movement_speed
	move_and_slide()


func get_direction_to_player():
	return (get_player_global_position() - global_position).normalized()


func on_body_entered(other_body: Node2D):
	if !other_body.is_class('CharacterBody2D'):
		return
	var player_position = get_player_global_position()
	var propel_direction = player_position - global_position
	
	var player_node = get_player() as Player
	player_node.velocity = propel_direction.normalized() * SHOOT_BACK_SPEED
	
	player_node.take_damage(MONSTER_HIT_DAMAGE)
	
	queue_free()
	

func get_player_global_position():
	var player_node = get_player() as Node2D
	if player_node != null:
		return player_node.global_position
	return Vector2.ZERO


func get_player():
	return get_tree().get_first_node_in_group("player")
