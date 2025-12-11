extends Character
class_name Hero

@onready var shoot_point = $Face/Marker2D
@onready var flash = $Face/Marker2D/PointLight2D
@export var projectile_scene: PackedScene
@onready var fireball : PackedScene = load("res://main/bullets/hero_bullet.tscn")
@onready var collector = $Collector

func _ready():
	super()
	Global.hp = 200
	Global.connect("attack_player", Callable(self, "take_damage"))
	default_state = "Move"
	fsm.change_to("Move")
	super.setup(Global.hp, Global.speed, Global.attack, 8, 3)

func take_damage(amount):
	super(amount)
	Global.hp = health


#func do_attack():
	#var _fireball = fireball.instantiate()
	#get_tree().current_scene.add_child(_fireball)
	#_fireball.set_damage(Global.attack)
	#_fireball.global_position = shoot_point.global_position
	#
	#var mouse_pos = get_global_mouse_position()
	#var dir = (mouse_pos - shoot_point.global_position).normalized()
	#
	#_fireball.direction = dir
	#_fireball.rotation = dir.angle()
	#shoot_flash()

func do_attack():
	var _fireball = fireball.instantiate()
	get_tree().current_scene.add_child(_fireball)
	_fireball.set_damage(Global.attack)
	_fireball.global_position = shoot_point.global_position

	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - shoot_point.global_position).normalized()


	var spread_deg = 5.0  
	var spread_rad = deg_to_rad(randf_range(-spread_deg, spread_deg))

	var final_angle = dir.angle() + spread_rad
	var final_dir = Vector2.RIGHT.rotated(final_angle)

	_fireball.direction = final_dir
	_fireball.rotation = final_angle


func _on_collector_area_entered(area: Area2D) -> void:
	if area is Soul:
		area.queue_free()
		fsm.change_to("Collect")
