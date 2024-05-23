extends RigidBody2D

@onready var instance = global.game.asteroid_instance
@onready var temp_position = self.global_position

@export var health: float
@export var splits: int
@export var damage: float 
@export var asteroid_scale: float = 1

var drop = preload("res://GameObjects/Coin/coin.tscn")

var asteroid_sounds = ["res://Audio/Sounds/Asteroid Sounds/Asteroid_Sound_1.wav", 
					"res://Audio/Sounds/Asteroid Sounds/Asteroid_Sound_2.wav", 
					"res://Audio/Sounds/Asteroid Sounds/Asteroid_Sound_3.wav",
					"res://Audio/Sounds/Asteroid Sounds/Asteroid_Sound_4.wav",
					"res://Audio/Sounds/Asteroid Sounds/Asteroid_Sound_5.wav"]
func _ready():
	%Sprite2D.scale = Vector2(asteroid_scale, asteroid_scale)
	%"Hit Box".scale = Vector2(asteroid_scale,asteroid_scale)
	%Area2D.scale = Vector2(asteroid_scale, asteroid_scale)
	self.add_to_group("Persist")

func _process(_delta):
	global.check_off_screen(self, 1)
	
func take_damage():
	health -= 1
	if health == 0:
		if splits == 0 and randi_range(0,2) == 2:
			var drop_instance = drop.instantiate()
			drop_instance.global_position = self.global_position
			get_parent().call_deferred("add_child", drop_instance)
		for i in splits:
			var temp_instance = instance.instantiate()
			temp_position = self.global_position + Vector2(randf_range(-50,50),(randf_range(-50,50))) 
			temp_instance.initialize(temp_position, 0.3, 0, 5, 5)
			get_parent().call_deferred("add_child", temp_instance)
		
		global.game.score += 1
		global.player_ui.update()
		var dying_noise = (asteroid_sounds.pick_random())
		global.add_sound(self.global_position, dying_noise, 0, 10)
		self.queue_free()

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		print("sending hit!")

func initialize(new_position: Vector2 = self.position, new_scale: float = 1.0, new_splits: int = 1, new_health: float = 10.0, new_damage: float = 10.0):
	self.position = new_position
	self.asteroid_scale = new_scale
	self.splits = new_splits
	self.health = new_health
	self.rotation_degrees = randi_range(0,360)
	self.damage = new_damage
	

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"health" : health,
		"splits" : splits,
		"asteroid_scale" : asteroid_scale,
		"level" : global.game.current_level.string
	}
	return save_dict
	
func on_load():
	%Sprite2D.scale = Vector2(asteroid_scale, asteroid_scale)
	%"Hit Box".scale = Vector2(asteroid_scale,asteroid_scale)
	%Area2D.scale = Vector2(asteroid_scale, asteroid_scale)
	
