extends CanvasLayer

@onready var gadget_panel_container = %GadgetPanelContainer

var gadget_panel = preload("res://scenes/ui/gadget_panel.tscn")

func _ready():
	await get_tree().create_timer(5).timeout
	spawn_gadget_panel()

func spawn_gadget_panel():
	get_parent().pause_game()
	AudioSystem.play_audio("heavy_switch", -15)
	
	var random_gadget = find_random_gadget()

	var new_panel = gadget_panel.instantiate()
	new_panel.gadget = random_gadget
	gadget_panel_container.add_child(new_panel)
	new_panel.sold.connect(get_parent().sell_gadget)
	new_panel.clicked.connect(get_parent().add_gadget_panel)
	
	show()

func find_random_gadget():
	var gadget = GadgetInfo.gadget_roster.keys().pick_random()
	while GadgetInfo.gadget_roster[gadget]["last_gadget"] != null:
		gadget = GadgetInfo.gadget_roster.keys().pick_random()
	return gadget
