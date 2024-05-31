extends Node2D

var old_state

func animation_finished():
	print("animation finished")
	if owner.animations.animation == "hit":
		print("hit finished")
		owner.state = old_state
