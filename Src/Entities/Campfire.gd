extends Node2D

var fire_hp = 5

func update_fire(new_hp):
	fire_hp = new_hp
	
	if fire_hp > 5:
		fire_hp = 5
	
	$FIRE.scale = Vector2(new_hp * 0.25, new_hp * 0.25)
	
	if fire_hp > 2.0:
		$AudioStreamPlayer.stream = load("res://SoundEffects/Fire/large-fire-loop.ogg")
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stream = load("res://SoundEffects/Fire/large-fire-loop.ogg")
		$AudioStreamPlayer.play()
	
	$AnimationPlayer.play("fire_hp")
	$FlareUp.play()
	
	if fire_hp <= 0.0:
		# TODO: extinguish effect
		# TODO: darkness
		
		# game over
		GLOBALS.emit_signal("on_game_over")

func _ready():
	$FIRE/Sprite/Anim.play("Fire")
	GLOBALS.connect("update_fire", self, "do_update_fire")
	update_fire(3)

func do_update_fire(amount):
	update_fire(fire_hp + amount)

func show_label():
	$CanvasLayer/Label.text = str(fire_hp)
