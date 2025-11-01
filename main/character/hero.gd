extends CharacterBody2D

var speed = Global.speed

enum State { MOVE, ATTACK, DEAD }
var animation = ["idle", "attack"]
var current_state: State = State.MOVE
var current_animation: String

func _ready() -> void:
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _change_state(_state: State) -> void:
	if current_state != _state:
		current_state = _state

func _play_anim(_name: String) -> void:
	if current_animation != _name:
		$AnimatedSprite2D.play(_name)
		current_animation = _name

func _stop_anim() -> void:
	$AnimatedSprite2D.stop()

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1

	# --- атака ---
	if Input.is_action_just_pressed("mouse_0") and current_state != State.ATTACK:
		attack()

	# --- движение ---
	input_dir = input_dir.normalized()
	velocity = input_dir * speed
	move_and_slide()

	# --- анимации ---
	if current_state != State.ATTACK:
		if velocity.length() > 0:
			_play_anim(animation[0])
		else:
			_play_anim("idle")

	# --- переворот спрайта ---
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func attack():
	_change_state(State.ATTACK)
	_play_anim(animation[1])

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		_change_state(State.MOVE)
