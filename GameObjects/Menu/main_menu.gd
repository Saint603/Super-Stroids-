extends Control

@onready var options_menu = preload("res://GameObjects/Menu/options_menu.tscn")

signal play_pressed()

func _on_play_pressed():
	play_pressed.emit()

func _on_options_pressed():
	var options_menu_instance = options_menu.instantiate()
	self.add_child(options_menu_instance)
	options_menu_instance.global_position = self.global_position
	%VBoxContainer.visible = false

func _on_exit_pressed():
	get_tree().quit()
