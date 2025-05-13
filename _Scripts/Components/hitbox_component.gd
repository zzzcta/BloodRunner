extends Area2D
class_name HitBoxComponent

signal attack (actor)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(actor: Node2D) -> void:
		print("Body entered: ", actor.name)
		if actor.has_node("HealthComponent"):
			print("HealthComponent found, emitting attack signal")
			attack.emit(actor)
		else:
			print("No HealthComponent found on ", actor.name)
