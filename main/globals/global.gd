extends Node

##signals

signal damage_taken(amount)
signal attack_player(damage)
signal player_dead
signal die_enemy
signal take_soul


func _ready() -> void:
	self.connect("player_dead",  Callable(self, "go_to").bind("lose"))
	self.connect("take_soul", Callable(self, "add_soul"))

##stats of hero

var hp = 200
var speed = 170
var attack = 50
var souls = 0

##router

var scens = {
	"menu": "res://main/UI/menu/menu.tscn",
	"game": "res://main/game.tscn",
	"lose": "res://main/UI/Lose_screen.tscn",
	"credits": "res://main/UI/credits/Credits.tscn"
}

func go_to(_name: String):
	var scene = scens[_name]
	get_tree().change_scene_to_file(scene)


func spawn_soul(position):
	var soul_scene = preload("res://main/items/soul.tscn")
	var soul := soul_scene.instantiate()
	soul.position = position
	get_parent().add_child(soul)

func add_soul():
	souls += 1
