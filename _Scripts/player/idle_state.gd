class_name IdleState
extends State

func enter():
	
	super.enter()
	
	actor.play_animation("idle")
	
	actor.velocity.x = 0
	
	
func update(_delta: float):
	pass
	
func physics_update(delta: float) -> void:
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	# Movemos el personaje (necesario para que la gravedad funcione)
	actor.move()
	
	## Bloque para que transicione de estado a salto en caso de que se este cayendo
	#if not actor.is_on_floor() and actor.velocity.y > 0:
		#transition_to("jump")
	
func handle_input(_event: InputEvent) -> void:
	

	if (Input.is_action_pressed("move_left")) or (Input.is_action_pressed("move_right")):
		transition_to("move")
	if (Input.is_action_just_pressed("jump")) and (actor.is_on_floor()):
		transition_to("jump")
	if (Input.is_action_just_pressed("base_attack")) and (actor.can_base_attack):
		transition_to("baseattack")
	if (Input.is_action_just_pressed("range_attack")):
		transition_to("rangeattack")
	if (Input.is_action_just_pressed("transform")):
		transition_to("transform")
