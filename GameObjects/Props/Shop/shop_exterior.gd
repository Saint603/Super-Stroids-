extends Node2D

func _ready():
	%InteractableArea.interact = Callable(self, "_on_interact")

func _on_interact():
	global.game.update_current_level_special("shop")
