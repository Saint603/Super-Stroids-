extends Node

var game
var player
var player_ui
var inventory_ui
var direct_audio = preload("res://Audio/direct_audio.tscn")
var interaction_manager

var save_data_table = []

func add_temp_instance(child):
	game.temp_instances.add_child(child)
	
func add_sound(locationVector, sound, buffer: float = 0.0, volume: float = 0, randomize_pitch: bool = false):
	var sound_player = AudioStreamPlayer2D.new()
	game.temp_instances.add_child(sound_player)
	sound_player.set_stream(load(sound))
	sound_player.volume_db = volume
	sound_player.global_position = locationVector
	sound_player.finished.connect(_on_sound_finished.bind(sound_player))
	if randomize_pitch: sound_player.pitch_scale = randf_range(0.9,1.1)
	await get_tree().create_timer(buffer).timeout
	sound_player.play()

func _on_sound_finished(sound_player):
	sound_player.queue_free()

func check_off_screen(object, destroy: bool = false):
	var buffer = 300
	var is_off_screen = false
	
	if (object.global_position.x < -buffer || object.global_position.x > (global.game.get_viewport().size.x + buffer)):
		is_off_screen = true
	if (object.global_position.y < -buffer || object.global_position.y > (global.game.get_viewport().size.y + buffer)):
		is_off_screen = true
	
	if destroy && is_off_screen:
		object.queue_free()
	return is_off_screen

func dialogic_update_current_level(x,y):
	player.visible = true
	game.update_current_level(x,y)
	
func dialogic_update_current_level_special(level):
	player.visible = true
	game.update_current_level_special(level)
