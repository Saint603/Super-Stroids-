extends Node2D

@onready var game = global.game
@onready var muzzle = %Muzzle

@onready var bullet = {
	"scene" : preload("res://GameObjects/Player/bullet.tscn"),
	"hue" : 0,
	"color" : Color.from_ok_hsl(0, 1, .36, 1),
	"sound":  preload("res://Audio/Sounds/Laser.wav"),
}
@onready var cooldown = {
	"node": %Cooldown,
	"on_cooldown": false,
	"time": 0.1,
}

func _ready():
	cooldown.node.wait_time = cooldown.time

func shoot():
	if cooldown.on_cooldown == true:
		return
	cooldown.on_cooldown = true
	
	var sound_instance = global.direct_audio.instantiate()
	add_child(sound_instance)
	sound_instance.play_sound(bullet.sound)
	
	cooldown.node.start()
	var bullet_instance = bullet.scene.instantiate()
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.global_rotation = muzzle.global_rotation
	bullet_instance.get_node("Bullet Sprite").color = bullet.color
	bullet_instance.get_node("Light").color = bullet.color
	global.game.temp_instances.add_child(bullet_instance)
	bullet.hue += 0.05
	if bullet.hue > 1:
		bullet.hue = 0
	bullet.color = Color.from_ok_hsl(bullet.hue, 1, .36, 1)

func _on_cooldown_timeout():
	cooldown.on_cooldown = false
