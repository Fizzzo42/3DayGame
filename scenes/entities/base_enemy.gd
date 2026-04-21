extends CharacterBody2D
class_name BaseEnemy

const SHOOT_BACK_SPEED = 1000
const MONSTER_HIT_DAMAGE = 20

var tracker: Node
var _player: Player

func _ready():
	tracker = get_node("/root/ProgressionTracker")
	_player = get_tree().get_first_node_in_group("player")
	$Area2D.body_entered.connect(on_body_entered)


func on_body_entered(other_body: Node2D):
	if not other_body is CharacterBody2D:
		return
	if not is_instance_valid(_player) or _player.is_queued_for_deletion():
		queue_free()
		return
	_player.velocity = get_direction_to_player() * SHOOT_BACK_SPEED
	_player.take_damage(MONSTER_HIT_DAMAGE)
	queue_free()


func get_direction_to_player() -> Vector2:
	if not is_instance_valid(_player):
		return Vector2.ZERO
	return (_player.global_position - global_position).normalized()
