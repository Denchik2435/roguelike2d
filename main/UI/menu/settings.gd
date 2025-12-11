extends Control

var in_game = false
@onready var music_sounds = $MarginContainer/HBoxContainer/VBoxContainer/Sounds/Music/HSlider
@onready var effects_sounds = $MarginContainer/HBoxContainer/VBoxContainer/Sounds/Effects/HSlider
@onready var value_music = $MarginContainer/HBoxContainer/VBoxContainer/Sounds/Music/value
@onready var value_effects = $MarginContainer/HBoxContainer/VBoxContainer/Sounds/Effects/value2
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	music_sounds.value = Global.k_volume
	effects_sounds.value = Global.k_volume_effects
	value_music.text = str(Global.k_volume*100)
	value_effects.text = str(Global.k_volume_effects*100)


func _on_h_slider_value_changed(value: float) -> void:
	value_music.text = str(value*100)
	Global.k_volume = value
	Global.change_volume.emit()


func _on_h_slider_value_changed2(value: float) -> void:
	value_effects.text = str(value*100)
	Global.k_volume_effects = value
	Global.change_volume.emit()


func _on_button_pressed() -> void:
	if in_game:
		visible = false
	else:
		Global.go_to("menu")
