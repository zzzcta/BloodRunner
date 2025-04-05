extends State


func enter():
	
	actor.sprite.visible = false
	actor.blood.visible = true
	actor.speed *= 1.15
	actor.can_transform = false
	actor.collision_shape.scale = Vector2(0.2, 0.2)
	actor.collision_shape.rotation_degrees = 90.0
	actor.set_collision_layer_value(2, false)
	actor.set_collision_layer_value(5, true)
	actor.set_collision_mask_value(3, false)
	actor.is_transformed = true
	await get_tree().create_timer(actor.transform_duration).timeout
	actor.is_transformed = false
	
func update(_delta: float):
	
	if (actor.is_on_floor()) and (actor.velocity.x == 0) and (actor.is_transformed == false):
		transition_to("idle")
	
	if (actor.is_on_floor()) and (abs(actor.velocity.x) > 0) and (actor.is_transformed == false):
		transition_to("move")
		
	if actor.on_air and (actor.is_transformed == false):
		transition_to("jump")
	
func physics_update(delta: float) -> void:
	
	if actor.is_on_floor() and Input.is_action_just_pressed("jump"):
		actor.jump()
		
	actor.move()
	
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	
	# necesario para que la gravedad funcione
	actor.move_and_slide()
	
	
func handle_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("transform"):
		actor.is_transformed = false
	
func exit() -> void:
	
	actor.sprite.visible = true
	actor.blood.visible = false
	actor.speed /= 1.15
	actor.collision_shape.scale = Vector2(1, 1)
	actor.collision_shape.rotation_degrees = 0.0
	actor.set_collision_layer_value(2, true)
	actor.set_collision_layer_value(5, false)
	actor.set_collision_mask_value(3, true)
	
