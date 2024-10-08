# YOU MUST CREATE AND ASSIGN A COLLISION SHAPE IN THE SCENE WHERE YOU PUT THIS
extends Area2D

var possible_types = ["default", "pistol_turret", "explosive_turret", "rifle_turret", "none"]
var current_type
@export var radius: int
@export var collision_shape: CollisionShape2D

var selected: bool = false
var open: bool = false

var menu_item = preload("res://scenes/ui/menu_item.tscn")

@onready var top_text = $TopText
@onready var bottom_text = $BottomText
@onready var items = $Items

var car

func _ready():
	if current_type == null:
		current_type = "default"
	$Sprite2D.texture.width = radius * 2.6
	$Sprite2D.texture.height = radius * 2.6
	$Sprite2D.modulate = Color.TRANSPARENT

func _on_mouse_entered():
	if CurrentRun.world.current_player_info.active_player:
		if CurrentRun.world.current_player_info.state == "default":
			if CurrentRun.world.current_player_info.active_player.active_car == get_parent().car.index and current_type != "none":
				$AnimationPlayer.play("flash")
				selected = true
		else:
			$AnimationPlayer.play("still")
			selected = false

func _on_mouse_exited():
	$AnimationPlayer.play("still")
	selected = false

func _process(_delta):
	global_rotation = 0
	
	if Input.is_action_pressed("interact") and selected and !open:
		CurrentRun.world.current_player_info.state = "ui_default"
		open_menu()

func spawn_menu(type):
	for i in GadgetInfo.upgrade_rosters[type]:
		if GadgetInfo.gadget_roster[i]["unlocked"] == true:
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

func show_gadget_info(gadget):
	if gadget == null:
		top_text.hide()
		bottom_text.hide()
	else:
		var gadget_name = GadgetInfo.gadget_roster[gadget]["name"]
		top_text.text = gadget_name
		bottom_text.text = "Cost: $" + str(GadgetInfo.gadget_roster[gadget]["cost"])
		top_text.show()
		bottom_text.show()

func open_menu():
	spawn_menu(current_type)
	
	open = true
	$MenuOpenSound.play()
	$AnimationPlayer.play("still")
	CurrentRun.world.current_level_info.active_level.ui_open = true
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
		i.queue_free()

func update_menu(gadget):
	if possible_types.has(gadget):
		current_type = gadget
		for i in items.get_children():
			i.queue_free()
		$MouseIndicator.show()
	else:
		current_type = "none"
		$MouseIndicator.hide()
	
