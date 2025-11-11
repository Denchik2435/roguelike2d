extends CharacterBody2D

@onready var speed = Global.speed
@onready var shoot_point = $Face/Marker2D
@onready var anim = $Face/AnimatedSprite2D
@onready var flash = $Face/Marker2D/PointLight2D
@onready var face = $Face
@onready var fsm = $StateMachine
@export var projectile_scene: PackedScene

var attack_frame_to_shoot = 8

func _ready():
	Eventbus.connect("damage_taken", Callable(self, "take_damage"))
	add_to_group("player")
	fsm.init(self)
	fsm.change_to("Move")


func _physics_process(delta):
	fsm.physics_update(delta)
	if Global.hp <= 0:
		fsm.change_to("Die")


# --- АТАКА, УНІВЕРСАЛЬНА ЧЕРЕЗ attack() ---
func attack():
	anim.play("attack")

func shoot():
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = shoot_point.global_position

	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - shoot_point.global_position).normalized()

	projectile.direction = dir
	projectile.rotation = dir.angle()
	shoot_flash()


func shoot_flash():
	flash.visible = true
	await get_tree().create_timer(1).timeout
	flash.visible = false


func take_damage(amount):
	Global.hp -= amount
	print("My HP:", Global.hp)
	anim.play("damage")

func die():
	anim.play("die")
	await anim.animation_finished
	queue_free()

func _on_animated_sprite_2d_frame_changed() -> void: 
	if anim.animation == "attack" and anim.frame == attack_frame_to_shoot: 
		shoot() 
		print("shot")
		Eventbus.emit_signal("damage_taken", 25)


func _on_hit_box_area_entered(area: Area2D) -> void:
	fsm.change_to("Damage")
