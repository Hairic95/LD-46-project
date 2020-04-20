extends Node

# This file stores globally accessible variables and methods

var menu_visible = true
var game_started = false
var can_control = true
var game_over = false

# The node of current GameScene.tscn
var game_scene

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
