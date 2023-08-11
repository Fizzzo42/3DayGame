extends CharacterBody2D
class_name Player

const ACCELERATION_SMOOTHING = 30 #lower = smoother
var hp = 100.0
var xp = 0.0
var level = 1
const MAX_LEVEL = 8

@export var ui: Node
@export var sword_ability: PackedScene
@export var upgrade_selection_screen: PackedScene

func _ready():
	update_ui()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * get_node("/root/ProgressionTracker").player_movement_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func take_damage(damage: int):
	hp -= damage
	#dieded
	if hp <= 0:
		queue_free()
		var pauseScreen = preload("res://scenes/ui/PausedScreen.tscn").instantiate()
		get_parent().add_child(pauseScreen)
		get_tree().paused = true
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
	for i in range(get_node("/root/ProgressionTracker").player_num_of_swords_spawn):
		Callable(spawn_sword).call_deferred()
	update_ui()
	
	# get upgrades
	if(level % MAX_LEVEL == 0):
		get_tree().paused = true
		var upgrade_selection_screen_instance = upgrade_selection_screen.instantiate()
		get_parent().get_parent().add_child(upgrade_selection_screen_instance)
		level = 1


func spawn_sword():
	var sword_instance = sword_ability.instantiate() as SwordShooting
	if sword_instance != null:
		get_parent().add_child(sword_instance)


func regen_hp():
	hp += get_node("/root/ProgressionTracker").player_hp_regen
	if hp > 100.0:
		hp = 100.0

func update_ui():
	ui.find_child('HealthBar').value = hp
	ui.find_child('ExperienceBar').value = self.xp
	ui.find_child('LevelLabel').text = str(level) + ' / ' + str(MAX_LEVEL) 
