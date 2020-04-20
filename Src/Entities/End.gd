extends Node2D

var restart_timeout = 8.0

func _ready():
	GLOBALS.tv_screen = self
	$AnimationPlayer.play("start")

func _process(delta):
	restart_timeout -= delta
	if restart_timeout <= 0.0:
		GLOBALS.restart_game()

func fade_out():
	$AnimationPlayer.play("fade_out")
