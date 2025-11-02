extends CharacterBody2D

@export var speed = 50
@export var player: NodePath
@export var can_see_player: bool = false
var health = 3
var k = 0.5

var target: Node2D
enum State { IDLE, CHASE, DAMAGE, DIE }
var current_state: State = State.IDLE

func _ready():
	target = get_node(player)
	if can_see_player:
		current_state = State.CHASE

func _physics_process(delta):
	if not target:
		current_state = State.IDLE
		return

	match current_state:
		State.IDLE:
			_idle_state()
		State.CHASE:
			_chase_state(delta)
		State.DAMAGE:
			velocity = Vector2.ZERO
			move_and_slide()
		State.DIE:
			pass 

func _idle_state():
	velocity = Vector2.ZERO
	move_and_slide()
	$Node2D/AnimatedSprite2D.play("idle")

func _chase_state(delta):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	$Node2D/AnimatedSprite2D.play("run")

	if velocity.x != 0:
		$Node2D.scale.x = -1 if velocity.x < 0 else 1

func take_damage(amount: int):
	if current_state == State.DIE:
		return

	current_state = State.DAMAGE
	health -= amount
	print("Enemy HP:", health)

	$Node2D/AnimatedSprite2D.play("damage")
	_flash_light()  # <- ось тут викликаємо спалах

	await $Node2D/AnimatedSprite2D.animation_finished

	if health <= 0:
		die()
	else:
		if can_see_player:
			current_state = State.CHASE
		else:
			current_state = State.IDLE

func _flash_light():
	var light = $HitBox/PointLight2D
	light.enabled = true
	light.energy = health/k 
	print(light.energy)
	await get_tree().create_timer(0.5).timeout


func die():
	current_state = State.DIE
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$Node2D/AnimatedSprite2D.play("die")
	await $Node2D/AnimatedSprite2D.animation_finished
	queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		take_damage(1)
