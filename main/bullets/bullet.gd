extends Area2D
class_name Bullet

@export var speed: float = 600.0
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
var sounds : Dictionary[String, AudioStream] = {"damage" : preload("res://assets/sounds/enemy/damage.ogg")}
var damage : float = 10
var direction : Vector2 = Vector2.ZERO
var fly : bool = true


func play_sound(_name : String):
	if sounds.has(_name):
		audio.stream = sounds[_name]
		audio.play()


func _play_anim(_name : String, _fn : Callable = Callable()) -> void:
	anim.stop()
	anim.play(_name)
	if _fn:
		await anim.animation_finished
		_fn.call()


func _fly() -> void:
	$AnimatedSprite2D.play("idle")


func _physics_process(delta):
	if not fly:
		$PointLight2D.hide()
		return
	_fly()
	position += direction * speed * delta


func set_damage(amount):
	damage = amount


func _damage(body):
	direction = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	body.take_damage(damage)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	fly = false
	play_sound("damage")
	
	if body:
		_damage(body)
	else:
		_play_anim("destroy", queue_free)
