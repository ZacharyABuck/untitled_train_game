extends Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var selection_sprite = $SelectionSprite

var gadget

var car

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_2d_mouse_entered():
	if GadgetInfo.selection_active and gadget == null and PlayerInfo.active_player.active_car == car:
		selection_sprite.show()

func _on_area_2d_mouse_exited():
	if GadgetInfo.selection_active and gadget == null:
		selection_sprite.hide()

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if GadgetInfo.selection_active and gadget == null and event is InputEventMouseButton and event.pressed and PlayerInfo.active_player.active_car == car:
		GadgetFunctions.add_gadget(GadgetInfo.selected_gadget, self, car)
		selection_sprite.texture = null
		selection_sprite.hide()
