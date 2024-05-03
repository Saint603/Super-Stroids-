extends AudioStreamPlayer2D

var offset = 0
func play_sound(sound):
	set_stream(sound)
	play(offset)
	
func _on_finished():
	queue_free()
