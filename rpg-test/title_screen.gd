extends Control


func _on_menu_button_pressed() -> void:
	get_tree().change_scene("res://battle_scene.tscn")


func _on_menu_button_2_pressed() -> void:
	get_tree().change_scene("res://lorePage.tscn")
