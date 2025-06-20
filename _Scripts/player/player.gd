class_name Player
extends CharacterBody2D

# Variables referentes al movimiento y la fisica del actor
@export_subgroup("Movimiento y física")
@export var speed: float = 300.0  # Velocidad base de movimiento
@export var jump_force: float = 315.0  # Fuerza de salto vertical
@export var gravity: float = 1200.0  # Fuerza de gravedad aplicada al actor

# Variables referentes al combate y habilidades del actor
@export_subgroup("Combate y habilidades")
@export var cooldown_durations: Dictionary[String, float] = {
	"base_attack" : 0.15,
	"range_attack" : 0.5,
	"transform" : 10.0
}

var cooldowns: Dictionary[String, float] = {
	"base_attack" : 0,
	"range_attack" : 0,
	"transform" : 0
}

@export var transform_duration: float = 5.0  ## Duracion de la transformacion en charco de sangre
@export var base_attack_damage: float = 5.0
@export var range_attack_damage: float = 10.0


#region Referencias a nodos internos
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var transform_back: AnimationPlayer = $TransformBack2
@onready var transform_front: AnimationPlayer = $TransformFront2
@onready var sfx_attacks: AnimationPlayer = $AttackSfx
@onready var player_sprite: Sprite2D = $SpritePlayer
@onready var attacks_sprite: Sprite2D = $SpriteAtaques
@onready var transform_front_sprite: Sprite2D = $TransformFront
@onready var transform_back_sprite: Sprite2D = $TransformBack
@onready var state_machine: StateMachine = $StateMachine
@onready var blood: GPUParticles2D = $GPUParticles2D 
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var spawn_base_attack: Marker2D = $Marker2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitBoxComponent = $HitboxComponent
@onready var ray_cast_up: RayCast2D = $RayCastUp 
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var crosshair: CanvasLayer = $Crosshair
#endregion

var player_look_direction: Vector2
var impulse_time: float = 0.15
var impulse_time_left: float = 0.0
var transform_duration_left: float = 0.0
var health_recover: float 
@export var coyote_timer_active: bool

#region Estados del player
var decreasing_health: bool = false
var is_base_attacking: bool 
var is_range_attacking: bool 
var is_transformed: bool = false  
var is_dead: bool = false
var is_impulse: bool
#endregion

func _ready() -> void:
#region Señales
	# Señales externas
	SignalBuss.enemy_died.connect(_on_enemy_died)
	SignalBuss.level_started.connect(_on_level_started)
	SignalBuss.level_finished.connect(_on_level_finished)
	SignalBuss.player_entered_car_exit.connect(_on_player_entered_car_exit)
	SignalBuss.turned_sprite_left.connect(_on_turned_sprite_left)
	SignalBuss.turned_sprite_right.connect(_on_turned_sprite_right)
	# Señales internas
	state_machine.state_changed.connect(_on_state_changed) # Para monitoreo
	health_component.died.connect(_on_dead)
	health_component.hit.connect(_on_player_hit)
#endregion
	ray_cast_up.enabled = false
	ray_cast_down.enabled = false
	
func _process(delta):
#region Gestion del decreasing_health
	# Comprobamos que el efecto de decreasing_health este activo
	if decreasing_health and !is_dead:
		if is_transformed:
			health_component.current_health -= delta * 3 # Restamos la vida actual con delta
		else:
			health_component.current_health -= delta # Restamos la vida actual con delta
			
		SignalBuss.update_health(health_component.current_health, health_component.max_health)
		# Si ya nuestra vida es <= 0 y no estamos muertos, nos morimos :=(
		if health_component.current_health <= 0 and !is_dead:
			_on_dead()
#endregion
	
#region Gestion de cooldowns
	# Reducir los cooldowns activos cada frame
	for action in cooldowns.keys():
		if cooldowns[action] > 0:
			cooldowns[action] -= delta
#endregion

	if is_impulse:
		impulse_time_left -= delta
		if impulse_time_left <= 0:
			is_impulse = false
		
	if self.is_on_floor() and coyote_timer_active == false:
		coyote_timer_active = true
		
	if !self.is_on_floor():
		if coyote_timer.is_stopped():
			coyote_timer.start()
	
# Imprimira por la terminal el new_state en el cual se encuentra el actor
func _on_state_changed(new_state: String) -> void:
	print("Jugador cambió al estado: " + new_state)

