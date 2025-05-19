extends AnimationPlayer
class_name EnemyDistanceAnimator

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var shoot_point: Node2D = $"../ShootHandler/ShootPoint"

var direction : Vector2
var is_flip : bool = false 

func animate(player_ref : Vector2, velocity : float) -> void:
	direction = get_parent().position.direction_to(player_ref)
	
	is_flip = true if direction.x < 0  else false
	sprite_2d.flip_h = is_flip
	
	if current_animation == "hit": return
	if current_animation == "shoot": return
	
	if velocity > 0:
		play("walk")
	else:
		play("idle")


func _on_shoot() -> void:
	play("shoot")


func _on_damaged() -> void:
	play("hit")
