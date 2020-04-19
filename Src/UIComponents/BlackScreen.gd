extends CanvasLayer

# The BlackScreen.tscn is the screen that displays text.
# The text comes from the file Src/Text/game_text_en.json.
# Each entry in that file has following structure: { "NAME": "text1;time|hello world;2.0" }
# It will be parsed into an array of these objects: { text = "hello world", time = 2.0 }

# The fade-in will take the entity, display its text and then attempt to look after
# the next entity in the array of text-entities. If there is another one, it will
# fadeout the current text and then fade in the next. This goes on for as long as
# there are items in the array. Once that's done, the background will be set invisible
# and will emit signals, so other parts of the game can take control from there.

# For questions: @November_Dev

var current_entity_name : String
var current_text_entites
var current_text_entity
var current_timer = 0.0
var current_character_name = "Bob"

# Signal when the fade-in/-out starts
signal on_background_fade_in
signal on_background_fade_out

# Signal if the background just blocked everything "behind" it (after it faded in to 100%)
# Signal if the background just became invisible
signal on_background_visible
signal on_background_invisible
signal before_background_invisible

# Signal if the TEXT entity changed -
# ideal to run preparation actions behind the black screen
signal on_text_changed

# MAIN FUNCTION FOR DISPLAYING TEXT
# Displays the black-screen with text from the entity by entity_name
func fade_in_screen(entity_name, character_name = ""):
	set_text_entity(entity_name)
	current_character_name = character_name;
	handle_background_visibility(true)

func _process(delta):
	# Hides or switches current text after the seconds 
	# supplied by the text_entity
	if current_timer > 0.0:
		current_timer -= delta
		
		if current_timer <= 0.0:
			set_next_text()

func handle_background_visibility(backgroundVisible):
	if backgroundVisible:
		$AnimationPlayer.play("fade-in")
		emit_signal("on_background_fade_in")
	else:
		$AnimationPlayer.play("fade-out")
		emit_signal("on_background_fade_out")

func set_text_entity(entity_name):
	current_entity_name = entity_name
	current_text_entites = TEXT.get_text_entity(current_entity_name)
	set_next_text(true)
	
func emit_text_changed():
	emit_signal("on_text_changed", current_entity_name)

# Takes the next text_entity and reads its display time and text to the label and timer
func set_next_text(is_initial = false):
	# we have no further entities to process, hide the screen
	if current_text_entites.size() < 1:
		handle_background_visibility(false)
	else:
		current_text_entity = current_text_entites.pop_front()
		if !is_initial:
			$AnimationPlayer.play("fade-switch-text")

func display_text_entity():
	current_timer = current_text_entity.time
	var text_to_set = current_text_entity.text
	print(current_character_name)
	text_to_set = text_to_set.replace("%", current_character_name)
	print(text_to_set)
	$Background/TextBox.bbcode_text = "[center]" + text_to_set + "[/center]"