# Aplicar la gravedad al actor
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

# Aplica el movimiento al actor
func move() -> float:
	
	var move_direction: float = Input.get_axis("move_left", "move_right")
	
	if !is_impulse:
		# Comprobamos que nos estamos moviendo
		if move_direction != 0:
			# Ajustamos la velocidad horizontal basada en la direccion
			velocity.x = move_direction * speed
			# Giramos el sprite segun la direccion
			flip_sprite(move_direction < 0)
		else:
			# Si no hay input de movimiento, desaceleramos hasta detenernos
			velocity.x *= 0.6  # Mantienes el 60% de la velocidad en cada frame
			if abs(velocity.x) < 5.0: # Detener cuuando va lentillo ya
				velocity.x = 0.0  
				
	
	move_and_slide()
	
	return move_direction # Para que podamos utilizar el valor de move_direction en cualquier estado

func jump() -> void:
	velocity.y -= jump_force
	
func play_animation(animation_player_name: AnimationPlayer, animation_name: String, backwards: bool = false) -> void:
	# Comprobamos que existe la animacion que hayamos pasado como parametro en nuestro AnimationPlayer
	if animation_player_name.has_animation(animation_name): 
		# Si pasamos backwards como true se ejecutara la animacion al reves
		if backwards:
			animation_player_name.play_backwards(animation_name)
		else:
			animation_player_name.play(animation_name)
	# Si no existe mandamos un error a consola
	else:
		push_warning("Animación no encontrada: " + animation_name)

# Da la vuelta al sprite segun si el parametro es true o false
func flip_sprite(flip: bool) -> void:
	player_sprite.flip_h = flip

## Accede a la state_machine y cambia el estado actual por "dead"
func _on_dead() -> void:
	if !is_dead:
		SignalBuss.update_health(health_component.current_health, health_component.max_health)
		state_machine.change_state("dead")
	
	await get_tree().create_timer(1.5).timeout
	
	var tween: Tween = create_tween()
	
	tween.tween_property(camera_2d, "zoom", Vector2(2.2, 2.2), 0.8)
	
#region funciones cooldown habilidades
## En el caso de que el cooldown haya terminado devolvemos true 
func can_perform_action(action_name: String) -> bool:
	return cooldowns[action_name] <= 0

## Inicia el cooldown de una habilidad
func start_cooldown(action_name: String) -> void:
	cooldowns[action_name] = cooldown_durations[action_name]
#endregion

#region signals
func _on_level_started(_level: int) -> void:
	decreasing_health = true

func _on_level_finished() -> void:
	decreasing_health = false

func _on_player_entered_car_exit(door_exit_position: Vector2, _target_scene: String, _transition_message: String) -> void:
	crosshair.visible = false
	self.global_position = door_exit_position
	var tween: Tween = create_tween()
	tween.tween_property(player_sprite, "self_modulate", Color(1, 1, 1, 0), 0.08)
	
func _on_enemy_died(player_health_recover: float, _enemy_die_position: Vector2) -> void:
	if health_component.current_health <= health_component.max_health - player_health_recover:
		health_component.current_health = lerpf(
			health_component.current_health, 
			health_component.current_health + player_health_recover,
			0.6)
	else: 
		health_component.current_health = health_component.max_health

func _on_player_hit() -> void:
	state_machine.change_state("hit")

func _on_coyote_timer_timeout() -> void:
	coyote_timer_active = false
	
func on_start_dialogue() -> void:
	SignalBuss.disconnect("turned_sprite_left", _on_turned_sprite_left)
	SignalBuss.disconnect("turned_sprite_right", _on_turned_sprite_right)
	crosshair.visible = false
	state_machine.change_state("inactive")
	
	
func on_finish_dialogue() -> void:
	SignalBuss.connect("turned_sprite_left", _on_turned_sprite_left)
	SignalBuss.connect("turned_sprite_right", _on_turned_sprite_right)
	crosshair.visible = true
	state_machine.change_state("idle")
	

func _on_turned_sprite_left() -> void:
	if state_machine.current_state.name not in ["Move", "Jump", "Fall"]:
		flip_sprite(true)
	
func _on_turned_sprite_right() -> void:
	if state_machine.current_state.name not in ["Move", "Jump", "Fall"]:
		flip_sprite(false)
	
#endregion
