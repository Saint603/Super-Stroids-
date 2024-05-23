extends Control

@onready var health_bar = %"Health Bar"
@onready var score_text = %Score
@onready var timer_text = %Timer
@onready var money_text = %Money
@onready var shield_label = %"Shield Label"
@onready var shield_bar = %"Shield Bar"

func _ready():
	global.player_ui = self
	health_bar.value = 100
	score_text.set_text("SCORE: 0")
	timer_text.set_text("TIME: 0")
	money_text.set_text("MONEY$: 0")
	
func update():
	if global.player != null:
		health_bar.visible = true
		health_bar.value = (global.player.health.current / global.player.health.max) * 100
		score_text.set_text("SCORE: " + str(global.game.score))
		timer_text.set_text("TIME: " + str(global.game.time))
		money_text.set_text("MONEY$: " + str(global.game.money))
		shield_label.set_text(str(global.player.shield.current) + "/" + str(global.player.shield.max))
		shield_bar.max_value = (global.player.shield.max)
		shield_bar.value = (global.player.shield.current)
	else:
		health_bar.visible = false

	
