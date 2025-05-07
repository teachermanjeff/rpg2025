extends Node2D

var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0
var is_active_turn: bool = true

signal player_attack_complete
signal next_player
@onready var choice = $"../CanvasLayer/choice"
@onready var next_level_button = get_tree().root.get_node("BattleScene/CanvasLayer/next_level_button")
@export var level: int = 1

func _ready():
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(i*32, 0)
	next_level_button.hide()
	show_choice()

func _process(_delta):
	if !is_active_turn:
		return
	if not choice.visible:
		if Input.is_action_just_pressed("left"):
			handle_left_input()
		if Input.is_action_just_pressed("right"):
			handle_right_input()
		if Input.is_action_just_pressed("select"):
			handle_select_input()
	
	if action_queue.size() == enemies.size() and not is_battling:
		is_battling = true
		_action(action_queue)
		check_for_victory()
		
func _action(stack):
	for i in stack:
		if enemies[i].is_alive():
			enemies[i].take_damage(1)
			check_for_victory()
		await get_tree().create_timer(1).timeout
	action_queue.clear()
	is_battling = false
	emit_signal("player_attack_complete")
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
		show_next_level_button()
		choice.hide()

func _on_run_pressed():
	get_tree().change_scene_to_file("res://titleScreen.tscn")


func show_next_level_button():
	next_level_button.show()

func _on_next_level_button_pressed():
	get_tree().change_scene_to_file("res://battle_scene2.tscn")


func _on_left_button_pressed():
	handle_left_input()


func _on_right_button_pressed():
	handle_right_input()

func handle_left_input():
	var new_index = index - 1
	while new_index >= 0 and not enemies[new_index].is_alive():
		new_index -= 1
	if new_index >= 0:
		switch_focus(new_index, index)
		index = new_index

func handle_right_input():
	var new_index = index + 1
	while new_index < enemies.size() and not enemies[new_index].is_alive():
		new_index += 1
	if new_index < enemies.size():
		switch_focus(new_index, index)
		index = new_index


func _on_strike_button_pressed():
	handle_select_input()

func handle_select_input():
	action_queue.push_back(index)
	emit_signal("next_player")
