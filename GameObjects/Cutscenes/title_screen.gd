extends Control


func _on_main_menu_play_pressed():
	global.game.start()
	queue_free()
