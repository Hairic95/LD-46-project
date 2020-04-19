extends Node

# Provides all text for the application
# For questions: @November_Dev

var TEXT_CONTENTS = {}
var DEFAULT_TEXT_DISPLAY_TIME = 2.0

func _ready():
	# load the json file that stores all text for the game
	var file = File.new()
	
	if file.open("res://Src/Text/game_text_en.json", file.READ) == 0:
		self.TEXT_CONTENTS = JSON.parse(file.get_as_text()).result
	else:
		print("ERROR - game_text_en.json could not be read")
		
# Gets the string value of the text, no formatting of ; or | applied
func get_str(string_name : String):
	string_name = string_name.to_upper()
	if TEXT_CONTENTS.has(string_name):
		return TEXT_CONTENTS[string_name]
	else:
		print("ERROR - " + string_name + " not found in game_text_en.json")

# Gets the object value of the text:
# Array of 
# { text = "asd", time = 2.0 }
func get_text_entity(string_name : String):
	var text = get_str(string_name)
	
	var entities = text.split('|')
	var text_entities = []
	
	for entity in entities:
		# if there is a semicolon in the text
		if ";" in entity:
			# parse it into this structure
			text_entities.push_back({
				text = entity.split(';')[0],
				time = float(entity.split(';')[1])
			})
		else:
			# else, just take the text and default time
			text_entities.push_back({
				text = entity,
				time = DEFAULT_TEXT_DISPLAY_TIME
			})
	
	return text_entities
