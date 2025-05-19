extends State

func enter():
	actor.play_animation(actor.animation_player, "activation")
	
func physics_update(delta: float) -> void:
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	# Movemos el personaje (necesario para que la gravedad funcione)
	actor.move_and_slide()
	
func handle_input(_event: InputEvent) -> void:
	pass
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "activation":
		transition_to("idle")
