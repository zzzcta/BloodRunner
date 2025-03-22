extends Area2D
class_name EnemyPunchTrace

@onready var attack : Attack = Attack.new()


func _ready() -> void:
	attack.attack_damage = 20


func _on_area_entered(area: Area2D) -> void:
	var body : HitboxComponent = area as HitboxComponent
	if body != null:
		body.damage(attack)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
