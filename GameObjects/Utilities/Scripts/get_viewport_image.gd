extends SubViewport ##change this line depending on the node you attach to 

func _ready():
	await get_tree().create_timer(0.5).timeout
	var img = %SubViewport.get_viewport().get_texture().get_image()
	var image_path = "res://Sprites/General/Screen Shots/newestSnapshot.png"
	img.save_png(image_path)
	
