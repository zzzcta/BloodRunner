extends Node2D

var is_moving: bool = false

func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("Idle")
	
func _process(delta: float) -> void:
	if is_moving:
		$".".position.x -= 300 * delta
		await get_tree().create_timer(1.5).timeout
		queue_free()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	await get_tree().create_timer(1.5).timeout
	is_moving = true
