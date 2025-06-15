extends State

func enter():
	actor.play_animation(actor.animation_player, "fall")
	
	actor.coyote_timer.start()
	
func update(_delta: float):
	pass
	
func physics_update(delta: float) -> void:
	actor.apply_gravity(delta)
	
	actor.move()
	
	if actor.is_on_floor():
		if actor.velocity.x == 0:
			transition_to("idle")
		else:
			transition_to("move")
		
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
	if get_viewport().get_mouse_position().x > 320:
		actor.flip_sprite(false)
			
	if get_viewport().get_mouse_position().x < 320:
		actor.flip_sprite(true)


func _on_coyote_timer_timeout() -> void:
	actor.coyote_timer_active = false
