extends State

func enter(msg = {}):
	if actor.has_method("take_damage"):
		actor.take_damage()
