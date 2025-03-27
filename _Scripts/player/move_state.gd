extends State


func enter():
	
	super.enter()
	
	actor.play_animation("Move")
	
	
func update(_delta: float):
	pass
	
	
func physics_update(delta: float) -> void:
	
	var move_input_direction: float = Input.get_axis("move_left", "move_right")
	
	if move_input_direction != 0:
		actor.velocity.x = move_input_direction * actor.speed
		actor.flip_sprite(move_input_direction < 0)
		
	else:
		transition_to("idle")
	
	actor.apply_gravity(delta)
	
	actor.move()
	
func handle_input(_event: InputEvent) -> void:
	
	if (Input.is_action_just_pressed("jump")) and (actor.is_on_floor()):
		transition_to("jump")
	if (Input.is_action_just_pressed("base_attack")) and (actor.can_base_attack):
		transition_to("baseattack")
	if (Input.is_action_just_pressed("range_attack")):
		transition_to("rangeattack")
	if (Input.is_action_just_pressed("transform")):
		transition_to("transform")
	
func exit() -> void:
	pass
	
