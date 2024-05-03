extends Area2D
class_name InteractableArea

@export var action_name: String = "interact"

var interact: Callable = func(): ##variable that holds a function. Very interesting
	pass


func _on_body_entered(_body):
	global.interaction_manager.register_area(self)


func _on_body_exited(_body):
	global.interaction_manager.unregister_area(self)
