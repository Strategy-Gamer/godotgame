extends Resource
class_name TileType

var tile_name : String
var graphic_loc : Vector2i

func _init(_tile_name : String, _graphic_loc : Vector2i):
	tile_name = _tile_name
	graphic_loc = _graphic_loc
