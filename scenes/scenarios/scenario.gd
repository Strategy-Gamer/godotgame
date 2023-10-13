extends Node2D

const camera_speed = 500

func _ready():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	$Camera.position = get_viewport_rect().size / 2



func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		$Camera.position_smoothing_enabled = true
		$Camera.position += direction * delta * camera_speed / $Camera.zoom.x

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var global_clicked = $Camera.get_global_mouse_position()
			$Map.create_map()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			$Camera.position_smoothing_enabled = false
			var global_clicked = $Camera.get_global_mouse_position()
			$Camera.position = global_clicked
				
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Camera.zoom *= 0.9
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Camera.zoom *= 1.1
