extends TileMap

var altitude = FastNoiseLite.new()
@onready var astar = AStar2D.new()
var chunk_width: int = 120
var chunk_height: int = 30
var loaded_chunks: Array = []

var starting_coords = Vector2i.ZERO

var road_cells = []
var vertical_road_count: int = 10
var horizontal_road_count: int = 2
var town_count: int = 10

var town_cells = []

var town = preload("res://scenes/town.tscn")

signal finished_spawning_map

func _ready():
	finished_spawning_map.connect(get_parent().map_spawned)
	await get_tree().create_timer(.2).timeout
	altitude.frequency = .05
	altitude.seed = randi()
	var new_cells = spawn_map(starting_coords)
	BetterTerrain.update_terrain_cells(self, 0, new_cells)
	print("map done")
	spawn_astar()
	print("astar done")
	handle_roads()

	await handle_towns()

	get_parent().camera.camera_limits.append(tile_set.tile_size.x*chunk_width) 
	get_parent().camera.camera_limits.append(tile_set.tile_size.y*chunk_height) 

	await spawn_player()

	finished_spawning_map.emit()
	
func handle_roads():
	var new_road
	for v in vertical_road_count:
		new_road = find_random_road(0)
		road_cells.append_array(new_road)
	for h in horizontal_road_count:
		new_road = find_random_road(1)
		road_cells.append_array(new_road)
	return true

func handle_towns():
	var distance_from_left: float = 10
	for i in town_count:
		var new_town_pos = spawn_town(distance_from_left)
		distance_from_left += 10
		if new_town_pos:
			town_cells.append(new_town_pos)
			BetterTerrain.set_cell(self, 0, new_town_pos, 0)
			
			#create town
			var new_town = town.instantiate()
			new_town.global_position = map_to_local(new_town_pos)
			new_town.scale = Vector2(0,0)
			add_child(new_town)
			
			#check we don't spawn the same town twice
			var valid_town: bool = false
			while valid_town == false:
				var town_info = WorldInfo.towns_roster.keys().pick_random()
				if CurrentRun.world.current_world_info.towns_inventory.keys().has(town_info):
					pass
				#set all town info
				else: 
					CurrentRun.world.current_world_info.towns_inventory[town_info] = WorldInfo.towns_roster[town_info]
					CurrentRun.world.current_world_info.towns_inventory[town_info]["scene"] = new_town
					new_town.set_town_info(town_info)
					valid_town = true
		
			new_town.clicked.connect(owner.town_clicked.bind(new_town))
	
	var farthest_town = CurrentRun.world.current_world_info.towns_inventory.keys().pick_random()
	#animate towns scale with tween and check if town is ultimate goal
	for t in CurrentRun.world.current_world_info.towns_inventory.keys():
		var scene = CurrentRun.world.current_world_info.towns_inventory[t]["scene"]
		
		if scene.global_position.x > CurrentRun.world.current_world_info.towns_inventory[farthest_town]["scene"].global_position.x:
			farthest_town = t
	
	CurrentRun.world.current_world_info.farthest_town = farthest_town
	CurrentRun.world.current_world_info.towns_inventory[farthest_town]["scene"].farthest_town_fx.show()
	return farthest_town

func spawn_map(coords):
	
	var new_cells = []
	#set cells by altitude
	for x in range(chunk_width):
		for y in range(chunk_height):
			var cell = coords + Vector2i(x,y)
			var alt = altitude.get_noise_2d(cell.x, cell.y) * 10
			if !get_used_cells(0).has(cell):
				if alt < 0:
					BetterTerrain.set_cell(self, 0, cell, 0)
				else:
					var terrain = round(2 * (alt) / 8)
					BetterTerrain.set_cell(self, 0, cell, terrain)
				if coords not in loaded_chunks:
					loaded_chunks.append(coords)
				new_cells.append(cell)
			else:
				if BetterTerrain.get_cell(self, 0, cell) == 2:
					pass
			
	
	return new_cells

func spawn_astar():
	for cell in get_used_cells(0):
		astar.add_point(id(cell), cell, 1.0)
	for cell in get_used_cells(0):
		var neighbors = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
		for neighbor in neighbors:
			var next_cell = cell + neighbor
			if get_used_cells(0).has(next_cell):
				astar.connect_points(id(cell), id(next_cell), false)
	return true

