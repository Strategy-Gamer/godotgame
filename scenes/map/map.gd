extends TileMap
class_name GameMap

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
				set_cell(0, Vector2i(x, y), 1, WATER)
			elif elevation <= LAND_THRESHOLD:
				set_cell(0, Vector2i(x, y), 1, SHALLOW_WATER)
			elif elevation <= FOREST_THRESHOLD:
				set_cell(0, Vector2i(x, y), 1, LAND)
			elif elevation <= MOUNTAIN_THRESHOLD:
				set_cell(0, Vector2i(x, y), 1, FOREST)
			elif elevation <= MOUNTAIN_PEAK_THRESHOLD:
				set_cell(0, Vector2i(x, y), 1, MOUNTAIN)
			else:
				set_cell(0, Vector2i(x, y), 1, MOUNTAIN_PEAK)
			#set_cell(1, Vector2i(x, y), 0, BLANK)
