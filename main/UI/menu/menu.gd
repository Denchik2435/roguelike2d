extends Control

func exit():
	$SoundManager.stop_sound()


func _ready() -> void:
	$SoundManager.play_sound("menu_soundtrack", 10)
	$SoundManager.play_sound("fire_born", 8)


func _on_start_pressed() -> void:
	Global.go_to("game")


func _on_credits_pressed() -> void:
	Global.go_to("credits")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	Global.go_to("settings")
