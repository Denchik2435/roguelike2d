extends CharacterBody2D
class_name Enemy

@export var speed: float = 50
@export var player: NodePath
@export var can_see_player: bool = false
@export var attack_cooldown: float = 1.0
@export var can_attack: bool = true

var player_in_attack_zone: bool = false
var health: int = 3
var k: float = 0.5
var target: Node2D

enum State { IDLE, CHASE, ATTACK, DAMAGE, DIE }
var current_state: State = State.IDLE


func _ready():
	target = get_node_or_null(player)
	if can_see_player:
		current_state = State.CHASE


func _physics_process(delta: float) -> void:
	if not target:
		current_state = State.IDLE
		return

	match current_state:
		State.IDLE:
			_idle_state()
		State.CHASE:
			_chase_state(delta)
			if _can_start_attack():
				current_state = State.ATTACK
		State.ATTACK:
			_attack_state()
		State.DAMAGE:
			velocity = Vector2.ZERO
			move_and_slide()
		State.DIE:
			pass


# -------------------------------
# Базові стани
# -------------------------------

func _idle_state() -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	$Node2D/AnimatedSprite2D.play("idle")


func _chase_state(delta: float) -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	$Node2D/AnimatedSprite2D.play("run")

	if velocity.x != 0:
		$Node2D.scale.x = -1 if velocity.x < 0 else 1


func _attack_state() -> void:
	if not can_attack:
		return

	print("attack")
	can_attack = false
	velocity = Vector2.ZERO
	move_and_slide()
	$Node2D/AnimatedSprite2D.play("attack")

	if target:
		$Node2D.scale.x = -1 if target.global_position.x < global_position.x else 1

	# Атака
	if player_in_attack_zone and target.has_method("take_damage_mob"):
		target.take_damage_mob(1)

	await $Node2D/AnimatedSprite2D.animation_finished
	if current_state != State.DIE: # запобігає помилкам при смерті під час атаки
		current_state = State.CHASE

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


# -------------------------------
# Допоміжні функції
# -------------------------------

func _can_start_attack() -> bool:
	return can_attack and player_in_attack_zone


func take_damage(amount: int) -> void:
	if current_state == State.DIE:
		return

	current_state = State.DAMAGE
	health -= amount
	print("Enemy HP:", health)

	$Node2D/AnimatedSprite2D.play("damage")
	_flash_light()

	await $Node2D/AnimatedSprite2D.animation_finished

	if health <= 0:
		die()
	else:
		current_state = State.CHASE if can_see_player else State.IDLE


func _flash_light() -> void:
	var light = $HitBox/PointLight2D
	light.enabled = true
	light.energy = health / k
	await get_tree().create_timer(0.5).timeout
	light.enabled = false # важливо: вимикаємо після спалаху


func die() -> void:
	current_state = State.DIE
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$Node2D/AnimatedSprite2D.play("die")
	await $Node2D/AnimatedSprite2D.animation_finished
	queue_free()


# -------------------------------
# Сигнали
# -------------------------------

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		take_damage(1)


func _on_attack_box_area_entered(area: Area2D) -> void:
	print("atack")
	if area.is_in_group("player"):
		current_state = State.ATTACK
		print("attack player")


func _on_attack_box_area_exited(area: Area2D) -> void:
	print("nooo")
	current_state = State.CHASE
