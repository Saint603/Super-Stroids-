##credit https://www.youtube.com/watch?v=ajCraxGAeYU

extends Node2D

@onready var player = global.player
@onready var label = $Label

const base_text = "[F] to "

var active_areas = []
var can_interact = true

func register_area(area: InteractableArea):
	active_areas.push_back(area)

func unregister_area(area: InteractableArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(_delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		##label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()
		
func _sort_by_distance_to_player(area1,area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
