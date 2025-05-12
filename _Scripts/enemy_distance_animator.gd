extends AnimationPlayer
class_name EnemyDistanceAnimator

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var shoot_point: Node2D = $"../ShootHandler/ShootPoint"

var direction : Vector2
var is_flip : bool = false 

func animate(player_ref : Vector2) -> void:
	direction = get_parent().position.direction_to(player_ref)
	
	is_flip = true if direction.x < 0  else false
	sprite_2d.flip_h = is_flip
