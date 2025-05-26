extends State

var base_attack_hitbox: PackedScene = preload("res://Prefabs/Characters/Player/base_attack.tscn")
var active_base_attack_hitbox: Node2D = null

func enter():
	actor.is_base_attacking = true
	
	AudioManager.play_sfx("melee_attack_player", 450, actor.global_position, 1, randf_range(0.90, 1.15))
	
	actor.is_impulse = true
	
	if actor.get_local_mouse_position().x < 0:
		actor.attacks_sprite.flip_v = true
	else:
		actor.attacks_sprite.flip_v = false
		
	actor.attacks_sprite.visible = true
	
	actor.flip_sprite(actor.get_local_mouse_position().x < 0)
	
	actor.play_animation(actor.animation_player, "base_attack")
	actor.play_animation(actor.sfx_attacks, "base_attack")
	
	var click_position: Vector2 = actor.get_global_mouse_position()
	
	var direction: Vector2 = (click_position - actor.global_position).normalized()
	
	if !actor.is_on_floor():
		#Si esta en el aire, solo aplicamos componente horizontal
		actor.velocity.x += direction.x * 300
		actor.velocity.y += direction.y * 150
	else:
		#Si esta en el suelo, aplicamos el impulso completo
		actor.velocity += direction * 300
	
	# Crear un temporizador para finalizar el impulso
	var impulse_timer: SceneTreeTimer = get_tree().create_timer(actor.impulse_time)
	impulse_timer.timeout.connect(func():
		actor.is_impulse = false
		actor.impulse_time_left = actor.impulse_time
	)
	
	# Crear un temporizador para finalizar el ataque
	var base_attack_timer: SceneTreeTimer = get_tree().create_timer(0.4)
	base_attack_timer.timeout.connect(func():
		actor.is_base_attacking = false
		actor.attacks_sprite.visible = false
		# Iniciar el cooldown cuando termine el ataque
		actor.start_cooldown("base_attack")
	)
	
	var base_attack_hitbox_duration: SceneTreeTimer = get_tree().create_timer(0.15)
	base_attack_hitbox_duration.timeout.connect(func():
		if active_base_attack_hitbox:
			active_base_attack_hitbox.queue_free()
			active_base_attack_hitbox = null
		)
	 
func update(_delta: float):
	pass

func physics_update(delta: float) -> void:
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	# Movemos el personaje (necesario para que la gravedad funcione)
	actor.move()
	
	if !actor.is_base_attacking:
		# Primero verificamos si esta en el aire
		if !actor.is_on_floor() and actor.velocity.y > 0:
			transition_to("fall")
		# Si esta en el suelo, verificar si se está moviendo o está quieto
		elif abs(actor.velocity.x) > 0:
			transition_to("move")
		else:
			transition_to("idle")
	
## Llamamos a esta funcion en el frame en el que queramos que nuestro personaje ataque
func create_attack_hitbox() -> void:
	if active_base_attack_hitbox == null: 
		active_base_attack_hitbox = base_attack_hitbox.instantiate()
		active_base_attack_hitbox.attack_damage = actor.base_attack_damage
		get_tree().current_scene.add_child(active_base_attack_hitbox)
	
	active_base_attack_hitbox.global_position = actor.spawn_base_attack.global_position
	actor.attacks_sprite.rotation = actor.spawn_base_attack.rotation
	
func handle_input(_event: InputEvent) -> void:
	pass
	
func exit():
	pass
	
