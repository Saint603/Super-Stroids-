##MOVEMENT BUGS
##weird fucking drift needs to go

extends CharacterBody2D

signal bullet_shot(bullet)

var health = {
	"starting" : 100.0,
	"max" : 100.0,
	"current": 100.0,
}

var speed = {
	"current" : 0,
	"default" : 800,
	"max" : 5000,
	"ABSOLUTE_MAX" : 10000,
	"deceleration" : 10,
	"acceleration" : 5.0,
	"dirVec" : Vector2(0,0),
}

var rotation_speed = {
	"current" : 1.5,
	"default" : 0.5,
	"max" : 1,
	"ABSOLUTE_MAX" : 2,
	"dirVec" : Vector2(0,0)
}

@export var inv: = Inv
@onready var weapon = %Weapon
@onready var camera_view = %SubViewport

func _ready():
	health.current = health.starting
	global.player = self
	
func _physics_process(delta):
	get_input()
	rotation += rotation_speed.direction * rotation_speed.current * delta
	move_and_slide()


##try this next https://www.reddit.com/r/godot/comments/wtl17d/40_how_do_i_add_acceleration_deceleration_to_the/
func get_input():
	##tilt ship in 3d
	if Input.is_action_pressed("move_left"):
		%ship.global_rotation.x = move_toward(%ship.global_rotation.x, -PI/4, 0.1)
	elif Input.is_action_pressed("move_right"):
		%ship.global_rotation.x = move_toward(%ship.global_rotation.x, PI/4, 0.1)
	else:
		%ship.global_rotation.x = move_toward(%ship.global_rotation.x, 0, 0.05)
	
	##begin actual movement	
	if Input.get_vector("move_left", "move_right","move_up","move_down"):
		speed.dirVec = (transform.x * Input.get_axis("move_left", "move_right")) + (transform.y * Input.get_axis("move_up", "move_down")) ##line is bugged. X and Y need broken apart. but close!
		if (velocity.x / speed.dirVec.x) < 0:
			velocity.x = move_toward(velocity.x, speed.dirVec.x * speed.max, speed.acceleration + speed.deceleration)
		else: 
			velocity.x = move_toward(velocity.x, speed.dirVec.x * speed.max, speed.acceleration)
			
		if (velocity.y / speed.dirVec.y) <0:
			velocity.y = move_toward(velocity.y, speed.dirVec.y * speed.max, speed.acceleration + speed.deceleration)
		else:
			velocity.y = move_toward(velocity.y, speed.dirVec.y * speed.max, speed.acceleration)
			
	else: ##no directional input
		speed.dirVec = Vector2(0,0)
		velocity.x = move_toward(velocity.x, 0, speed.deceleration)
		velocity.y = move_toward(velocity.y, 0, speed.deceleration)
	
	velocity.normalized()
	rotation_speed.direction = Input.get_axis("tilt_left", "tilt_right")
	##end actual movement
	
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
	
	if Input.is_action_just_pressed("inventory"):
		if global.inventory_ui.is_open:
			global.inventory_ui.close()
		else:
			global.inventory_ui.open()
		

func take_damage(damage):
	health.current -= damage
	global.player_ui.update()
	if health.current == 0: die()
	
func die():
	var game_over_screen = load("res://GameObjects/Cutscenes/game_over.tscn").instantiate()
	global.game.ui_layer.add_child(game_over_screen)
	queue_free()
	
