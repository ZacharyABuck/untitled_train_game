extends Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var selection_sprite = $SelectionSprite

var gadget

var car

# Called when the node enters the scene tree for the first time.
func _ready():
	car = get_parent().get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_mouse_entered():
	if GadgetInfo.selection_active and gadget == null and PlayerInfo.active_player.active_car == car:
		selection_sprite.show()

func _on_area_2d_mouse_exited():
	if GadgetInfo.selection_active and gadget == null:
		selection_sprite.hide()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if GadgetInfo.selection_active and gadget == null and event is InputEventMouseButton and event.pressed and PlayerInfo.active_player.active_car == car:
		gadget = GadgetInfo.selected_gadget
		PlayerInfo.money -= gadget["cost"]
		GadgetInfo.selected_gadget = null
		GadgetInfo.selection_active = false
		for i in PlayerInfo.active_player.active_car.hard_points.get_children():
			i.get_child(0).animation_player.play("still")
			i.get_child(0).sprite.modulate = Color.WHITE
		selection_sprite.texture = null
		selection_sprite.hide()
		var new_gadget = gadget["scene"].instantiate()
		PlayerInfo.active_player.active_car.gadgets.add_child(new_gadget)
		new_gadget.global_position = global_position

		LevelInfo.active_level.get_parent().build_menu.hide()
		LevelInfo.active_level.get_parent().build_menu_open = false
		LevelInfo.active_level.get_tree().paused = false
