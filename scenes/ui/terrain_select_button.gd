extends Control

signal terrain_selected

func _on_texture_button_button_down():
	emit_signal("terrain_selected")
