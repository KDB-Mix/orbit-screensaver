class_name Orb
extends RigidBody2D
var orbpics: Array
@onready var orb: Sprite2D = $Orb
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_damp = 1
	angular_damp = 1
	#for f in DirAccess.get_files_at("res://orbs"):
		#if f.ends_with(".png"):
			#orbpics.append(f)
	#var img = load("res://orbs/"+orbpics[randi() % orbpics.size()])
	#orb.texture = img

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
