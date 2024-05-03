extends Node2D

@export var asteroid: PackedScene

func spawn_asteroid():
	var asteroid_instance = asteroid.instantiate()
	%PathFollow2D.progress_ratio = randf()
	asteroid_instance.global_position = %PathFollow2D.global_position
	asteroid_instance.rotation_degrees = randi_range(0,360) 
	add_child(asteroid_instance)
	
func _on_spawn_timer_timeout():
	spawn_asteroid()
