extends Node2D

@onready var rejilla_static: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _on_area_2d_up_body_entered(player: CharacterBody2D) -> void:
	var player_collision_layer: int = player.get_collision_layer()
	print_debug(player_collision_layer)
	if player_collision_layer == 16:
		rejilla_static.rotation_degrees = 180.0
		if !rejilla_static.one_way_collision:
			rejilla_static.set_deferred("one_way_collision", true)
	else:
		rejilla_static.set_deferred("one_way_collision", false)
	
func _on_area_2d_down_body_entered(player: CharacterBody2D) -> void:
	var player_collision_layer: int = player.get_collision_layer()
	print_debug(player_collision_layer)
	if player_collision_layer == 16:
		rejilla_static.rotation_degrees = 0.0
		if !rejilla_static.one_way_collision:
			rejilla_static.set_deferred("one_way_collision", true)
	else:
		rejilla_static.set_deferred("one_way_collision", false)
	
