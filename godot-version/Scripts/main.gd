extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConfigSave.load_config()
	var args = OS.get_cmdline_args()
	if "-s" in args:
		get_tree().change_scene_to_file("res://Scenes/screensaver.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/config.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
