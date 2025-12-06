extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("take_soul", Callable(self, "update"))


func update():
	$HBoxContainer/Label.text = str(Global.souls)
