extends PlayerAttack

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player_look_direction: Vector2
var bullet_speed: float = 300.0
var proyectile_live_duration: float = 3.0
var colliding: bool = false
func _ready() -> void:
	super()
	animation_player.play("projectile_travel")
	
func _process(delta: float) -> void:
	
	if !colliding:
		position += player_look_direction * bullet_speed * delta 
		
	proyectile_live_duration -= delta
	if proyectile_live_duration <= 0:
		queue_free()
		
func _on_hitbox_component_attack(actor: Node2D) -> void:
	super(actor)
	
	colliding = true
	
	animation_player.play("projectile_explosion")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "projectile_explosion":
		queue_free()

func _on_hit_box_component_body_entered(_body: Node2D) -> void:
	colliding = true
	animation_player.play("projectile_explosion")
