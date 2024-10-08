extends TileMap

var altitude = FastNoiseLite.new()
@onready var astar = AStar2D.new()
var chunk_width: int = 60
var chunk_height: int = 60
var loaded_chunks: Array = []

var starting_coords = Vector2i.ZERO

var road_cells = []
var road_count: int = 4
var town_count: int = 12

var town_cells = []

var town = preload("res://scenes/town.tscn")

func _ready():
	await get_tree().create_timer(.2).timeout
	altitude.frequency = .05
	altitude.seed = randi()
	var new_cells = spawn_map(starting_coords)
	BetterTerrain.update_terrain_cells(self, 0, new_cells)
	
	spawn_astar()
	
	handle_roads()

	handle_towns()

	get_parent().camera.camera_limits.append(get_used_rect().size.x*chunk_width)
	get_parent().camera.camera_limits.append(get_used_rect().size.y*chunk_height)

	spawn_player()
	
func handle_roads():
	for i in road_count:
		var new_road = find_random_road()
		road_cells.append_array(new_road)

func handle_towns():
	for i in town_count:
		var new_town_pos = spawn_town()
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
					CurrentRun.world.current_world_info.towns_inventory[town_info]["size"] = 3
					var town_size = CurrentRun.world.current_world_info.towns_inventory[town_info]["size"]
					#CurrentRun.world.current_world_info.towns_inventory[town_info]["gunsmith"] = true
					#CurrentRun.world.current_world_info.towns_inventory[town_info]["tinkerer"] = true
					#CurrentRun.world.current_world_info.towns_inventory[town_info]["trainyard"] = true
					var possible_shops = ["gunsmith", "tinkerer", "trainyard"]
					var random_shop
					for t in town_size:
						random_shop  = possible_shops.pick_random()
						CurrentRun.world.current_world_info.towns_inventory[town_info][random_shop] = true
						possible_shops.erase(random_shop)
					new_town.set_town_info(town_info)
					valid_town = true
		
			new_town.clicked.connect(owner.town_clicked.bind(new_town))
	
	#animate towns scale with tween
	for t in CurrentRun.world.current_world_info.towns_inventory:
		var scene = CurrentRun.world.current_world_info.towns_inventory[t]["scene"]
		var scale_tween = create_tween()
		scale_tween.tween_property(scene, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_ELASTIC)
		await get_tree().create_timer(.1).timeout

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

func id(point):
	var a = point.x
	var b = point.y
	return (a + b) * (a + b + 1) / 2 + b

func find_random_road():
	var rect = get_used_rect().size

	var margin: int = 9
	var rng: int = randi_range(1,5)
	
	var random_start_x = clamp(randi_range(0,rect.x), 0+margin, rect.x-margin)
	var random_end_x = clamp(randi_range(0,rect.x), 0+margin, rect.x-margin)
	var new_road_cells = spawn_road(Vector2i(random_start_x,margin+rng), Vector2i(random_end_x, chunk_height - margin -rng))
	
	var random_start_y = clamp(randi_range(0,rect.y), 0+margin, rect.y-margin)
	var random_end_y = clamp(randi_range(0,rect.y), 0+margin, rect.y-margin)
	new_road_cells.append_array(spawn_road(Vector2i(margin+rng, random_start_y), Vector2i(chunk_width - margin-rng, random_end_y)))
	BetterTerrain.update_terrain_cells(self, 0, new_road_cells)
	return new_road_cells

func spawn_road(start, end) -> PackedVector2Array:
	var new_road_cells: PackedVector2Array = []
	var mid = Vector2i((end.x*.5)+randi_range(-5,5), (end.y*.5)+randi_range(-5,5))
	var path = astar.get_point_path(id(start),id(mid))
	for i in path:
		new_road_cells.append(i)
		BetterTerrain.set_cell(self, 0, i, 2)
	path = astar.get_point_path(id(mid),id(end))
	for i in path:
		new_road_cells.append(i)
		BetterTerrain.set_cell(self, 0, i, 2)
	return new_road_cells

func spawn_town():
	for road in road_cells:
		var random_road = road_cells.pick_random()
		if random_road.x < float(chunk_width) - 2 and random_road.y < float(chunk_height) - 2 \
		and random_road.x > 2 and random_road.y > 2:
			for neighbor in get_surrounding_cells(random_road):
				var terrain = BetterTerrain.get_cell(self, 0, neighbor)
				if terrain != 2 and terrain != 3:
					if town_cells.is_empty():
						return neighbor
					else:
						var index = 0
						for town_cell in town_cells:
							var this_pos = map_to_local(neighbor)
							var that_pos = map_to_local(town_cell)
							if this_pos.distance_to(that_pos) >= 600: #max distance to nearest town
								index += 1
						if index >= town_cells.size():
							return neighbor

func spawn_player():
	if CurrentRun.world.current_level_info.destination == null:
		var random_town = CurrentRun.world.current_world_info.towns_inventory.keys().pick_random()
		CurrentRun.world.current_world_info.active_town = random_town
	else:
		CurrentRun.world.current_world_info.active_town = CurrentRun.world.current_level_info.destination
		CurrentRun.world.current_level_info.destination = null
	print("Active Town: " + CurrentRun.world.current_world_info.active_town)
	
	get_parent().camera.jump_to_player()
	
	for t in CurrentRun.world.current_world_info.towns_inventory:
		CurrentRun.world.current_world_info.towns_inventory[t]["scene"].hide_you_are_here()
	CurrentRun.world.current_world_info.towns_inventory[CurrentRun.world.current_world_info.active_town]["scene"].you_are_here()
