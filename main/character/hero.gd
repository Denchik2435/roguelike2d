extends Character
class_name Hero

@onready var shoot_point = $Face/Marker2D
@onready var flash = $Face/Marker2D/PointLight2D
@export var projectile_scene: PackedScene


func _ready():
	super()
	Eventbus.connect("attack_player", Callable(self, "take_damage"))
	add_to_group("player")
	default_state = "Move"
	fsm.change_to("Move")
	super.setup(Global.hp, Global.speed, Global.attack, 8, 3)

func take_damage(amount):
	super(amount)
	Global.hp = health


func do_attack():
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


#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("mouse_2"):
		#fsm.change_to("Idle")
