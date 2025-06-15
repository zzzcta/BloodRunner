class_name PlayerAttack
extends Node2D

var hitbox_component: HitBoxComponent

var _attack_damage: float
var attack_damage: float:
	get:
		return _attack_damage
	set(value):
		if value <= 0:
			push_warning("Daño negativo")
		else:
			_attack_damage = value

func _ready() -> void:
	hitbox_component = get_node("HitBoxComponent") as HitBoxComponent
	hitbox_component.attack.connect(_on_hitbox_component_attack)
	
func _on_hitbox_component_attack(actor: Node2D) -> void:
	var attack: Attack = Attack.new()
	attack.attack_damage = attack_damage
	actor.get_node("HealthComponent").damage(attack)
