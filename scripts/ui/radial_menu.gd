# YOU MUST CREATE AND ASSIGN A COLLISION SHAPE IN THE SCENE WHERE YOU PUT THIS
extends Area2D

var current_type
@export var radius: int
@export var collision_shape: CollisionShape2D

var selected: bool = false
var open: bool = false

var menu_item = preload("res://scenes/ui/menu_item.tscn")
var sell_icon = preload("res://sprites/ui/sell_icon.png")

@onready var top_text = $TopText
@onready var bottom_text = $BottomText
@onready var items = $Items

var slot
var car

func _ready():

	$Sprite2D.texture.width = radius * 2.6
	$Sprite2D.texture.height = radius * 2.6
	$Sprite2D.modulate = Color.TRANSPARENT


func _on_body_entered(body):
	if body is Player:
		if CurrentRun.world.current_player_info.active_player:
			if CurrentRun.world.current_player_info.state == "default":
				if current_type == null:
					for i in GadgetInfo.gadget_roster:
						if GadgetInfo.gadget_roster[i].has("unlocked") and GadgetInfo.gadget_roster[i]["unlocked"] == true:
							$AnimationPlayer.play("flash")
							selected = true
							break
				else:
					for i in GadgetInfo.gadget_roster:
						if GadgetInfo.gadget_roster[i]["last_gadget"] == current_type:
							$AnimationPlayer.play("flash")
							selected = true
							break
			else:
				$AnimationPlayer.play("still")
				selected = false

func _on_body_exited(body):
	if body is Player:
		$AnimationPlayer.play("still")
		selected = false

func _process(_delta):
	global_rotation = 0
	
func _input(event):
	if event.is_action_pressed("interact") and selected and !open and CurrentRun.world.current_player_info.state == "default":
		CurrentRun.world.current_player_info.state = "ui_default"
		open_menu()

func spawn_menu(type):
	if type == null:
		#spawn base gadgets
		for i in GadgetInfo.gadget_roster:
			if GadgetInfo.gadget_roster[i].has("unlocked") and GadgetInfo.gadget_roster[i]["unlocked"] == true:
				add_item(i)
	else:
		add_item("sell")
		#spawn upgrade menu
		for i in GadgetInfo.gadget_roster:
			if GadgetInfo.gadget_roster[i]["last_gadget"] == type:
				add_item(i)
		

func add_item(item):
	var new_item = menu_item.instantiate()
	new_item.position = position
	items.add_child(new_item)
	
	if item == "sell":
		new_item.sprite.texture = sell_icon
		if get_parent().has_method("sell_gadget"):
			new_item.clicked.connect(get_parent().sell_gadget)
		new_item.gadget = current_type
	else:
		var item_info = GadgetInfo.gadget_roster[item]
		new_item.sprite.texture = item_info["sprite"]
		if get_parent().has_method("add_gadget"):
			new_item.clicked.connect(get_parent().add_gadget)
		new_item.gadget = item
		
	new_item.hovered.connect(show_gadget_info)
	new_item.hide()

func show_gadget_info(gadget):
	if gadget == null:
		top_text.hide()
		bottom_text.hide()
	elif gadget == current_type:
		var gadget_name = GadgetInfo.gadget_roster[current_type]["name"]
		top_text.text = "Sell " + gadget_name
		bottom_text.text = "+ $" + str(GadgetInfo.gadget_roster[current_type]["cost"]*0.5)
		top_text.show()
		bottom_text.show()
	else:
		var gadget_name = GadgetInfo.gadget_roster[gadget]["name"]
		top_text.text = gadget_name
		bottom_text.text = "Cost: $" + str("%.2f" % GadgetInfo.gadget_roster[gadget]["cost"])
		top_text.show()
		bottom_text.show()

func open_menu():
	spawn_menu(current_type)
	
	open = true
	$MenuOpenSound.play()
	$AnimationPlayer.play("still")
	if CurrentRun.world.current_level_info.active_level != null:
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
	
	await get_tree().create_timer(.1).timeout
	for i in get_overlapping_bodies():
		_on_body_entered(i)

func update_menu(gadget):
	for item in items.get_children():
		item.queue_free()
	
	current_type = gadget
	
	for i in GadgetInfo.gadget_roster:
		if GadgetInfo.gadget_roster[i]["last_gadget"] == gadget:
			$MouseIndicator.show()
			break
		else:
			$MouseIndicator.hide()
	


