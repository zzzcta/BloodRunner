extends State

func enter():
	
	super.enter()
	
	actor.play_animation("BaseAttack")
	
	actor.can_base_attack = false
	await get_tree().create_timer(actor.base_attack_cooldown).timeout
	actor.can_base_attack = true
	
func update(_delta: float):
	
	if not actor.is_on_floor():
		actor.on_air = true
	
func physics_update(delta: float) -> void:
	
	if actor.is_on_floor() and actor.velocity.x == 0:
		transition_to("idle")
	
	if actor.is_on_floor() and (abs(actor.velocity.x) > 0):
		transition_to("move")
		
	if actor.on_air:
		transition_to("jump")
	
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	# Movemos el personaje (necesario para que la gravedad funcione)
	actor.move()
	
	
func handle_input(_event: InputEvent) -> void:
	
	
	if (Input.is_action_just_pressed("move_left")) or (Input.is_action_just_pressed("move_right")):
		transition_to("move")
	if (Input.is_action_just_pressed("jump")) and (actor.is_on_floor()):
		transition_to("jump")
	if (Input.is_action_just_pressed("transform")):
		transition_to("transform")
		
