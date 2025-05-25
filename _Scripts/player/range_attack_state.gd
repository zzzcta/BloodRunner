extends State

@export var attack_angle: float = 90.0 

var range_attack_hitbox: PackedScene = preload("res://Prefabs/Characters/Player/range_attack.tscn")
var active_range_attack_hitbox: Node2D = null
var facing_direction: Vector2
var attack_animation_completed: bool = false

func enter():
	attack_animation_completed = false
	actor.speed /= 1.85
		
	var mouse_is_left = actor.get_local_mouse_position().x < 0
	actor.attacks_sprite.flip_v = mouse_is_left
	actor.attacks_sprite.visible = false
	actor.flip_sprite(mouse_is_left)
	
	var can_attack: bool = is_in_attack_angle()
	
	if can_attack:
		actor.is_range_attacking = true
		actor.attacks_sprite.visible = true
		AudioManager.play_sfx("melee_attack_player", 450, actor.global_position, 1, randf_range(0.90, 1.15))
		actor.start_cooldown("range_attack")
		create_attack_hitbox()
	
	if actor.is_on_floor():
		actor.play_animation(actor.animation_player, "range_attack")
	else:
		actor.play_animation(actor.animation_player, "range_attack_air")
		
	if can_attack:
		actor.play_animation(actor.sfx_attacks, "range_attack")
		
	if !actor.is_on_floor():
		# Si esta en el aire, solo aplicamos componente horizontal
		actor.velocity.x -= facing_direction.x * 200
		actor.velocity.y -= facing_direction.y * 100
	else:
		# Si esta en el suelo, aplicamos el impulso completo
		actor.velocity -= facing_direction * 200
	
func update(_delta: float):
	if !attack_animation_completed and \
		(actor.animation_player.current_animation == "" or \
		 not actor.animation_player.is_playing()):
		attack_animation_completed = true
	
func physics_update(delta: float) -> void:
	# Aplicamos gravedad para asegurarnos de que el jugador se mantenga en el suelo
	actor.apply_gravity(delta)
	# Movemos el personaje (necesario para que la gravedad funcione)
	actor.move()
	
	# Si la animación ha terminado, permitimos transición
	if attack_animation_completed:
		# Si no está en el suelo transicionamos a "jump"
		if !actor.is_on_floor() and actor.velocity.y > 0:
			transition_to("fall")
		# Si está en el suelo, verificar si se está moviendo o está quieto
		elif abs(actor.velocity.x) > 0:
			transition_to("move")
		# Si no hay velocidad transicionamos a "idle"
		else:
			transition_to("idle")
	
## Llamamos a esta funcion en el frame en el que queramos que nuestro actor ataque
func create_attack_hitbox():
	if actor.is_range_attacking && active_range_attack_hitbox == null:
		active_range_attack_hitbox = range_attack_hitbox.instantiate() 
		active_range_attack_hitbox.rotation = actor.spawn_base_attack.rotation
		active_range_attack_hitbox.player_look_direction = (actor.get_global_mouse_position() - actor.position).normalized()
		active_range_attack_hitbox.attack_damage = actor.range_attack_damage
		get_tree().current_scene.add_child(active_range_attack_hitbox)
		
		actor.attacks_sprite.rotation = actor.spawn_base_attack.rotation
		active_range_attack_hitbox.global_position = actor.spawn_base_attack.global_position
	
func handle_input(_event: InputEvent) -> void:
	pass
	
func exit():
	actor.speed *= 1.85
	actor.attacks_sprite.visible = false
	
# Función principal para verificar si está dentro del ángulo de ataque
func is_in_attack_angle() -> bool:
	var reference_direction = Vector2.RIGHT
	if actor.get_local_mouse_position().x < 0:
		reference_direction = Vector2.LEFT
	
	facing_direction = (actor.get_global_mouse_position() - actor.global_position).normalized()
	
	var angle_diff = abs(rad_to_deg(reference_direction.angle_to(facing_direction)))
	
	return angle_diff <= (attack_angle / 2)
func start_range_attack_timer() -> void:
	# Crear un temporizador para finalizar el ataque
	var range_attack_timer: SceneTreeTimer = get_tree().create_timer(0.35)
	range_attack_timer.timeout.connect(func():
		actor.attacks_sprite.visible = false
		actor.is_range_attacking = false
		active_range_attack_hitbox = null  # Limpiamos la referencia
		)
