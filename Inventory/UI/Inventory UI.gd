extends Control

@onready var inv = preload("res://Inventory/player_inventory.tres")
@onready var slots = %GridContainer.get_children()

var is_open = false

func _ready():
	global.inventory_ui = self

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
		
func close():
	visible = false
	is_open = false

func open():
	visible = true
	is_open = true
