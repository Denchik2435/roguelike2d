extends State

var target: Node2D = null

func _ready() -> void:
	Eventbus.connect("player_dead", Callable(self, "stop_chase"))

func enter():
	target = actor.get_player()
	if target:
		actor.play_anim("chase")
		actor.play_sound("chase")

func chase():
	var direction = (target.global_position - actor.global_position).normalized()
	actor.velocity = direction * actor.speed
	actor.move_and_slide()
	
	if actor.velocity.x != 0:
		actor.face.scale.x = -1 if actor.velocity.x < 0 else 1

func physics_update(_delta):
	if target:
		chase()
	else:
		stop_chase()

func stop_chase():
	if actor is not Hero:
		actor.fsm.change_to("Idle")
		actor.audio.stop()
