extends State

@onready var crosshair: CanvasLayer = get_tree().current_scene.get_node("Crosshair")

func enter():
	actor.transform_duration_left = actor.transform_duration
	
	actor.transform_front_sprite.visible = true
	actor.transform_back_sprite.visible = true
	
	crosshair.visible = false
	
	actor.hitbox_component.get_node("CollisionShape2D").scale = Vector2(0.2, 0.4)
	actor.hitbox_component.get_node("CollisionShape2D").rotation_degrees = 90.0
	
	actor.play_animation(actor.transform_front, "grt_front")
	actor.play_animation(actor.transform_back, "grt_back")
	
	actor.is_transformed = true
	
	actor.ray_cast_up.enabled = true
	actor.ray_cast_down.enabled = true
	
	var animations_timer: SceneTreeTimer = get_tree().create_timer(0.56)
	animations_timer.timeout.connect(func():
		actor.set_collision_layer_value(2, false)
		actor.set_collision_layer_value(5, true)
		actor.set_collision_mask_value(3, false)
		actor.set_collision_mask_value(4, true)
		actor.blood.visible = true
		actor.speed *= 1.10
		actor.collision_shape.scale = Vector2(0.2, 0.4)
		actor.collision_shape.rotation_degrees = 90.0
		actor.player_sprite.visible = false
	)
	
	
func update(_delta: float):
	if !actor.is_transformed:
		if actor.is_on_floor() and actor.velocity.x == 0:
			transition_to("idle")
		elif abs(actor.velocity.x) > 0:
			transition_to("move")
		elif !actor.is_on_floor():
			transition_to("fall")
	
	if actor.ray_cast_up.is_colliding() and actor.ray_cast_down.is_colliding() and !actor.is_transformed:
		transition_to("dead")
		
	if actor.is_on_floor() and Input.is_action_just_pressed("jump"):
		actor.jump()
	
func physics_update(delta: float) -> void:
	actor.blood.rotation = lerpf(actor.blood.rotation, actor.velocity.angle(), 1)
	
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	
	actor.move()
	
	if actor.is_transformed:
		actor.transform_duration_left -= delta
		if actor.transform_duration_left <= 0:
			actor.is_transformed = false
	
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("transform") and actor.is_transformed:
		actor.is_transformed = false
	
func exit() -> void:
	actor.transform_duration_left = actor.transform_duration
	
	actor.hitbox_component.get_node("CollisionShape2D").shape.radius =  float(11.5)
	
	if !(actor.ray_cast_up.is_colliding() and actor.ray_cast_down.is_colliding() and !actor.is_transformed):
		actor.transform_front_sprite.visible = true
		actor.transform_back_sprite.visible = true
		
		crosshair.visible = true
		
		actor.play_animation(actor.transform_front, "grt_front", true)
		actor.play_animation(actor.transform_back, "grt_back", true)
		
		actor.start_cooldown("transform")
		
		# Crear un temporizador para finalizar el ataque
		var animations_timer:SceneTreeTimer = get_tree().create_timer(0.56)
		animations_timer.timeout.connect(func():
			actor.blood.visible = false
			actor.speed /= 1.10
			actor.collision_shape.scale = Vector2(1, 1)
			actor.hitbox_component.get_node("CollisionShape2D").scale = Vector2(1, 1)
			actor.hitbox_component.get_node("CollisionShape2D").rotation_degrees = 0.0
			actor.collision_shape.rotation_degrees = 0.0
			actor.set_collision_layer_value(2, true)
			actor.set_collision_layer_value(5, false)
			actor.set_collision_mask_value(3, true)
			actor.set_collision_mask_value(4, false)
			actor.player_sprite.visible = true
			actor.ray_cast_up.enabled = false
			actor.ray_cast_down.enabled = false
		)
	
func _on_transform_back_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "grt_back":
		actor.transform_front_sprite.visible = false
		
func _on_transform_front_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "grt_front":
		actor.transform_back_sprite.visible = false
