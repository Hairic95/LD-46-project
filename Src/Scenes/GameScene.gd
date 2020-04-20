extends Node2D

var current_drag_character
var character_count = 4
var round_counter = 1
var round_start_timeout = 0.0
var sacrificed_character_names = []

func _ready():
	for c in $Characters.get_children():
		c.get_child(0).connect("is_being_dragged", self, "set_all_character_draggable")
		c.get_child(0).connect("is_put_on_fire", self, "on_character_on_fire")
		c.get_child(0).connect("is_sent_on_forest", self, "on_character_on_forest")
	BlackScreen.connect("before_background_invisible", self, "on_before_background_invisible")
	GLOBALS.connect("on_sacrifice_music", self, "is_sacrifice_music_playing")
	GLOBALS.connect("on_round_end", self, "on_round_end")
	GLOBALS.connect("on_game_over", self, "on_game_over")

func _process(delta):
	if round_start_timeout > 0.0:
		round_start_timeout -= delta
	else:
		GLOBALS.can_control = true

func is_sacrifice_music_playing(is_playing):
	if is_playing:
		$Music.stop()
	else:
		$Music.play()

func set_all_character_draggable(excluded_char, is_being_dragged):
	for c in $Characters.get_children():
		var character = c.get_child(0)
		if character != excluded_char:
			character.can_be_dragged = !is_being_dragged

func on_character_on_fire(character):
	print(character.character_name + " on fire")
	current_drag_character = character
	current_drag_character.sacrifice()
	GLOBALS.NOTIFICATIONS.notify("You sacrificed " + str(current_drag_character.character_name))
	$Campfire.update_fire(4)
	update_character_count(-1)
	sacrificed_character_names.push_back(current_drag_character.character_name)
	GLOBALS.emit_signal("on_sacrifice", current_drag_character)
	#GLOBALS.emit_signal("on_round_end")

func on_character_on_forest(character):
	randomize()
	
	for c in $Characters.get_children():
		c.get_child(0).can_be_dragged = false
	
	BlackScreen.fade_in_screen("WOOD" + str(randi()%10+1), [character.character_name])
	print(character.character_name + " on forest")
	current_drag_character = character
	
func on_before_background_invisible():
	if "WOOD" in BlackScreen.current_entity_name:
		print("reset after forest")
		
		var random_wood_index = (randi()%3+1)
		print(random_wood_index)
		GLOBALS.emit_signal("on_collect_wood", current_drag_character, random_wood_index - 1)
		
		var text = TEXT.get_text_entity("COLLECT" + str(random_wood_index))[0].text
		text = text.replace("{0}", current_drag_character.character_name)
		GLOBALS.NOTIFICATIONS.notify(text)
	
		GLOBALS.emit_signal("on_round_end")
		reset_characters()
	if "ENDING" in BlackScreen.current_entity_name:
		print("ended")
		get_node("/root").add_child(load("res://Src/Entities/End.tscn").instance())
		BlackScreen.reset()
		queue_free()
		
func reset_characters():
	for c in $Characters.get_children():
		c.get_child(0).return_to_start_pos()

func update_character_count(count):
	character_count += count
	
	if character_count < 1:
		GLOBALS.emit_signal("on_game_over")

func on_round_end():
	GLOBALS.emit_signal("update_fire", -1)
	
	if !GLOBALS.game_over:
		round_counter += 1
		GLOBALS.NOTIFICATIONS.notify("Hours passed: " + str(round_counter))
		GLOBALS.can_control = false
		round_start_timeout = 3.0
	
	for c in $Characters.get_children():
		c.get_child(0).return_to_start_pos()
		c.get_child(0).can_be_dragged = true

func on_game_over():
	$Music.stop()
	$Ambience.stop()
	for c in $Characters.get_children():
		c.queue_free()
	
	var ending_index = sacrificed_character_names.size() + 1
	
	if ending_index == 1:
		$Music.stream = load("res://Music/good_ending.ogg")
	else:
		$Music.stream = load("res://Music/bad_ending.ogg")
	$Music.play()
	BlackScreen.fade_in_gameover("ENDING" + str(ending_index), sacrificed_character_names)
	
