extends Control


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://battle_scene.tscn")


func _on_menu_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://lorePage.tscn")


func _on_menu_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://instructionsPage.tscn")
