extends Node2D


func _ready():
	$Area2D.body_entered.connect(enemy_entered)


func enemy_entered(enemy: Node2D):
	enemy.queue_free()
