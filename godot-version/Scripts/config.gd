extends Control
@onready var ball_count: HSlider = $"ball count"
@onready var fps: HSlider = $fps
@onready var fpscount: SpinBox = $fpscount
@onready var ball_count_count: SpinBox = $"ball count count"
@onready var transparent_bg: CheckBox = $transparentBG
@onready var bg_color: ColorPicker = $bgColor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConfigSave.load_config()
	ball_count.value = ConfigSave.settings["ballCount"]
	fps.value = ConfigSave.settings["fps"]
	transparent_bg.button_pressed = ConfigSave.settings["transparentBG"]
	bg_color.color = Color(ConfigSave.settings["bgColor"])
	ball_count_count.value = ball_count.value
	fpscount.value = fps.value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ball_count_count.value = ball_count.value
	fpscount.value = fps.value


func _on_apply_button_button_down() -> void:
	ConfigSave.settings["ballCount"] = ball_count.value
	ConfigSave.settings["fps"] = fps.value
	ConfigSave.settings["transparentBG"] = transparent_bg.button_pressed
	ConfigSave.settings["bgColor"] = str(bg_color.color.to_html())
	ConfigSave.save_config()
	
	
func _on_ball_count_count_value_changed(value):
	ball_count.value = value

func _on_fpscount_value_changed(value):
	fps.value = value
