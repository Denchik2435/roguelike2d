extends Control


var autors_of_assets = {
	"CreativeKind": "https://creativekind.itch.io/",
	"LuckyLoops": "https://lucky-loops.itch.io/",
	"Free": "https://free-game-assets.itch.io/",
	"Sounds": "https://zvukogram.com/category/"
}

func _ready():
	for btn_name in autors_of_assets.keys():
		var btn = $MarginContainer2/VBoxContainer/Buttons.get_node(btn_name)
		if btn and autors_of_assets[btn_name]:
			btn.pressed.connect(func(): OS.shell_open(autors_of_assets[btn_name]))

func _on_autor_pressed() -> void:
	OS.shell_open("https://www.linkedin.com/in/%D0%BC%D0%B0%D0%BA%D1%81%D0%B8%D0%BC-%D0%BC%D0%B5%D0%BD%D1%8C%D1%88%D0%B8%D0%BA%D0%BE%D0%B2-0aa21b338?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app")


func _on_back_pressed() -> void:
	Global.go_to("menu")
