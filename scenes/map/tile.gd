extends Node2D
class_name Tile

var texture: Texture2D
var mapLoc: Vector2i

func init(loc: Vector2i, pos: Vector2):
	# Initializes the tile to a location
	mapLoc = loc
	position = pos
	texture = $Image.texture
	
func click():
	print("Clicked ", mapLoc)
