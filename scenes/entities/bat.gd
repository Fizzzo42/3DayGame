extends BaseEnemy
class_name Bat

const SPEED_MULTIPLIER = 1.8
const ZIGZAG_FREQUENCY = 3.0
const ZIGZAG_WEIGHT = 0.7

var time_alive = 0.0

func _process(delta):
	time_alive = fmod(time_alive + delta, TAU / ZIGZAG_FREQUENCY)
	var dir = get_direction_to_player()
	var perp = Vector2(-dir.y, dir.x)
	velocity = (dir + perp * sin(time_alive * ZIGZAG_FREQUENCY) * ZIGZAG_WEIGHT) * tracker.monster_movement_speed * SPEED_MULTIPLIER
	move_and_slide()
