extends Enemy

@export var view_distance := 400.0
@export var fov_deg := 90.0
@export var perception_interval := 0.15

#var target: Node2D = null
var _perception_timer := 0.0

func _physics_process(delta):
	_perception_timer -= delta
	if _perception_timer <= 0.0:
		_perception_timer = perception_interval
		_check_perception()

func _check_perception():
	# Припустимо, гравець доступний глобально через get_tree().get_root().get_node("Player")
	var _player = get_player()
	if not _player:
		target = null
		return

	var to_player = _player.global_position - global_position
	var dist = to_player.length()
	if dist > view_distance:
		target = null
		return

	var forward = Vector2.RIGHT.rotated(global_rotation) # або залежить від твоєї орієнтації
	var angle_deg = rad_to_deg(acos(clamp(forward.dot(to_player.normalized()), -1, 1)))
	if angle_deg > fov_deg * 0.5:
		target = null
		return

	# Raycast для перевірки прямої видимості
	var space = get_world_2d().direct_space_state

	#var result = space.intersect_ray(from, to, exclude, mask)
	var params = PhysicsRayQueryParameters2D.new()
	params.from = global_position
	params.to = _player.global_position
	params.exclude = [self]
	params.collision_mask = 2

	var result = space.intersect_ray(params)


	#var result = space.intersect_ray(global_position, player.global_position, [self], )collision_mask=1
	if result.is_empty() == true:
		# нічого не заважає
		target = _player
		fsm.change_to("Chase")
	else:
		# result містить перший об'єкт, який перешкоджає
		target = null
