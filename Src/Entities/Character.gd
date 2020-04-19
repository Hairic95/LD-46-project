extends Node2D

export (String) var character_name = "Bob"

var can_be_dragged : bool = true

var is_mouse_over : bool = false
var is_being_dragged : bool = false

var is_on_fire : bool = false
var is_on_forest : bool = false

signal is_being_dragged(self_instance, bool_value)

signal is_put_on_fire(self_instance)
signal is_sent_on_forest(self_instance)

func _ready():
	$Sprite.texture = load(str("res://Textures/char_idle_", character_name.to_lower(), ".png"))

func _physics_process(delta):
	if can_be_dragged:
		if is_being_dragged and global_position != get_global_mouse_position():
			if get_tree().get_root().get_visible_rect().has_point(get_global_mouse_position()):
				global_position = get_global_mouse_position()
			else:
				return_to_start_pos()
				is_being_dragged = false
				emit_signal("is_being_dragged", self, false)

func _input(ev):
	if ev is InputEventMouseButton:
		if can_be_dragged:
			if is_mouse_over and ev.button_index == BUTTON_LEFT:
				if ev.pressed:
					$Tween.stop(self)
					is_being_dragged = true
					emit_signal("is_being_dragged", self, true)
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
		is_on_fire = true
	if area.is_in_group("Forest"):
		is_on_forest = true
		BlackScreen.fade_in_screen("WOOD1", character_name)
	print(area.get_groups())


func _on_CheckArea_area_exited(area):
	if area.is_in_group("Campfire"):
		is_on_fire = false
	if area.is_in_group("Forest"):
		is_on_forest = false
	print(area.get_groups())

func return_to_start_pos():
	$Tween.interpolate_property(self, "position", get_position(), Vector2(0, 0), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
