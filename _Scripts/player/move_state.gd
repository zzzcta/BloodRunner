extends State


func enter():
	
	super.enter()
	
	actor.play_animation("Move")
	
func update(_delta: float):
	pass

func physics_update(delta: float) -> void:
	
	var move_direction: float = actor.move()
	
	 # Si estamos casi detenidos, transicionamos a idle
	if move_direction == 0 and abs(actor.velocity.x) < 10:
		transition_to("idle")
	
	
	actor.apply_gravity(delta)
	
	actor.move_and_slide()
	
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
	
