extends Area2D

func _on_body_entered(body):
	print(body)
	if body.is_class("CharacterBody2D"):
		global.game.money += 1
		global.player_ui.update()
		queue_free()
