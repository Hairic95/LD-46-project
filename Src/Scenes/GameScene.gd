extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for c in $Characters.get_children():
		c.get_child(0).connect("is_being_dragged", self, "set_all_character_draggable")


func set_all_character_draggable(excluded_char, is_being_dragged):
	for c in $Characters.get_children():
		var character = c.get_child(0)
		if character != excluded_char:
			character.can_be_dragged = !is_being_dragged

