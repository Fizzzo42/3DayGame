extends CharacterBody2D
class_name Player

const MAX_MOVE_SPEED = 140
const ACCELERATION_SMOOTHING = 30 #lower = smoother
var hp = 100
var xp = 0
var level = 1
const MAX_LEVEL = 20

@export var ui: Node
@export var sword_ability: PackedScene
@export var upgrade_selection_screen: PackedScene

func _ready():
	update_ui()


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
	if hp <= 0:
		queue_free()
	update_ui()

func increase_xp(xp: int):
	self.xp += xp
	if self.xp >= 100:
		level_up()
		self.xp -= 100
	update_ui()

func level_up():
	level += 1
	#spawn swords
	for i in range(20):
		Callable(spawn_sword).call_deferred()
	update_ui()
	
	if(level >= MAX_LEVEL):
		get_tree().paused = true
		var upgrade_selection_screen_instance = upgrade_selection_screen.instantiate()
		get_parent().get_parent().add_child(upgrade_selection_screen_instance)


func spawn_sword():
	var sword_instance = sword_ability.instantiate() as SwordShooting
	if sword_instance != null:
		get_parent().add_child(sword_instance)


func update_ui():
	ui.find_child('HealthBar').value = hp
	ui.find_child('ExperienceBar').value = self.xp
	ui.find_child('LevelLabel').text = str(level) + ' / ' + str(MAX_LEVEL) 
