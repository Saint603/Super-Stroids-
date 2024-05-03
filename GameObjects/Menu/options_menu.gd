extends Control

func _on_back_pressed():
	get_parent().get_child(0).get_child(0).visible = true ##jesus christ nate. It works but really
	queue_free()
	
