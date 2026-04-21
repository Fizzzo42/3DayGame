extends BaseEnemy
class_name Enemy

func _process(_delta):
	velocity = get_direction_to_player() * tracker.monster_movement_speed
	move_and_slide()
