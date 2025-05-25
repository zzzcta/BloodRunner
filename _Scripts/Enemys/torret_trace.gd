extends Node2D

@export var speed : float = 600
@onready var punch_component: PunchTrace = $PunchComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent

var fly : bool = true

func _ready() -> void:
	punch_component.wall_collision.connect(wall_col)
	health_component.died.connect(recibir_ataque)

func _physics_process(delta: float) -> void:
	if fly: translate(Vector2.RIGHT.rotated(rotation) * delta * speed)

func wall_col() -> void:
	fly = false
	animated_sprite_2d.play("explode")
	await animated_sprite_2d.animation_finished
	queue_free()


func recibir_ataque() -> void:
	wall_col()
