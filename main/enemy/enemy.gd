extends Character
class_name Enemy

@export var player: NodePath
@onready var target: Node2D
@export var can_attack: bool = true


func get_player():
	target = get_node_or_null(player)
	return target


func disable():
	super()
	$AttackBox/CollisionShape2D.set_deferred("disabled", true)
	

func _ready():
	super()
	add_to_group("enemy")
	fsm.change_to("Chase")
	default_state = "Chase"
	

func do_attack():
	Eventbus.emit_signal("attack_player", attack)


func _on_attack_box_body_entered(_body: Character) -> void:
	if can_attack:
		fsm.change_to("Attack")


func _on_attack_box_body_exited(_body: Character) -> void:
	to_default_state()
