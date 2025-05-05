extends CharacterBody2D

@onready var _focus = $focus
@onready var progress_bar = $ProgressBar
@onready var animation_player = $AnimationPlayer
@export var MAX_HEALTH_RANGE_MIN: int = 3
@export var MAX_HEALTH_RANGE_MAX: int = 8

var MAX_HEALTH: int

var idle = true

var level: int = 1  

func set_level(value: int) -> void:
	level = value



var health: float:
	set(value):
		health = value
		_update_progress_bar()
		_play_animation()

func _ready():
	randomize()
	var bonus = level * 2 
	MAX_HEALTH = randi_range(MAX_HEALTH_RANGE_MIN + bonus, MAX_HEALTH_RANGE_MAX + bonus)
	health = MAX_HEALTH

func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100

func _play_animation():
	animation_player.play("Hurt")


func focus():
	print(name, " is being focused.")
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
	var damage = randi_range(1, 3)
	target.take_damage(damage)

func _die():
	hide()

func is_alive() -> bool:
	return health > 0
