extends Node2D


func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://battle_scene2.tscn")
