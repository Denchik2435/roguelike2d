extends CharacterBody2D

var speed = Global.speed
@onready var shoot_point = $Node2D/Marker2D
@export var projectile_scene: PackedScene
var attack_frame_to_shoot = 8

enum State { MOVE, ATTACK, DIE, DAMAGE }
var animation = ["idle", "attack", "die", "damage"]
var current_state: State = State.MOVE
var current_animation: String

func _ready() -> void:
	add_to_group("player")

func _change_state(_state: State) -> void:
	if current_state != _state:
		current_state = _state

func _play_anim(_name: String) -> void:
	if current_animation != _name:
		$Node2D/AnimatedSprite2D.play(_name)
		current_animation = _name

func _stop_anim() -> void:
	$Node2D/AnimatedSprite2D.stop()

func _physics_process(delta: float) -> void:
	if current_state == State.DIE:
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

	if velocity.x != 0:
		$Node2D.scale.x = -1 if velocity.x < 0 else 1

func shoot():
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = shoot_point.global_position

	# --- считаем направление до мышки ---
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - shoot_point.global_position).normalized()

	projectile.direction = dir
	projectile.rotation = dir.angle()
	shoot_flash()

func attack():
	_change_state(State.ATTACK)
	_play_anim(animation[1])

func _on_animated_sprite_2d_animation_finished() -> void:
	if $Node2D/AnimatedSprite2D.animation == "attack":
		_change_state(State.MOVE)

func _on_animated_sprite_2d_frame_changed() -> void:
	if $Node2D/AnimatedSprite2D.animation == "attack" and $Node2D/AnimatedSprite2D.frame == attack_frame_to_shoot:
		shoot()
		print("shot")

func shoot_flash():
	$Node2D/Marker2D/PointLight2D.visible = true
	await get_tree().create_timer(0.1).timeout
	$Node2D/Marker2D/PointLight2D.visible = false

func take_damage_mob(amount):
	if current_state == State.DIE:
		return

	current_state = State.DAMAGE
	Global.hp -= amount
	print("My HP:", Global.hp)
	
