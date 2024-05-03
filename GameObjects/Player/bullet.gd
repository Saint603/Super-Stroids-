extends Area2D
var travelled_distance = 0
const SPEED = 1000
const LIFETIME = 1200

func _physics_process(delta):
	
	var direction = Vector2.UP.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > LIFETIME:
		queue_free() ##destroys object
		

func _process(_delta):
	global.check_off_screen(self, 1)




func _on_body_entered(body):
	queue_free() ##has one frame buffer, allowing for code after
	if body.has_method("take_damage"): ##check to see if overlapping body has "take_damage" function
		body.take_damage()
