extends Control

@export var fade_speed : float = 0.7
@onready var alpha = 1.0
@onready var fade_in = true
@onready var waiting = false
@export var wait_time : float = 1.5

func ready():
	%"Wait time".wait_time = wait_time

func _process(delta):
	if alpha <= 0.0 && waiting == false: 
		%"Wait time".start()
		waiting = true
	
	if alpha == 1 && fade_in == false: finish()
	
	if fade_in == true:
		alpha = move_toward(alpha, 0, fade_speed * delta)
	elif fade_in == false:
		alpha = move_toward(alpha, 1, fade_speed * delta)
	
	%Fade.set_color(Color(0,0,0,alpha))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):finish() ##skip intro


func _on_wait_time_timeout():
	fade_in = false
	waiting = false
	
func finish():
	var title_screen = load("res://GameObjects/Cutscenes/title_screen.tscn").instantiate()
	self.get_parent().add_child(title_screen)
	queue_free()
