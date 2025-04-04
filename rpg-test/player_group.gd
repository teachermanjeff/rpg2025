extends Node2D

var players: Array = []

func _ready():
	players = get_children()
	for i in players.size():
		players[i].position = Vector2(0, i*32)