func id(point):
	var a = point.x
	var b = point.y
	return (a + b) * (a + b + 1) / 2 + b

func find_random_road(index):
	var rect = get_used_rect().size

	var vertical_margin = 8
	var horizontal_margin: int = 10
	
	var new_road_cells = []
	match index:
		0: #vertical road
			var random_start_x = clamp(randi_range(0,rect.x), 0+horizontal_margin, rect.x-horizontal_margin)
			var random_end_x = clamp(randi_range(0,rect.x), random_start_x+randi_range(-5,5)+horizontal_margin, random_start_x+randi_range(-5,5)-horizontal_margin)
			new_road_cells = spawn_road(Vector2i(random_start_x, vertical_margin), Vector2i(random_end_x, chunk_height - vertical_margin))
		1: # horizontal road
			var random_start_y = clamp(randi_range(0,rect.y), 0+vertical_margin, rect.y-vertical_margin)
			var random_end_y = clamp(randi_range(0,rect.y), 0+vertical_margin, rect.y-vertical_margin)
			if new_road_cells.is_empty():
				new_road_cells = spawn_road(Vector2i(horizontal_margin, random_start_y), Vector2i(chunk_width - horizontal_margin, random_end_y))
			else:
				new_road_cells.append_array(spawn_road(Vector2i(horizontal_margin, random_start_y), Vector2i(chunk_width - horizontal_margin, random_end_y)))

	BetterTerrain.update_terrain_cells(self, 0, new_road_cells)
	return new_road_cells

func spawn_road(start, end) -> PackedVector2Array:
	var new_road_cells: PackedVector2Array = []
	var path = astar.get_point_path(id(start),id(end))
	for i in path:
		new_road_cells.append(i)
		BetterTerrain.set_cell(self, 0, i, 2)
	return new_road_cells

func spawn_town(distance_from_left):
	var distance_from_left_cells = []
	#check for cells on the given x value
	for road in road_cells:
		if road.x == distance_from_left:
			distance_from_left_cells.append(road)
	#pick a random cell from the given x values
	for road in distance_from_left_cells:
		var random_road = distance_from_left_cells.pick_random()
		#pick a neighbor so that the town is next to a road, check if the neighbor is also a road
		for neighbor in get_surrounding_cells(random_road):
			var terrain = BetterTerrain.get_cell(self, 0, neighbor)
			if terrain != 2 and terrain != 3:
				return neighbor

func spawn_player():
	if CurrentRun.world.current_level_info.destination == null:
		var random_town = CurrentRun.world.current_world_info.towns_inventory.keys().pick_random()
		for t in CurrentRun.world.current_world_info.towns_inventory.keys():
			if CurrentRun.world.current_world_info.towns_inventory[t]["scene"].global_position.x < CurrentRun.world.current_world_info.towns_inventory[random_town]["scene"].global_position.x:
				random_town = t
		CurrentRun.world.current_world_info.active_town = random_town
	else:
		CurrentRun.world.current_world_info.active_town = CurrentRun.world.current_level_info.destination
		CurrentRun.world.current_level_info.destination = null
	
	print("Active Town: " + CurrentRun.world.current_world_info.active_town)
	var active_town_scene = CurrentRun.world.current_world_info.towns_inventory[CurrentRun.world.current_world_info.active_town]["scene"]
	active_town_scene.check_warnings()
	
	for t in CurrentRun.world.current_world_info.towns_inventory:
		CurrentRun.world.current_world_info.towns_inventory[t]["scene"].hide_you_are_here()
		if CurrentRun.world.current_world_info.towns_inventory[t]["scene"].global_position.x < active_town_scene.global_position.x:
			CurrentRun.world.current_world_info.towns_inventory[t]["scene"].name_label.hide()
			CurrentRun.world.current_world_info.towns_inventory[t]["scene"].process_mode = PROCESS_MODE_DISABLED
	
	CurrentRun.world.current_world_info.towns_inventory[CurrentRun.world.current_world_info.active_town]["scene"].you_are_here()
	CurrentRun.world.storm_sprite.global_position = Vector2(active_town_scene.global_position.x - 1500, active_town_scene.global_position.y)
	return CurrentRun.world.current_world_info.active_town
	
