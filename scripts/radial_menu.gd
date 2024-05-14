# YOU MUST CREATE AND ASSIGN A COLLISION SHAPE IN THE SCENE WHERE YOU PUT THIS
extends Area2D

@export_enum("gadgets", "edges") var menu_type: String
@export var radius: int
@export var collision_shape: CollisionShape2D

var open: bool = false

var menu_item = preload("res://scenes/menu_item.tscn")

@onready var top_text = $TopText
@onready var bottom_text = $BottomText
@onready var items = $Items

var car

func _ready():
	$Sprite2D.texture.width = radius * 2.6
	$Sprite2D.texture.height = radius * 2.6
	$Sprite2D.modulate = Color.TRANSPARENT
	if menu_type == "gadgets":
		spawn_gadgets_menu()

func _on_mouse_entered():
	if LevelInfo.active_level.ui_open == false:
		$AnimationPlayer.play("flash")
	else:
		$AnimationPlayer.play("still")

func _on_mouse_exited():
	$AnimationPlayer.play("still")


func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("strike"):
		#hide menu
		if open == true:
			LevelInfo.active_level.close_all_ui()
		#show menu
		elif PlayerInfo.active_player.active_car == get_parent().car.index:
			open_menu()

func _process(_delta):
	global_rotation = 0

func spawn_gadgets_menu():
	for i in GadgetInfo.gadget_roster:
		var new_item = menu_item.instantiate()
		new_item.position = position
		items.add_child(new_item)
		new_item.sprite.texture = GadgetInfo.gadget_roster[i]["sprite"]
		new_item.gadget = GadgetInfo.gadget_roster[i]
		new_item.clicked.connect(get_parent().add_gadget)
		new_item.hovered.connect(show_gadget_info)
		new_item.hide()

func show_gadget_info(gadget_name, gadget_cost):
	if gadget_name == null:
		top_text.hide()
		bottom_text.hide()
	else:
		top_text.text = gadget_name
		bottom_text.text = "Cost: $" + str(gadget_cost)
		top_text.show()
		bottom_text.show()

func open_menu():
	#LevelInfo.active_level.close_all_ui()
	open = true
	$MenuOpenSound.play()
	$AnimationPlayer.play("still")
	LevelInfo.active_level.ui_open = true
	Engine.set_time_scale(.2)
	var spacing = TAU / GadgetInfo.gadget_roster.keys().size()
	var index = 1
	var bg_tween = get_tree().create_tween().bind_node(self)
	bg_tween.tween_property($Sprite2D, "modulate", Color.WHITE, .03)
	for i in items.get_children():
		i.show()
		var angle = spacing*index - PI/2
		index += 1
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(i, "position", position + Vector2(radius,0).rotated(angle), .05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(.05).timeout
	for i in items.get_children():
		i.active = true

func close_menu():
	open = false
	$Sprite2D.modulate = Color.TRANSPARENT
	for i in items.get_children():
		i.hide()
		i.active = false
		i.position = position
