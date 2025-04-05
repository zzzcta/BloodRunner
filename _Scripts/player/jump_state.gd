extends State

func enter():
	
	super.enter()
	
	actor.play_animation("Jump")
	
	if actor.is_on_floor():
		actor.jump()
		
	actor.on_air = true
	
func update(_delta: float):
	pass
	
	
func physics_update(delta: float) -> void:
	
	
	actor.apply_gravity(delta)
	
	actor.move()
	
	actor.move_and_slide()
	
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
