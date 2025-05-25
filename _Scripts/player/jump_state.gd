extends State

func enter():
	actor.play_animation(actor.animation_player, "jump")
	
	if actor.is_on_floor() or actor.coyote_timer_active:
		actor.jump()
		AudioManager.play_sfx("jump", 2000, actor.global_position, 2.0, randfn(0.95, 1.15))
	
func update(_delta: float):
	pass
	
func physics_update(delta: float) -> void:
	actor.apply_gravity(delta)
	
	actor.move()
	
	if actor.velocity.y > 0 and !actor.coyote_timer_active:
		transition_to("fall")
		
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("base_attack") and actor.can_perform_action("base_attack"):
		transition_to("baseattack")
	if Input.is_action_just_pressed("range_attack") and actor.can_perform_action("range_attack"):
		transition_to("rangeattack")
	if Input.is_action_just_pressed("transform") and actor.can_perform_action("transform"):
		transition_to("transform")
	
func exit() -> void:
	pass
