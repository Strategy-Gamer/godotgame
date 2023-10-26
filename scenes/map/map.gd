extends TileMap
class_name GameMap

var tiles : Dictionary
var tileTypes = {
	"Blank": TileType.new("Blank", Vector2(0,0)),
	"Sea": TileType.new("Sea", Vector2(1,0)),
	"Ocean": TileType.new("Ocean", Vector2(5,0)),
	"Grassland": TileType.new("Grassland", Vector2(0,0)),
	"Forest": TileType.new("Forest", Vector2(2,0)),
	"Mountain": TileType.new("Mountain", Vector2(4,0)),
	"Snow": TileType.new("Snow", Vector2(3,0))
}

# Tile indices
const BLANK = Vector2(0,0)
const WATER = Vector2(5,0)
const SHALLOW_WATER = Vector2(1,0)
const LAND = Vector2(0,0)
const FOREST = Vector2(2,0)
const MOUNTAIN = Vector2(4,0)
const MOUNTAIN_PEAK = Vector2(3,0)

# Map dimensions
const MAP_WIDTH = 100
const MAP_HEIGHT = 100

# Noise parameters
const NOISE_SCALE = 500
const SHALLOW_WATER_THRESHOLD = 0.4
const LAND_THRESHOLD = 0.5
const FOREST_THRESHOLD = 0.7
const MOUNTAIN_THRESHOLD = .85
const MOUNTAIN_PEAK_THRESHOLD = .97

# Seed for random number generator
var seed = 1234
var rng = RandomNumberGenerator.new()

# Initialize the FastNoiseLite object
@onready var noise = FastNoiseLite.new()

func _ready():
	create_map()
	#set_layer_enabled(1, false)

func create_map():
	seed = rng.randi_range(0,1000)
	_generate_map(seed, FastNoiseLite.TYPE_SIMPLEX)

func _generate_map(seed: int, noise_type : int):
	noise.noise_type = noise_type
	noise.seed = seed

	# Set the noise parameters
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 4
	noise.frequency  = 0.015
	noise.fractal_gain = 0.5
	noise.fractal_lacunarity = 2.0

	# Generate the continent
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			var nx = float(x) / MAP_WIDTH * NOISE_SCALE
			var ny = float(y) / MAP_HEIGHT * NOISE_SCALE
			var noise_value = noise.get_noise_2d(nx, ny)

			var center_x = MAP_WIDTH * 0.5
			var center_y = MAP_HEIGHT * 0.5
			var distance_to_center = sqrt(pow(x - center_x, 2) + pow(y - center_y, 2))
			var max_distance_to_center = sqrt(pow(MAP_WIDTH * 0.5, 2) + pow(MAP_HEIGHT * 0.5, 2))
			var center_offset = distance_to_center / max_distance_to_center

			var elevation = 1.0 - center_offset * 1.25 + noise_value * 0.3

			if elevation <= SHALLOW_WATER_THRESHOLD:
				set_hex(Vector2i(x, y), "Ocean")
			elif elevation <= LAND_THRESHOLD:
				set_hex(Vector2i(x, y), "Sea")
			elif elevation <= FOREST_THRESHOLD:
				set_hex(Vector2i(x, y), "Grassland")
			elif elevation <= MOUNTAIN_THRESHOLD:
				set_hex(Vector2i(x, y), "Forest")
			elif elevation <= MOUNTAIN_PEAK_THRESHOLD:
				set_hex(Vector2i(x, y), "Mountain")
			else:
				set_hex(Vector2i(x, y), "Snow")
			#set_cell(1, Vector2i(x, y), 0, BLANK)

func set_hex(location: Vector2i, type_name : String):
	var type = tileTypes[type_name] as TileType
	var tile
	if tiles.has(location):
		tile = tiles[location] as Tile
		tile.changeType(type)
	else:
		tile = Tile.new(location, map_to_local(location), type)
		tiles[location] = tile
	set_cell(0, location, 1, type.graphic_loc)
