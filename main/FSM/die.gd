extends State

func enter(msg = {}):
	
	actor.velocity = Vector2.ZERO

	if actor.has_method("die"):
		actor.die()
