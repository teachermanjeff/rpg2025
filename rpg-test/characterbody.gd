extends CharacterBody2D

@onready var _focus = $focus
@onready var progress_bar = $ProgressBar
@onready var animation_player = $AnimationPlayer

@export var MAX_HEALTH: float = 7

var idle = true

var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()
		_play_animation()

func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100

func _play_animation():
	animation_player.play("Hurt")


func focus():
	_focus.show()

func unfocus():
	_focus.hide()

func take_damage(value):
	health -= value
	_update_progress_bar()
	_play_animation()
	if health <= 0:
		_die()

func attack(target):
	target.take_damage(1)

func _die():
	hide()
	get_tree().change_scene("res://loseScreen.tscn")

func is_alive() -> bool:
	return health > 0
