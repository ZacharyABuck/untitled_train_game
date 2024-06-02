# YOU MUST CREATE AND ASSIGN A COLLISION SHAPE IN THE SCENE WHERE YOU PUT THIS
extends Area2D

@export_enum("gadgets", "pistol_turret", "none") var menu_type: String
var possible_types = ["gadgets", "pistol_turret", "none"]
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
	spawn_menu(menu_type)

func _on_mouse_entered():
	if PlayerInfo.state == "default":
		$AnimationPlayer.play("flash")
	else:
		$AnimationPlayer.play("still")

func _on_mouse_exited():
	$AnimationPlayer.play("still")

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("strike"):
		#show menu
		if PlayerInfo.active_player.active_car == get_parent().car.index and menu_type != "none":
			PlayerInfo.state = "ui_default"
			open_menu()

func _process(_delta):
	global_rotation = 0

func spawn_menu(type):
	match type:
		"gadgets":
			for i in GadgetInfo.default_roster:
				add_item(i)
		"pistol_turret":
			for i in GadgetInfo.turret_upgrade_roster:
				add_item(i)

func add_item(item):
	var item_info = GadgetInfo.gadget_roster[item]
	var new_item = menu_item.instantiate()
	new_item.position = position
	items.add_child(new_item)
	new_item.sprite.texture = item_info["sprite"]
	new_item.gadget = item
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
	open = true
	$MenuOpenSound.play()
	$AnimationPlayer.play("still")
	LevelInfo.active_level.ui_open = true
	Engine.set_time_scale(.2)
	var spacing = TAU / items.get_children().size()
	var index = 1
	var bg_tween = get_tree().create_tween().bind_node(self)
	bg_tween.tween_property($Sprite2D, "modulate", Color.WHITE, .03)
	for i in items.get_children():
		i.show()
		var angle = spacing*index - PI/2
		index += 1
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(i, "position", position + Vector2(radius,0).rotated(angle), .05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(.02).timeout
	for i in items.get_children():
		i.active = true

func close_menu():
	open = false
	$Sprite2D.modulate = Color.TRANSPARENT
	top_text.text = ""
	top_text.hide()
	bottom_text.text = ""
	bottom_text.hide()
	for i in items.get_children():
		i.hide()
		i.active = false
		i.position = position

func update_menu(gadget):
	if possible_types.has(gadget):
		menu_type = gadget
		for i in items.get_children():
			i.queue_free()
		spawn_menu(gadget)
		$MouseIndicator.show()
	else:
		menu_type = "none"
		$MouseIndicator.hide()
	
