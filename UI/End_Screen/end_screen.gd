extends Control

@onready var titleButton = %TitleButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	titleButton.pressed.connect(_on_title_button_pressed)
	

func _on_title_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Title_Screen/title_screen.tscn")
