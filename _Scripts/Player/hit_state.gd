extends State

var animation_finished: bool

func enter():
	actor.velocity = Vector2(0, 0)
	actor.play_animation(actor.animation_player, "hit")
	
func physics_update(delta: float) -> void:
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	# Movemos el personaje (necesario para que la gravedad funcione)
	actor.move_and_slide()
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		if actor.is_on_floor():
			transition_to("idle")
		else:
			transition_to("fall")
