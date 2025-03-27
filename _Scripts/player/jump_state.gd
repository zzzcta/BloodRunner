extends State

func enter():
	
	super.enter()
	
	actor.play_animation("jump")
	
	actor.on_air = true
	
func update(_delta: float):
	pass
	
	
func physics_update(delta: float) -> void:
	
	# No se me ocurre de otra para moverte mientras saltes sin copiar pegar el de move
	
	var jump_input_direction: float = Input.get_axis("move_left", "move_right")
	
	if jump_input_direction != 0:
		actor.velocity.x = jump_input_direction * actor.speed
		actor.flip_sprite(jump_input_direction < 0)
		
	if actor.is_on_floor():
		actor.velocity.y -= actor.jump_force
		
	actor.apply_gravity(delta)
	
	actor.move()
	
	if actor.is_on_floor() and actor.velocity.x == 0:
		transition_to("idle")
	
	if actor.is_on_floor() and (abs(actor.velocity.x) > 0):
		transition_to("move")

	
func handle_input(_event: InputEvent) -> void:
	
	if (Input.is_action_just_pressed("base_attack")) and (actor.can_base_attack):
		transition_to("baseattack")
	if (Input.is_action_just_pressed("range_attack")):
		transition_to("rangeattack")
	if (Input.is_action_just_pressed("transform")):
		transition_to("transform")
	
func exit() -> void:
	
	actor.on_air = false
