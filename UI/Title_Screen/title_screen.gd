extends Control

@onready var startButton : Button = %PlayButton
@onready var quitButton : Button = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startButton.pressed.connect(_on_start_button_pressed)
	quitButton.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Environment/level_01.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
