extends Node2D
class_name HealthComponent

signal died()

@export var max_health: float = 10 
var current_health: float


func _ready() -> void:
	current_health = max_health  

func damage(attack: Attack):
	current_health -= attack.attack_damage
	
	if current_health <= 0:
		emit_signal("died")
