extends Node

# This file stores globally accessible variables and methods

var menu_visible = true
var game_started = false

# The node of current GameScene.tscn
var game_scene

signal game_over
signal on_collect_wood(character, amount)
