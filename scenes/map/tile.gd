extends Node2D
class_name Tile

var mapLoc: Vector2i
var tileType: TileType

func _init(loc: Vector2i, pos: Vector2, type: TileType):
	# Initializes the tile to a location
	mapLoc = loc
	position = pos
	tileType = type
	
func click() -> Tile:
	print("Clicked ", mapLoc, ": ", tileType.tile_name)
	return self

func changeType(type: TileType) -> Tile:
	tileType = type
	# TODO: Implement changes to tile behavior
	return self
