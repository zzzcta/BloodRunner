extends State

func enter():
	actor.play_animation(actor.animation_player, "idle")
	
func update(_delta: float):
	if !actor.is_on_floor() and actor.velocity.y > 0:
		transition_to("fall")
		
func physics_update(delta: float) -> void:
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	# Movemos el personaje (necesario para que la gravedad funcione)
	actor.move_and_slide()
	
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		transition_to("move")
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		transition_to("jump")
	if Input.is_action_just_pressed("base_attack") and actor.can_perform_action("base_attack"):
		transition_to("baseattack")
	if Input.is_action_just_pressed("range_attack") and actor.can_perform_action("range_attack"):
		transition_to("rangeattack")
	if Input.is_action_just_pressed("transform") and actor.can_perform_action("transform"):
		transition_to("transform")
