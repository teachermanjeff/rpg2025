extends Node2D

var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0
var is_active_turn: bool = true

signal next_player
@onready var choice = $"../CanvasLayer/choice"
@onready var endGameButton = $"../CanvasLayer/endGameButton"

func _ready():
	#print("End Game Button is: ", endGameButton)
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(i*32, 0)
	endGameButton.hide()
	show_choice()
	var attack_button = choice.get_node("Attack")
	attack_button.pressed.connect(_on_attack_pressed)

func _process(_delta):
	if !is_active_turn:
		return
	if not choice.visible:
		if Input.is_action_just_pressed("left"):
			var new_index = index - 1
			while new_index >= 0 and not enemies[new_index].is_alive():
				new_index -= 1
			if new_index >= 0:
				switch_focus(new_index, index)
				index = new_index

		if Input.is_action_just_pressed("right"):
			var new_index = index + 1
			while new_index < enemies.size() and not enemies[new_index].is_alive():
				new_index += 1
			if new_index < enemies.size():
				switch_focus(new_index, index)
				index = new_index
		if Input.is_action_just_pressed("select"):
			action_queue.push_back(index)
			emit_signal("next_player")
	
	if action_queue.size() == enemies.size() and not is_battling:
		is_battling = true
		_action(action_queue)
		check_for_victory()
		
func _action(stack):
	for i in stack:
		if enemies[i].is_alive():
			enemies[i].take_damage(1)
		await get_tree().create_timer(1).timeout
	action_queue.clear()
	is_battling = false
	show_choice()




func switch_focus(x,y):
	enemies[x].focus()
	enemies[y].unfocus()

func show_choice():
	choice.show()
	choice.find_child("Attack").grab_focus()

func _reset_focus():
	index = 0
	for enemy in enemies:
		enemy.unfocus()
		

func _start_choosing():
	_reset_focus()
	enemies[0].focus()

func _on_attack_pressed():
	choice.hide()
	_start_choosing()

func check_for_victory():
	var all_dead = true
	for enemy in enemies:
		if enemy.is_alive():
			all_dead = false
			break
	if all_dead:
		endGame()
		choice.hide()

func endGame():
	endGameButton.show()


func _on_end_game_button_pressed():
	get_tree().change_scene_to_file("res://winScreen.tscn")
