extends Node2D

@export var speed : float = 600
@onready var punch_component: PunchTrace = $PunchComponent


func _ready() -> void:
	punch_component.wall_collision.connect(wall_col)

func _physics_process(delta: float) -> void:
	translate(Vector2.RIGHT.rotated(rotation) * delta * speed)

func wall_col() -> void:
	queue_free()
