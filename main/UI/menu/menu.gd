extends Control

func _ready() -> void:
	Global.menu.emit()


func _on_start_pressed() -> void:
	Global.go_to("game")


func _on_credits_pressed() -> void:
	Global.go_to("credits")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	Global.go_to("settings")
