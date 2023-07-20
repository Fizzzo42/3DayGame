extends CharacterBody2D
class_name Player

const MAX_MOVE_SPEED = 140
const ACCELERATION_SMOOTHING = 30 #lower = smoother
var hp = 100
var xp = 0
var level = 1
const MAX_LEVEL = 50

@export var ui: Node
@export var sword_ability: PackedScene


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_MOVE_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func take_damage(damage: int):
	hp -= damage
	ui.find_child('HealthBar').value = hp
	if hp <= 0:
		queue_free()

func increase_xp(xp: int):
	self.xp += xp
	if self.xp >= 100:
		level_up()
		self.xp -= 100
		
	ui.find_child('ExperienceBar').value = self.xp

func level_up():
	ui.find_child('LevelLabel').text = str(level) + ' / ' + str(MAX_LEVEL) 
	level += 1
	#spawn swords
	for i in range(20):
		Callable(spawn_sword).call_deferred()


func spawn_sword():
	var sword_instance = sword_ability.instantiate() as SwordShooting
	if sword_instance != null:
		get_parent().add_child(sword_instance)
