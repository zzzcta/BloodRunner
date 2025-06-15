extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var collision_shape_2d2: CollisionShape2D = $StaticBody2D2/CollisionShape2D

func _ready() -> void:
	de_activate()

func activate() -> void:
	set_visible(true)
	collision_shape_2d.disabled = false
	collision_shape_2d.disabled = false


func de_activate() -> void:
	set_visible(false)
	collision_shape_2d.disabled = true
	collision_shape_2d.disabled = true
