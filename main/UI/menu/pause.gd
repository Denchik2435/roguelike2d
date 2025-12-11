extends CanvasLayer

@onready var pause_menu = $MarginContainer
@onready var settings_menu = $Settings


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.visible = false
	settings_menu.in_game = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not settings_menu.visible:
		pause_menu.visible = true


func _on_continue_pressed() -> void:
	get_parent().pause(false)


func _on_settings_pressed() -> void:
	pause_menu.visible = false
	settings_menu.visible = true


func _on_exit_pressed() -> void:
	get_parent().pause(false)
	Global.go_to("menu")
