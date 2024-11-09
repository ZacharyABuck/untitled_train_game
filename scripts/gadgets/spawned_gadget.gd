extends Drop

func player_pickup_drop(_v):
	print("spawned gadget pick up drop")
	CurrentRun.world.gadget_select_ui.spawn_gadget_panel()
