extends State


func enter():
	
	actor.anim.connect("frame_changed", Callable(self, "sound"))
	actor.velocity = Vector2.ZERO
	actor.disable()
	
	if actor is Hero:
		Eventbus.emit_signal("player_dead")
		Global.hp = 0
		
	actor.anim.play("die")
	await actor.anim.animation_finished
	delete_actor()


func sound():
	if actor.anim.frame == actor.die_frame:
		actor.play_sound("die", 25)


func delete_actor():
	actor.queue_free()
	actor.audio.stop()


func exit():
	actor.anim.disconnect("frame_changed", Callable(self, "sound"))
