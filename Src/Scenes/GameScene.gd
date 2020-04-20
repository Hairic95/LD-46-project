extends Node2D

var current_drag_character
var character_count = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in $Characters.get_children():
		c.get_child(0).connect("is_being_dragged", self, "set_all_character_draggable")
		c.get_child(0).connect("is_put_on_fire", self, "on_character_on_fire")
		c.get_child(0).connect("is_sent_on_forest", self, "on_character_on_forest")
	BlackScreen.connect("before_background_invisible", self, "on_before_background_invisible")

func set_all_character_draggable(excluded_char, is_being_dragged):
	for c in $Characters.get_children():
		var character = c.get_child(0)
		if character != excluded_char:
			character.can_be_dragged = !is_being_dragged

func on_character_on_fire(character):
	print(character.character_name + " on fire")
	current_drag_character = character
	current_drag_character.sacrifice()
	$Campfire.update_fire(4)
	update_character_count(-1)
	
func on_character_on_forest(character):
	randomize()
	BlackScreen.fade_in_screen("WOOD" + str(randi()%11+1), [character.character_name])
	print(character.character_name + " on forest")
	current_drag_character = character
	
func on_before_background_invisible():
	if "WOOD" in BlackScreen.current_entity_name:
		print("reset after forest")
		# TODO: add logic for wood collect probability
		GLOBALS.emit_signal("on_collect_wood", current_drag_character, 1)
	
	reset_characters()
		
func reset_characters():
	for c in $Characters.get_children():
		c.get_child(0).return_to_start_pos()

func update_character_count(count):
	character_count += count
	
	# TODO: if below 1, gameover
