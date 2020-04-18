extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	#These are for testing. Remove once implemented in the game loop.
	set_story_text("Test")
	handle_background_visibility(true)
	
func handle_background_visibility(backgroundVisible):
	if(backgroundVisible):
		$Tween.interpolate_property($Background, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	else:
		$Tween.interpolate_property($Background, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1)
		
	$Tween.start()

func set_story_text(storyText):
	$Background/TextBox.bbcode_text = "[center]" + storyText + "[/center]"
