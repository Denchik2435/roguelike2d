extends State

@onready var player = false


func enter():
	if actor.is_in_group("player"):
		player = true

	if actor.has_method("take_damage"):
		actor.play_anim("damage", attack_finished)
		actor.play_sound("damage")


func attack_finished():
	actor.to_default_state()
