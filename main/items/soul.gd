extends Area2D
class_name Soul

var collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash_light()
	$AnimatedSprite2D.play()


func flash_light(duration := 0.2, start_energy := 1.0):
	var light := $PointLight2D
	light.energy = start_energy
	
	var tween := create_tween()
	tween.tween_property(light, "energy", 0.0, duration)
