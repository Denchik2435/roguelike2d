extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO
var dead := false

func _ready():
	add_to_group("player_bullets")

func _physics_process(delta):
	if dead:
		return
	$AnimatedSprite2D.play("idle")
	$FireWay.play("fire")
	position += direction * speed * delta

func _on_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(1)  
	$FireWay.stop()

	call_deferred("_die")

func _die():
	if dead:
		return
	dead = true

	# отключаем коллизию безопасно
	$CollisionShape2D.set_deferred("disabled", true)

	# проигрываем анимацию взрыва
	$AnimatedSprite2D.play("destroy")

	# ждём конца анимации
	await $AnimatedSprite2D.animation_finished
	queue_free()
