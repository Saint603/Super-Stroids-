extends Node

func _ready():
	if Dialogic.VAR.intro_dialog == false && Dialogic.current_timeline == null: ##check to see if a dialog is already playing and if the level flag is deleted
		Dialogic.start("test time line")

	
