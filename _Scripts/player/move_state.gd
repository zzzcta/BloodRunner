extends State

func enter():
	actor.play_animation(actor.animation_player, "move")
	
func update(_delta: float):
	pass

func physics_update(delta: float) -> void:
	actor.apply_gravity(delta)
	
	var move_direction: float = actor.move()
	
	# Si estamos casi detenidos, transicionamos a idle
	if move_direction == 0 and abs(actor.velocity.x) < 5 and actor.is_on_floor():
		transition_to("idle")
	
	if actor.velocity.y > 0 and !actor.is_on_floor():
		transition_to("fall")
		
	if actor.velocity.y < 0:
		transition_to("jump")
	
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and actor.coyote_timer_active:
		transition_to("jump")
	if Input.is_action_just_pressed("base_attack") and actor.can_perform_action("base_attack"):
		transition_to("baseattack")
	if Input.is_action_just_pressed("range_attack") and actor.can_perform_action("range_attack"):
		transition_to("rangeattack")
	if Input.is_action_just_pressed("transform") and actor.can_perform_action("transform"):
		transition_to("transform")
	
func exit() -> void:
	pass
	
