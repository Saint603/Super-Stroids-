extends Node2D

@export var light_color : Color
@export var sprite : Sprite2D
@export var intensity : float = 1
@export var radius : float = 1

func _ready():
	if light_color:
		%PointLight2D.set_color(light_color)
	else:
		%PointLight2D.set_color(Color.WHITE)
		
	if sprite:
		%Sprite2D.set_texture(sprite)
	else:
		%Sprite2D.set_texture(load("res://Sprites/Props/Star.png"))
	
	if intensity:
		%PointLight2D.energy = intensity
	else:
		%PointLight2D.energy = 1
	if radius:
		%PointLight2D.texture_scale = radius
	else:
		%PointLight2D.texture_scale = 1
