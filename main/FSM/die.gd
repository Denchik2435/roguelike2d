extends State

func enter():
	
	actor.anim.connect("frame_changed", Callable(self, "sound"))
	actor.velocity = Vector2.ZERO
	actor.disable()
	
	actor.anim.play("die")
	await actor.anim.animation_finished
	
	if actor is Hero:
		Global.emit_signal("player_dead")
	
	delete_actor()


func sound():
	if actor.anim.frame == actor.die_frame:
		actor.shadow.hide()
		actor.play_sound("die", 10)


func delete_actor():
	actor.queue_free()
	actor.audio.stop()
	


func exit():
	actor.anim.disconnect("frame_changed", Callable(self, "sound"))
