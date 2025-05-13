extends Node2D
class_name PunchTrace

@onready var attack : Attack = Attack.new()

@export var dead_time : float 
@export var damage : float

var life_cont : float = 0

func _ready() -> void:
	attack.attack_damage = damage


func _process(delta: float) -> void:
	life_cont += delta
	if life_cont >= dead_time:
		get_parent().queue_free()


func _on_body_entered(body: Node2D) -> void:
	var _body: HitBoxComponent = body as HitBoxComponent
	if body != null:
		body.get_node("HealthComponent").damage(attack)
