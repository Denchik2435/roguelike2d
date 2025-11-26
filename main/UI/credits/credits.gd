extends Control


var autors_of_assets = {
	"CreativeKind": "https://creativekind.itch.io/",
	"LuckyLoops": "https://lucky-loops.itch.io/",
	"Free": "https://free-game-assets.itch.io/",
	"Sounds": null
}


func _ready():
	$SoundManager.play_sound("menu_soundtrack", 5)
	for btn_name in autors_of_assets.keys():
		var btn = $MarginContainer2/MarginContainer/VBoxContainer/Buttons.get_node(btn_name)
		if btn and autors_of_assets[btn_name]:
			btn.pressed.connect(func(): OS.shell_open(autors_of_assets[btn_name]))

func _on_autor_pressed() -> void:
	OS.shell_open("www.linkedin.com/in/максим-меньшиков-0aa21b338")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Global.go_to("menu")
