extends Node2D

@export var speed : float = 600


func _physics_process(delta: float) -> void:
	translate(Vector2.RIGHT.rotated(rotation) * delta * speed)
