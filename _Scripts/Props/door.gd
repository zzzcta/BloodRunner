class_name Door
extends Node2D

@onready var health_component: HealthComponent = $StaticBody2D/HealthComponent

func _ready() -> void:
	health_component.died.connect(on_door_died)
	
func on_door_died() -> void:
	$AnimationPlayer.play("Open")
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
