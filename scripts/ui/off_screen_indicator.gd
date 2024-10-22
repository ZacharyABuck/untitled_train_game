extends TextureRect

var target #this needs to be a node2d

var margin: float = 100.0

@onready var label = $"../OffscreenLabel"
@onready var path = $"../Path"

func _ready():
	hide()
	label.hide()
	CurrentRun.world.current_train_info.train_boarded.connect(set_target)

func _physics_process(delta):
	if target != null:
		
		var player_pos = get_viewport_rect().get_center()
		var target_pos = target.get_global_transform_with_canvas().get_origin()
		
		path.curve.set_point_position(0, player_pos)
		path.curve.set_point_position(1, target_pos)
		
		var clamped_x = clamp(path.curve.get_closest_point(target_pos).x, 0 + margin, get_viewport_rect().size.x - margin - size.x)
		var clamped_y = clamp(path.curve.get_closest_point(target_pos).y, 0 + margin, get_viewport_rect().size.y - margin - size.y)
		
		rotation = player_pos.angle_to_point(target_pos)
		position = Vector2(clamped_x,clamped_y) - size*.5
		label.position = (position - label.size*.5) + size*.5
		
		if "offscreen_detector" in target:
			if target.offscreen_detector.is_on_screen():
				hide()
				label.hide()
			else:
				show()
				label.show()
				
func _input(event):
	if event.is_action_pressed("repair"):
		set_target(CurrentRun.world.current_train_info.furnace)

func set_target(node):
	target = node
	await get_tree().create_timer(5).timeout
	target = null
	hide()
	label.hide()
