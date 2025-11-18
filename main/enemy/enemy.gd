extends Character
class_name Enemy

@export var player: NodePath
@onready var target: Node2D

func _init(_health:int=100, _speed:float=100, _attack:float=25, _attack_frame:int=6) -> void:
	super._init(_health, _speed, _attack, _attack_frame)


func get_player():
	target = get_node_or_null(player)
	return target


func _ready():
	super()
	add_to_group("enemy")
	fsm.change_to("Chase")


func do_attack():
	Eventbus.emit_signal("attack_player", attack)


func _on_attack_box_body_entered(_body: Character) -> void:
	fsm.change_to("Attack")
	print("body")


func _on_attack_box_body_exited(_body: Character) -> void:
	fsm.to_default()
