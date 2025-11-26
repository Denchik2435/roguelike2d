extends Control

func exit():
	$MarginContainer/AnimatedSprite2D.stop()
	$SoundManager.stop_sound()


func _ready() -> void:
	$MarginContainer/AnimatedSprite2D.play()
	$SoundManager.play_sound("menu_soundtrack", 10)
	$SoundManager.play_sound("fire_born", 8)


func _on_start_pressed() -> void:
	Global.go_to("game")


func _on_credits_pressed() -> void:
	Global.go_to("credits")


func _on_exit_pressed() -> void:
	get_tree().quit()
