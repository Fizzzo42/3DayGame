extends Node

const MAX_RANGE = 40

@export var axe_ability: PackedScene


func _process(delta):
	if $Timer.is_stopped():
		var player = get_player()
		var enemies = get_enemies_in_range(player)
		if is_attack_possible(enemies):
			perform_attack(player, enemies)
		

func is_attack_possible(enemies: Array[Node]):
	return enemies.size() > 0


func perform_attack(player: Node2D, enemies: Array[Node]):
	if player == null:
		return
		
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var axe_instance = axe_ability.instantiate() as AttackAnimation
	if axe_instance != null:
		axe_instance.initial_rotation = ((enemies[0].global_position - player.global_position) as Vector2).angle()
		axe_instance.global_position = player.global_position
		get_parent().add_child(axe_instance)
		$Timer.start()
		

func get_enemies_in_range(player: Node2D):
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group('enemy')
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	return enemies

func get_player():
	return get_tree().get_first_node_in_group('player')
