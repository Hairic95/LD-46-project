extends Node2D

var restart_timeout = 8.0

func _ready():
	GLOBALS.tv_screen = self
	$AnimationPlayer.play("start")

func _process(delta):
	restart_timeout -= delta
	if restart_timeout <= 0.0:
		# reload level: GLOBALS.restart_game()
		
		# to reload page:
		JavaScript.eval("window.location.reload()")
		set_process(false)

func fade_out():
	$AnimationPlayer.play("fade_out")
