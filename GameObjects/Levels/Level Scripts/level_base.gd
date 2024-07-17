extends Node2D

signal player_leaving(direction) 

func _ready():
	self.name = "Level:" + str(global.game.current_level.x) + "-" + str(global.game.current_level.y)
	
func _on_north_border_body_entered(_body):
	if global.game.current_level.in_transition != true:
		global.game.call_deferred("change_scene","North")

func _on_south_border_body_entered(_body):
	if global.game.current_level.in_transition != true:
		global.game.call_deferred("change_scene","South")

func _on_west_border_body_entered(_body):
	if global.game.current_level.in_transition != true:
		global.game.call_deferred("change_scene","West")

func _on_east_border_body_entered(_body):
	if global.game.current_level.in_transition != true:
		global.game.call_deferred("change_scene","East")

