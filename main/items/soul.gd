extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash_light()
	$AnimatedSprite2D.play()


func _on_body_entered(body) -> void:
	if body is Hero:
		queue_free()
		Global.take_soul.emit()

func flash_light(duration := 1, start_energy := 2.0):
	var light := $PointLight2D
	light.energy = start_energy
	
	var tween := create_tween()
	tween.tween_property(light, "energy", 0.0, duration)
