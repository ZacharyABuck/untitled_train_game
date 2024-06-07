extends TileMap

var altitude = FastNoiseLite.new()
@onready var astar = AStar2D.new()
var chunk_width = 37.0
var chunk_height = 21.0
var loaded_chunks: Array = []

@onready var route_line = $RouteLine


var starting_coords = Vector2i.ZERO

var road_cells = []
var road_count: int = 1
var town_count: int = 10

var town_cells = []

var town = preload("res://scenes/town.tscn")
var world_map_player = preload("res://scenes/world_map_player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	altitude.frequency = .05
	altitude.seed = randi()
	var new_cells = spawn_map(starting_coords)
	BetterTerrain.update_terrain_cells(self, 0, new_cells)
	
	spawn_astar()
	
	handle_roads()

	handle_towns()

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
			BetterTerrain.set_cell(self, 0, new_town_pos, 3)
			
			var new_town = town.instantiate()
			new_town.global_position = map_to_local(new_town_pos)
			add_child(new_town)
			
			var valid_town: bool = false
			while valid_town == false:
				var town_info = WorldInfo.towns_roster.keys().pick_random()
				if WorldInfo.towns_inventory.keys().has(town_info):
					pass
				else:
					WorldInfo.towns_inventory[town_info] = WorldInfo.towns_roster[town_info]
					WorldInfo.towns_inventory[town_info]["scene"] = new_town
					new_town.set_town_info(town_info)
					valid_town = true
		
			new_town.clicked.connect(owner.town_clicked.bind(new_town))
			new_town.mouse_entered.connect(town_mouse_entered.bind(new_town))
			new_town.mouse_exited.connect(town_mouse_exited.bind(new_town))

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
	var mid_x = rect.x*.5
	var mid_y = rect.y*.5
	
	var random_start_x = int(mid_x+randi_range(-3,3))
	var random_end_x = int(mid_y+randi_range(-3,3))
	var new_road_cells = spawn_road(Vector2i(random_start_x,0), Vector2i(random_end_x, chunk_height - 1))
	
	var random_start_y = int(mid_y+randi_range(-3,3))
	var random_end_y = int(mid_y+randi_range(-3,3))
	new_road_cells.append_array(spawn_road(Vector2i(0, random_start_y), Vector2i(chunk_width-1, random_end_y)))
	BetterTerrain.update_terrain_cells(self, 0, new_road_cells)
	return new_road_cells

func spawn_road(start, end) -> PackedVector2Array:
	var new_road_cells: PackedVector2Array = []
	var path = astar.get_point_path(id(start),id(end))
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
							if this_pos.distance_to(that_pos) >= 300:
								index += 1
						if index >= town_cells.size():
							return neighbor

func spawn_player():
	if LevelInfo.destination == null:
		var random_town = WorldInfo.towns_inventory.keys().pick_random()
		var random_town_pos = find_town_pos(random_town)
		WorldInfo.active_town = random_town
		var road_pos = find_closest_road(random_town_pos)
		
		var new_player = world_map_player.instantiate()
		new_player.global_position = map_to_local(road_pos)
		add_child(new_player)
	else:
		var destination_town = LevelInfo.destination
		var destination_town_pos = find_town_pos(destination_town)
		var road_pos = find_closest_road(destination_town_pos)
		
		WorldInfo.world_map_player.global_position = map_to_local(road_pos)
		WorldInfo.active_town = LevelInfo.destination
		LevelInfo.destination = null
	print("Active Town: " + WorldInfo.active_town)
	var vector = WorldInfo.world_map_player.global_position - Vector2(960, 540)
	var coords = local_to_map(vector)
	spawn_map(coords)

func find_town_pos(town_name):
	for i in town_cells:
		if i == local_to_map(WorldInfo.towns_inventory[town_name]["scene"].global_position):
			return i

func find_closest_road(town_pos):
	for i in get_surrounding_cells(town_pos):
		var terrain = BetterTerrain.get_cell(self, 0, i)
		if terrain == 2:
			return i

func town_mouse_entered(town_node):
	var route_points: PackedVector2Array = []
	var start = WorldInfo.world_map_player.global_position
	var end = town_node.global_position
	route_points.append(start)
	route_points.append(end)
	route_line.points = route_points
	route_line.show()

func town_mouse_exited(_town):
	route_line.hide()
