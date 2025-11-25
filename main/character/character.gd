extends CharacterBody2D
class_name Character

@export var health: int 
@export var speed : float 
@export var attack : float 
@export var attack_frame : int 
@export var die_frame : int
@onready var anim : AnimatedSprite2D = $Face/Animation
@onready var effects : AnimatedSprite2D = $Face/Effects
@onready var face : Node2D = $Face
@onready var fsm : FSM = $StateMachine
@onready var default_state : String
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var sounds : Dictionary[String, AudioStream] = {"damage":preload("res://assets/sounds/enemy/damage.ogg")}

func play_sound(_name: String, _volume = 0):
	if sounds.has(_name):
		audio.stream = sounds[_name]
		audio.volume_db = _volume
		audio.play()


#func _init(_health:int, _speed:float, _attack:float, _attack_frame:int) -> void:
	#self.health = _health
	#self.speed = _speed
	#self.attack = _attack
	#self.attack_frame = _attack_frame

func setup(_health:int, _speed:float, _attack:float, _attack_frame:int, _die_frame:int) -> void:
	self.health = _health
	self.speed = _speed
	self.attack = _attack
	self.attack_frame = _attack_frame
	self.die_frame = _die_frame


func _ready() -> void:
	fsm.init(self)
	effects.hide()


func play_anim(_name : String, fn: Callable = Callable()):
	anim.play(_name)
	if effects.sprite_frames.has_animation(_name):
		effects.show()
		effects.play(_name)
	await anim.animation_finished
	effects.hide()
	if fn:
		fn.call()


func _physics_process(delta: float) -> void:
	fsm.physics_update(delta)
	if health <= 0:
		fsm.change_to("Die")


func take_damage(amount):
	health -= amount
	fsm.change_to("Damage")
	print(health)


func to_default_state():
	fsm.change_to(default_state)


func do_attack():
	pass


func disable():
	$CollisionShape2D.set_deferred("disabled", true)


func _on_animation_animation_finished() -> void:
	if health > 0:
		to_default_state()
