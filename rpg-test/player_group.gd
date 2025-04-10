extends Node2D

var players: Array = []
var index : int = 0
var is_battling: bool = false
var action_queue: Array = []

@onready var enemy_group = $"../EnemyGroup"

func _ready():
	players = get_children()
	for i in players.size():
		players[i].position = Vector2(i*32, 0)
	is_battling = false
	action_queue = []

func _process(_delta):
	if not is_battling:
		if Input.is_action_just_pressed("left"):
			var new_index = index - 1
			while new_index >= 0 and not players[new_index].is_alive():
				new_index -= 1
				if new_index >= 0:
					switch_focus(new_index, index)
					index = new_index
		if Input.is_action_just_pressed("right"):
			var new_index = index + 1
			while new_index < players.size() and not players[new_index].is_alive():
				index += 1
				if new_index < players.size():
					switch_focus(new_index, index)
					index = new_index
		if Input.is_action_just_pressed("select"):
			if not action_queue.has(index):
				action_queue.append(index)
				if action_queue.size() == players.filter(func(p): return p.is_alive()).size() and not is_battling:
					start_battle()

func start_battle():
	is_battling = true
	var live_player_indices = []
	for i in players.size():
		if players[i].is_alive():
			live_player_indices.append(i)
	
	print("Action Queue: ", action_queue)
	await _action(action_queue)
	action_queue.clear()
	await start_enemy_turn()
	is_battling = false

func _action(stack) -> void:
	print("Running _action for players: ", stack)
	for player_index in stack:
		var player = players[player_index]
		if not player.is_alive():
			continue
		attack_enemy(player)
		await get_tree().create_timer(1).timeout

func attack_enemy(_player):
	var alive_enemies = enemy_group.get_children().filter(func(e): return e.is_alive())
	if alive_enemies.size() == 0:
		return
	var target_enemy = alive_enemies[randi() % alive_enemies.size()]
	var damage = randi_range(1, 3)
	target_enemy.take_damage(damage)

func _on_enemy_group_next_player() -> void:
	if index < players.size() - 1:
		index += 1
		switch_focus(index, index-1)
	else:
		index = 0
		switch_focus(index, players.size() - 1)

func switch_focus(x,y):
	players[x].focus()
	players[y].unfocus()

func start_enemy_turn() -> void:
	await get_tree().create_timer(0.5)

	for enemy in enemy_group.get_children():
		if not enemy.is_alive():
			continue

		var alive_players = players.filter(func(p): return p.is_alive())
		if alive_players.size() == 0:
			break
		var target_player = players[randi() % players.size()]
		enemy_attack(enemy, target_player)
		await get_tree().create_timer(1).timeout
	is_battling = false
	action_queue.clear()

func enemy_attack(_enemy, player):
	player.take_damage(1)

func check_for_defeat():
	var all_dead = true
	for player in players:
		if player.is_alive():
			all_dead = false
			break
	if all_dead:
		get_tree().change_scene_to_file("res://loseScreen.tscn")
