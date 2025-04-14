extends Node

var players: Array
var enemies: Array
var current_turn_queue: Array = []
var current_index: int = 0
var is_battling: bool = false

@onready var player_group = $"../PlayerGroup"
@onready var enemy_group = $"../EnemyGroup"

func _ready():
	players = player_group.get_children()
	enemies = enemy_group.get_children()
	start_combat()

func start_combat():
	current_turn_queue = get_turn_queue()
	current_index = 0
	is_battling = true
	process_turn()

func get_turn_queue() -> Array:
	var turn_queue = []
	for p in players:
		if p.is_alive():
			turn_queue.append(p)
	for e in enemies:
		if e.is_alive():
			turn_queue.append(e)
	return turn_queue

func process_turn():
	if current_index >= current_turn_queue.size():
		current_turn_queue = get_turn_queue()
		current_index = 0
		await get_tree().create_timer(0.5).timeout

	if current_turn_queue.is_empty():
		return

	var current_actor = current_turn_queue[current_index]
	current_index += 1

	if not current_actor.is_alive():
		process_turn()
		return

	if players.has(current_actor):
		await player_turn(current_actor)
	else:
		await enemy_turn(current_actor)

	await get_tree().create_timer(0.5).timeout
	process_turn()

func player_turn(player):
	var alive_enemies = enemies.filter(func(e): return e.is_alive())
	if alive_enemies.size() > 0:
		var target = alive_enemies[randi() % alive_enemies.size()]
		player.attack(target)
		await get_tree().create_timer(1).timeout

func enemy_turn(enemy):
	var alive_players = players.filter(func(p): return p.is_alive())
	if alive_players.size() > 0:
		var target = alive_players[randi() % alive_players.size()]
		enemy.attack(target)
		await get_tree().create_timer(1).timeout
