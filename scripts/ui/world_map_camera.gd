extends Camera2D

var camera_speed: int = 1500
var camera_limits: Array = [0,0]

var min_vector: Vector2
var max_vector: Vector2

func jump_to_player():
	var size = get_viewport().get_visible_rect().size
	var active_town = get_parent().current_world_info.towns_inventory[get_parent().current_world_info.active_town]["scene"]
	position = active_town.global_position - size*.5

func jump_to_pos(pos):
	if min_vector != null and max_vector != null:
		var size = get_viewport().get_visible_rect().size
		position = clamp(pos - (size*.8), min_vector, max_vector)

func reset():
	get_parent().travel_line.hide()
	jump_to_player()

func _process(delta):
	var size = get_viewport_rect().size #get_viewport().get_visible_rect().size
	if camera_limits.size() >= 4:
		min_vector = Vector2(camera_limits[0], camera_limits[1])
		max_vector = Vector2(camera_limits[2] - (size.x*1.8), camera_limits[3] - (size.y*1.7))
		position.x = clamp(position.x + (get_input().x * camera_speed * delta), min_vector.x, max_vector.x)
		position.y = clamp(position.y + (get_input().y * camera_speed * delta), min_vector.y, max_vector.y)
	
func get_input():
	# -- DIRECTIONAL INPUT -- #
	var input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction

func _input(event):
	if event is InputEventScreenDrag and !get_parent().towns_ui.visible:
		position -= event.relative*3
