extends State

func enter():
	actor.player_sprite.visible = true
	
	actor.play_animation(actor.animation_player, "dead")
	
	actor.is_dead = true
	
func update(_delta: float):
	pass
	
func physics_update(delta: float) -> void:
	actor.apply_gravity(delta)
	
	actor.move_and_slide()
	
	if actor.is_on_floor():
		actor.velocity = Vector2(0, 0)
	
func exit() -> void:
	pass
	
