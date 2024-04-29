extends Node2D

@export_enum("gadgets", "edges") var menu_type: String
@export var radius: int

var menu_item = preload("res://scenes/menu_item.tscn")

@onready var gadget_name_label = $GadgetName
@onready var gadget_cost_label = $GadgetCost
@onready var items = $Items



# Called when the node enters the scene tree for the first time.
func _ready():
	if menu_type == "gadgets":
		spawn_gadgets_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

func show_gadget_info(gadget_name, gadget_cost):
	if gadget_name == null:
		gadget_name_label.hide()
		gadget_cost_label.hide()
	else:
		gadget_name_label.text = gadget_name
		gadget_cost_label.text = "Cost: $" + str(gadget_cost)
		gadget_name_label.show()
		gadget_cost_label.show()

func open_menu():
	var spacing = TAU / GadgetInfo.gadget_roster.keys().size()
	var index = 1
	for i in items.get_children():
		var angle = spacing*index - PI/2
		index += 1
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(i, "position", position + Vector2(radius,0).rotated(angle), .05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(.05).timeout
	for i in items.get_children():
		i.active = true

func close_menu():
	for i in items.get_children():
		i.active = false
		i.position = position
