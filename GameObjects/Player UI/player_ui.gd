extends Control

@onready var health_bar = %"Health Bar"
@onready var score_text = %Score
@onready var timer_text = %Timer

func _ready():
	global.player_ui = self
	health_bar.value = 100
	score_text.set_text("SCORE: 0")
	timer_text.set_text("TIME: 0")
	
func update():
	if global.player != null:
		health_bar.visible = true
		health_bar.value = (global.player.health.current / global.player.health.max) * 100
		score_text.set_text("SCORE: " + str(global.game.score))
		timer_text.set_text("TIME: " + str(global.game.time))
	else:
		health_bar.visible = false

	
