extends Node2D
	
var current_level = {
	"instance" : null,
	"node" : preload("res://GameObjects/Levels/level_1_1.tscn"),
	"in_transition" : false,
	"string" : "res://GameObjects/Levels/level_1_1.tscn",
	"x" : 1,
	"y" : 1,
	"id" : "1_1"
}

var world_boundries = {
	"x": 2,
	"y": 2,
}

@onready var time = 0
@onready var score = 0
@onready var temp_instances = %"Temp Instances"
@onready var ui_layer = %"UI Layer"
@onready var menu_layer = %"Menu Layer"
@onready var game_layer = %"Game Layer"
@onready var music_player = %Music
@onready var game_timer = %"Game Timer"
@onready var asteroid_instance = (load("res://GameObjects/Asteroids/asteroid.tscn") as PackedScene)

func _ready():
	global.game = self
	
func start():
		create_level(1,1)
		var player_instance = load("res://GameObjects/Player/player.tscn").instantiate()
		game_layer.add_child(player_instance)
		
		var interaction_manager = load("res://GameObjects/Utilities/Interactable/interaction_manager.tscn").instantiate()
		self.add_child(interaction_manager)
		global.interaction_manager = interaction_manager
		ui_layer.visible = true
		music_player.play()
		game_timer.start()
		

func restart(): ##probably depricated. Needs rewritten
	time = 0
	score = 0
	var player_instance = load("res://GameObjects/Player/player.tscn").instantiate()
	call_deferred("add_child",player_instance)	
	create_level(1,1)
	global.save_data_table = [] ##empty the fudge
	Dialogic.VAR.reset()
	
func change_scene(direction): ##direction is direction we're COMING FROM. Like, the ship left the last zone going north
	if current_level.in_transition == true:
		return ##exit function if we are already in the middle of changing the scene
	current_level.in_transition = true
	
	if direction == "North":
		update_current_level(current_level.x, current_level.y - 1)
		global.player.global_position.y = self.get_viewport().size.y + 50
	elif direction == "South":
		update_current_level(current_level.x, current_level.y + 1)
		global.player.global_position.y = 0
	elif direction == "East":
		update_current_level(current_level.x + 1, current_level.y)
		global.player.global_position.x = 0
	elif direction == "West":
		update_current_level(current_level.x - 1, current_level.y)
		global.player.global_position.x = self.get_viewport().size.x + 50
		
	global.player.global_position.x = clamp(global.player.global_position.x, -10, self.get_viewport().size.x + 10) 
	global.player.global_position.y = clamp(global.player.global_position.y, -10, self.get_viewport().size.y + 10)
	

func update_current_level(x,y):	
	fudge_packer() ##ALL HAIL THE PACKER
	current_level.instance.queue_free() ##clean out the level and the things that it spawned
	empty_temp_instances()
		
	if x < 0:
		x = world_boundries.x
	elif x > world_boundries.x:
		x = 0
	if y < 0:
		y = world_boundries.y
	elif y > world_boundries.y:
		y = 0
			
	create_level(x,y)
	fudge_unpacker() ##ALL HAIL THE UNPACKER
	
func update_current_level_special(level):
	fudge_packer() ##ALL HAIL THE PACKER
	if current_level.in_transition == true:
		return ##exit function if we are already in the middle of changing the scene
	
	fudge_packer() ##ALL HAIL THE PACKER
	current_level.in_transition = true
	current_level.instance.queue_free() ##clean out the level and the things that it spawned
	empty_temp_instances()
	create_level(-1,-1, level)
	fudge_unpacker()

func create_level(x,y,level_id: String = ""): ##called by update current level functions. Use those instead!
	current_level.x = x
	current_level.y = y
	if level_id.is_empty(): current_level.id = str(x) + "_" + str(y)
	else: current_level.id = level_id
	current_level.string = "res://GameObjects/Levels/level_" + current_level.id + ".tscn"
	if ResourceLoader.exists(current_level.string) == false:
		print("Error: No level at path: " + current_level.string)
		return
		
	current_level.instance = load(current_level.string).instantiate()
	self.add_child(current_level.instance)
	%"Level Transition Delay".start()

func empty_temp_instances():
	for i in self.temp_instances.get_children():
		self.temp_instances.remove_child(i)
		i.queue_free()
		
##signal area
func _on_level_transition_delay_timeout():
	current_level.in_transition = false
	
func _on_game_time_timeout():
	time += 1
	global.player_ui.update()
	
func _notification(what): ##notification handler thing. Just quits the game and deletes run time levels right now.
	if what == NOTIFICATION_WM_CLOSE_REQUEST: ##windows quit request
		get_tree().quit() # default behavior

##############################################################################################
##I should explain myself on the off chance someone has to read this.
##Half of the code is just this : https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
##That half of the code takes all nodes listed as "Persist", calls their save function, and makes that info into a json string
##The second half takes that information and stores it into the global variable "save_data_table"
##The code is split into two functions.
##	Fudge packer is a pseudo save scene function
##	Fudge unpacker is a pseduo load scene function

func fudge_packer(): 
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var save_data = {
	"level_id" : "",
	"json_string" : "Blank"
	}
	
	save_data.level_id = current_level.id
	
	##delete old level data
	var old_data = []
	for i in global.save_data_table:
		if i.level_id == save_data.level_id: old_data.append(i)
	for i in old_data:
		global.save_data_table.erase(i)
		
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)
		save_data.json_string = json_string
		global.save_data_table.append(save_data.duplicate())
		
	##fudge_debugger()


func fudge_unpacker():
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	if global.save_data_table.find(current_level.id) == 0: ##no save data
		return

	for i in save_nodes:
		i.queue_free()

	for j in global.save_data_table:
		
		if j.level_id != current_level.id:
			##print("Element not a part of current level, skipping....")
			continue
		var json_string = j.json_string

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.get_data()

		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		##print("loading " + node_data["filename"] + " with parent " + node_data["parent"])
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
			
		if new_object.has_method("on_load"): ##call function's on load method
			new_object.on_load()
	print("Done Loading!\n")

func fudge_debugger():
	for i in global.save_data_table:
		print("LevelID: " + i.level_id + " Info: " + i.json_string +"\n")
	print("\n")

####################################################################################################
