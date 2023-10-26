extends Control

@export var map: GameMap

var selectedType : String

func _ready():
	selectedType = "Grassland"

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var evLocal = make_input_local(event)
		if !Rect2($PanelContainer.position,$PanelContainer.size).has_point(evLocal.position):
			if event.button_index == MOUSE_BUTTON_LEFT:
				var global_clicked = get_viewport().get_camera_2d().get_global_mouse_position() as Vector2
				var map_clicked = map.local_to_map(global_clicked) as Vector2i
				map.set_hex(map_clicked, selectedType)


func _on_grass_button_pressed():
	selectedType = "Grassland"

func _on_sea_button_pressed():
	selectedType = "Sea"

func _on_ocean_button_pressed():
	selectedType = "Ocean"

func _on_forest_button_pressed():
	selectedType = "Forest"

func _on_mountain_button_pressed():
	selectedType = "Mountain"

func _on_snow_button_pressed():
	selectedType = "Snow"
