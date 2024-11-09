extends Node2D

@onready var sprite = $Sprite2D
@onready var radial_menu = $RadialMenu

var gadget_panel
var location
var car

signal gadget_built

func respawn_gadget(panel):
	gadget_panel = panel
	spawn_gadget(panel)

func add_gadget(new_panel):
	#check if space is occupied
	if gadget_panel != null:
		pickup_gadget(gadget_panel)
	#check if new panel is deployed elsewhere
	for car in CurrentRun.world.current_train_info.cars_inventory:
		for hard_point in CurrentRun.world.current_train_info.cars_inventory[car]["hard_points"]:
			if CurrentRun.world.current_train_info.cars_inventory[car]["hard_points"][hard_point].gadget_panel == new_panel:
				CurrentRun.world.current_train_info.cars_inventory[car]["hard_points"][hard_point].pickup_gadget(new_panel)

	new_panel.deployed = true
	CurrentRun.world.current_gadget_info.selected_gadget = null
	
	CurrentRun.world.current_train_info.cars_inventory[car.index]["gadgets"][get_parent().name] = {"gadget" = new_panel}
	CurrentRun.world.current_level_info.active_level.close_all_ui()
	$BuildSound.play()
	
	print("Placed Gadget: " + new_panel.gadget)
	
	#create gadget
	var new_gadget = spawn_gadget(new_panel)
	gadget_panel = new_panel
	gadget_built.emit(new_gadget)
	CurrentRun.world.current_player_info.state = "default"
	
	await get_tree().create_timer(1).timeout
	CurrentRun.root.tutorial_ui.trigger_tutorial("first_gadget")

func pickup_gadget(old_gadget):
	old_gadget.deployed = false
	CurrentRun.world.current_train_info.cars_inventory[car.index]["gadgets"].erase(get_parent().name)
	CurrentRun.world.current_level_info.active_level.close_all_ui()
	CurrentRun.world.current_player_info.state = "default"
	radial_menu.close_menu()
	radial_menu.update_menu(null)
	AudioSystem.play_audio("metal_dropping", -15)
	delete_gadget()

func delete_gadget():
	if gadget_panel != null:
		gadget_panel = null
		for i in get_children():
			if i.is_in_group("gadget"):
				i.queue_free()
				break

func spawn_gadget(panel):
	var new_gadget = GadgetInfo.gadget_roster[panel.gadget]["scene"].instantiate()
	add_child(new_gadget)

	new_gadget.global_position = global_position

	radial_menu.close_menu()
	radial_menu.update_menu(panel)
	
	return new_gadget
