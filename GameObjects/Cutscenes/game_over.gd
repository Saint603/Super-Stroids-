extends Control


func _on_try_again_pressed():
	global.game.restart()
	queue_free()


func _on_quit_pressed():
	get_tree().quit()
