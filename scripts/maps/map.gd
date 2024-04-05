extends TileMap

@onready var left_area = $LeftArea
@onready var right_area = $RightArea
@onready var bottom_area = $BottomArea
@onready var top_area = $TopArea

signal edge_reached


func _on_left_area_body_entered(body):
	if body.is_in_group("player"):
		edge_reached.emit("left", body, self)

func _on_right_area_body_entered(body):
	if body.is_in_group("player"):
		edge_reached.emit("right", body, self)

func _on_bottom_area_body_entered(body):
	if body.is_in_group("player"):
		edge_reached.emit("bottom", body, self)

func _on_top_area_body_entered(body):
	if body.is_in_group("player"):
		edge_reached.emit("top", body, self)
