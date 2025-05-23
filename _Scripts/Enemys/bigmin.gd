extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


signal bigmin_died()

func _ready() -> void:
	health_component.died.connect(muelto)

func muelto() -> void:
	animated_sprite_2d.play("muerto")
	
	await animated_sprite_2d.animation_finished
	
	health_component.queue_free()
	collision_shape_2d.disabled = true
	
	bigmin_died.emit()
