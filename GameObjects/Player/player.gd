##MOVEMENT BUGS
##weird drift needs to go

extends CharacterBody2D
class_name Player

signal bullet_shot(bullet)


@export var health = {
	"starting" : 100.0,
	"max" : 100.0,
	"current": 100.0,
}

@export var shield = {
	"acquired" : false,
	"current" : 0,
	"max" : 4,
	"cooldown" : 2.0,
}

@export var speed = {
	"current" : 0,
	"default" : 800,
	"max" : 5000,
	"ABSOLUTE_MAX" : 10000,
	"deceleration" : 10,
	"acceleration" : 5.0,
	"dirVec" : Vector2(0,0),
}

@export var rotation_speed = {
	"current" : 1.5,
	"default" : 0.5,
	"max" : 1,
	"ABSOLUTE_MAX" : 2,
	"dirVec" : Vector2(0,0)
}

@export var inv: = Inv

@onready var weapon = %Weapon
@onready var camera_view = %SubViewport
@onready var shield_collision = %"Shield Collision"
@onready var shield_cool_down = %"Shield Cool Down"

func _ready():
	shield_cool_down.wait_time = shield.cooldown
	if shield.acquired == false : 
		disable_shield()
		global.player_ui.shield_bar.visible = false
	health.current = health.starting
	global.player = self
	
func _physics_process(delta):
	get_input()
	rotation += rotation_speed.direction * rotation_speed.current * delta
	move_and_slide()


##try this next https://www.reddit.com/r/godot/comments/wtl17d/40_how_do_i_add_acceleration_deceleration_to_the/
func get_input():
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
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
	if shield.acquired and shield.current > 0:
		shield.current -= 1
		shield_cool_down.stop()
		shield_cool_down.start(shield.cooldown)
	else:
		health.current -= damage
	global.player_ui.update()
	if health.current == 0: die()
	
func die():
	var game_over_screen = load("res://GameObjects/Cutscenes/game_over.tscn").instantiate()
	global.game.ui_layer.add_child(game_over_screen)
	queue_free()

func disable_shield():
	%"Shield Collision".disabled = true
	$"Shield Sprite".visible = false

func enable_shield():
	%"Shield Collision".disabled = false
	$"Shield Sprite".visible = true


func _on_shield_cool_down_timeout():
	if shield.acquired == true and shield.current < 4: 
		shield.current += 1
		global.player_ui.update()
