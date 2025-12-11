extends Node
##variables

@onready var sound_manager = preload("res://main/globals/SoundManager.tscn").instantiate()


##signals

signal damage_taken(amount)
signal attack_player(damage)
signal player_dead
signal die_enemy
signal take_soul
signal change_volume
signal start_game
signal menu


func _ready() -> void:
	
	add_child(sound_manager)
	#sound_manager.play_sound("menu_soundtrack")
	#sound_manager.play_sound("fire_born")
	self.connect("player_dead",  Callable(self, "go_to").bind("lose"))
	self.connect("take_soul", Callable(self, "add_soul"))
	self.connect("start_game", Callable(self, "stop_menu"))
	self.connect("menu", Callable(self, "start_menu"))

##stats of hero

var hp = 200
var speed = 170
var attack = 50
var souls = 0

##sound volume [0,1]

var k_volume = 0.5
var k_volume_effects = 0.5

func calc_volume_music():
	return linear_to_db(Global.k_volume)

func calc_volume_effects():
	return linear_to_db(Global.k_volume_effects)

func stop_menu():
	sound_manager.stop_sound()
	#sound_manager.play_sound("game_soundtrack")

func start_menu():
	#sound_manager.stop_sound()
	sound_manager.play_sound("menu_soundtrack")
##router

var scens = {
	"menu": "res://main/UI/menu/menu.tscn",
	"game": "res://main/game.tscn",
	"lose": "res://main/UI/Lose_screen.tscn",
	"credits": "res://main/UI/credits/Credits.tscn",
	"settings": "res://main/UI/menu/settings.tscn",
	"pouse": "res://main/UI/menu/pause.tscn"
}

func go_to(_name: String):
	var scene = scens[_name]
	get_tree().change_scene_to_file(scene)


func spawn_soul(position, parent):
	var soul_scene = preload("res://main/items/soul.tscn")
	var soul := soul_scene.instantiate()
	soul.position = position
	parent.add_child(soul)


func add_soul():
	souls += 1
