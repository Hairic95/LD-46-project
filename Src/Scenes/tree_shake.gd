extends Node2D

var start_time = rand_range(0.1, 3.0)

func _process(delta):
	start_time -= delta
	
	if start_time <= 0.0:
		$AnimationPlayer.play("shake", -1, rand_range(0.1, 0.75))
		set_process(false)
