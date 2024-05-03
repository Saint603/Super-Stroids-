extends Node2D

func _ready():
	global.player.visible = false
	Dialogic.start("shop entry")
