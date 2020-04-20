extends Node

# This file stores globally accessible variables and methods

var game_started = false
var can_control = true
var game_over = false

# The node of current GameScene.tscn
var game_scene
var tv_screen

# round notifier
var NOTIFICATIONS

signal game_over
signal on_collect_wood(character, amount)
signal on_dispense_wood(amount)
signal update_fire(amount)
signal on_sacrifice_music(is_playing)
signal on_sacrifice(character)
signal on_game_over
signal on_round_end

func start_game():
	GLOBALS.game_scene = load("res://Src/Scenes/GameScene.tscn").instance()
	get_node("/root").add_child(GLOBALS.game_scene)
	GLOBALS.game_started = true

func restart_game():
	can_control = true
	game_over = false
	game_started = false
	if is_instance_valid(game_scene):
		game_scene.queue_free()
	BlackScreen.reset()
	tv_screen.fade_out()
	start_game()
