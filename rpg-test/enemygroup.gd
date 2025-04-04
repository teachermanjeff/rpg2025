extends Node2D

var enemies: Array = []

func _ready():
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(0, i*32)
