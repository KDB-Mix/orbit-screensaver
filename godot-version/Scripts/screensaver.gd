extends Node2D
@onready var bottom_plane: CollisionShape2D = $StaticBody2D/bottomPlane
@onready var right_plane: CollisionShape2D = $StaticBody2D/rightPlane
@onready var left_plane: CollisionShape2D = $StaticBody2D/leftPlane
@onready var orb_timer: Timer = $orbTimer
@onready var end_timer: Timer = $endTimer
@onready var start_over_timer: Timer = $startOverTimer
@onready var pre_start_over_timer: Timer = $preStartOverTimer

@onready var orb = preload("res://Scenes/orb.tscn")
var orbindex: int
var orbcount = ConfigSave.settings["ballCount"]
#var orbcount = 10
var windowsize: Vector2i
var showPlayer: bool
var img: Resource
var playerIndex: int
var orbpics = [
	"res://orbs/orb1.png",
	"res://orbs/orb2.png",
	"res://orbs/orb3.png",
	"res://orbs/orb4.png",
	"res://orbs/orb5.png",
	"res://orbs/orb6.png",
	"res://orbs/orb7.png",
	"res://orbs/orb8.png",
	"res://orbs/orb9.png",
    "res://orbs/orb10.png"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().transparent_bg = ConfigSave.settings["transparentBG"]
	RenderingServer.set_default_clear_color(Color(ConfigSave.settings["bgColor"]))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	windowsize = DisplayServer.window_get_size()
	#DisplayServer.window_set_size(Vector2i(1280, 720))
	bottom_plane.global_position.y = windowsize.y
	right_plane.global_position.x = windowsize.x
	left_plane.global_position.x = 0
	orb_timer.wait_time = randf_range(.5, 2)
	orb_timer.start()
	showPlayer = bool(randi() % 2)
	if showPlayer:
		playerIndex = randi_range(1, 10)


# Called every frame. 'delta' is the elapsed time since the 


func _on_orb_timer_timeout() -> void:
	start_over_timer.stop()
	orbindex += 1
	var newOrb: Orb = orb.instantiate()
	add_child(newOrb)
	newOrb.global_position.y = -250
	newOrb.global_position.x = (windowsize.x * 0.7 / 2) * min((orbindex + 50) / orbcount, orbcount) * randf_range(-1.0, 1.0) + windowsize.x / 2
	var randomScale: float = randf_range(1, 2)
	if showPlayer and orbindex == playerIndex:
		img = load("res://cube.png")
		newOrb.orb.texture = img
		newOrb.collision_shape_2d.disabled = true
		newOrb.collision_shape_2d_2.disabled = false
		newOrb.orb.scale *= Vector2(1.5, 1.5)
		newOrb.collision_shape_2d_2.scale *= Vector2(1.5, 1.5)
	else:
		img = load(orbpics[randi() % orbpics.size()])
		print(orbpics)
		newOrb.orb.texture = img
		newOrb.collision_shape_2d.disabled = false
		newOrb.collision_shape_2d_2.disabled = true
		newOrb.orb.scale *= Vector2(randomScale, randomScale)
		newOrb.collision_shape_2d.scale *= Vector2(randomScale, randomScale)
	newOrb.apply_impulse(Vector2(randf()/4.0, 0))
	orb_timer.wait_time = randf_range(.5, 2)
	if orbindex >= orbcount:
		end()
		return
		
func end():
	orb_timer.stop()
	showPlayer = (randf() < ConfigSave.settings["showPlayer"])
	if showPlayer:
		playerIndex = randi_range(ceil(orbcount/4.0), orbcount)
	orbindex = 0
	orb_timer.wait_time = randf_range(.5, 2)
	end_timer.start()


func _on_end_timer_timeout() -> void:
	end_timer.stop()
	bottom_plane.disabled = true
	pre_start_over_timer.start()


func _on_start_over_timer_timeout() -> void:
	start_over_timer.stop()
	for object in get_children():
		if object is Orb:
			object.queue_free()
	orb_timer.start()


func _on_pre_start_over_timer_timeout() -> void:
	pre_start_over_timer.stop()
	bottom_plane.disabled = false
	start_over_timer.start()
