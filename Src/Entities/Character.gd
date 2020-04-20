extends Node2D

export (String) var character_name = "Bob"
export (bool) var is_female = false
export (int) var sound_index = 1

var can_be_dragged : bool = true

var is_mouse_over : bool = false
var is_being_dragged : bool = false

var is_on_fire : bool = false
var is_on_forest : bool = false

var is_dead = false
var death_sound_played = false

signal is_being_dragged(self_instance, bool_value)

signal is_put_on_fire(self_instance)
signal is_sent_on_forest(self_instance)

var MUMBLE_LOWER_CAP = 5.0
var MUBMLE_UPPER_CAP = 20.0
var next_mumble_timeout = rand_range(MUMBLE_LOWER_CAP, MUBMLE_UPPER_CAP)

func _ready():
	$Sprite.material = $Sprite.material.duplicate(true)
	$Scream.connect("finished", self, "on_scream_finished")
	set_sprite(false)

func set_sprite(is_dragging):
	if is_dragging:
		$Sprite.texture = load(str("res://Textures/char_dragged_", character_name.to_lower(), ".png"))
	else:
		$Sprite.texture = load(str("res://Textures/char_idle_", character_name.to_lower(), ".png"))
		
func _process(delta):
	#next_mumble_timeout -= delta
	
	#if next_mumble_timeout <= 0.0:
		#play_mumble()
		#next_mumble_timeout = rand_range(MUMBLE_LOWER_CAP, MUBMLE_UPPER_CAP)
		pass
	
func _physics_process(delta):
	if can_be_dragged:
		if is_being_dragged and global_position != get_global_mouse_position():
			if get_tree().get_root().get_visible_rect().has_point(get_global_mouse_position()):
				global_position = lerp(global_position, get_global_mouse_position(), 15.0 * delta)
			else:
				return_to_start_pos()
				is_being_dragged = false
				emit_signal("is_being_dragged", self, false)
	if is_dead and death_sound_played:
		get_parent().queue_free()

func _input(ev):
	if !GLOBALS.can_control: return
	
	if ev is InputEventMouseButton:
		if can_be_dragged:
			if is_mouse_over and ev.button_index == BUTTON_LEFT:
				if ev.pressed:
					play_mumble()
					$Tween.stop(self)
					is_being_dragged = true
					emit_signal("is_being_dragged", self, true)
					$AnimationPlayer.play("on_start_drag")
					set_sprite(true)
				else:
					is_being_dragged = false
					if is_on_fire:
						emit_signal("is_put_on_fire", self)
					if is_on_forest:
						emit_signal("is_sent_on_forest", self)
					if !is_on_fire and !is_on_forest:
						return_to_start_pos()
					emit_signal("is_being_dragged", self, false)

func _on_MouseArea_mouse_entered():
	is_mouse_over = true

func _on_MouseArea_mouse_exited():
	is_mouse_over = false

func _on_CheckArea_area_entered(area):
	if area.is_in_group("Campfire"):
		$SacrificeMusic.volume_db = 5.0
		GLOBALS.emit_signal("on_sacrifice_music", true)
		is_on_fire = true
	if area.is_in_group("Forest"):
		is_on_forest = true

func _on_CheckArea_area_exited(area):
	if area.is_in_group("Campfire"):
		$SacrificeMusic.volume_db = -100
		GLOBALS.emit_signal("on_sacrifice_music", false)
		is_on_fire = false
	if area.is_in_group("Forest"):
		is_on_forest = false

func return_to_start_pos():
	$Tween.interpolate_property(self, "position", get_position(), Vector2(0, 0), 2.0, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()
	set_sprite(false)

func show_overlay_color(show):
	if show:
		$Sprite.material.set_shader_param("overlay_color", Color(100.0, 100.0, 100.0, 1.0))
	else:
		$Sprite.material.set_shader_param("overlay_color", Color(1.0, 1.0, 1.0, 1.0))

func sacrifice():
	if is_female:
		$Scream.stream = load("res://SoundEffects/Screams/female_" + str(sound_index) + "-scream_" + str(randi()%4+1) + ".wav")
	else:
		if sound_index == 1:
			$Scream.stream = load("res://SoundEffects/Screams/male_" + str(sound_index) + "-scream_" + str(randi()%4+1) + ".wav")
		else:
			$Scream.stream = load("res://SoundEffects/Screams/male_2-scream_1.wav")
	$Sizzle.stream = load("res://SoundEffects/Sizzle/sizzle-0" + str(randi()%3+1) + ".ogg")
	$Sizzle.play()
	$Scream.play()
	$AnimationPlayer.play("sacrifice")

func on_scream_finished():
	death_sound_played = true

func play_mumble():
	if is_female:
		$Mumble.stream = load("res://SoundEffects/Mumbles/female_" + str(sound_index) + "-mumble_" + str(randi()%4+1) + ".wav")
	else:
		if sound_index == 1:
			$Mumble.stream = load("res://SoundEffects/Mumbles/male_" + str(sound_index) + "-mumble_" + str(randi()%4+1) + ".wav")
		else:
			$Mumble.stream = load("res://SoundEffects/Mumbles/male_" + str(sound_index) + "-mumble_" + str(randi()%6+1) + ".wav")
	$Mumble.play()
