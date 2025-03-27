class_name Player
extends CharacterBody2D

# Variables referentes al movimiento y la fisica del actor
@export_subgroup("Movimiento y física")
@export var speed: float = 300.0  ## Velocidad base de movimiento
@export var jump_force: float = 600.0  ## Fuerza de salto vertical
@export var gravity: float = 1200.0  ## Fuerza de gravedad aplicada al actor

# Variables referentes al combate y habilidades del actor
@export_subgroup("Combate y habilidades")
@export var base_attack_cooldown: float = 0.5  ## Cooldown del ataque basico
@export var range_attack_cooldown: float = 0.5  ## Cooldown del ataque a distancia
@export var transform_cooldown: float = 10.0  ## Cooldown del sangre
@export var transform_duration: float = 5.0  ## Duracion de la transformacion en charco de sangre


# Referencias a nodos internos
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var blood: GPUParticles2D = $GPUParticles2D


# Estado del actor
var can_base_attack: bool = true  ## Indica si el actor puede atacar
var can_range_attack: bool = true  ## Indica si el actor puede atacar
var on_air: bool ## Indica si el actor esta en el aire
var is_transformed: bool = false  ## Indica si el actor esta transformado
var can_transform: bool ## Indica si el actor se puede transformar


func _ready() -> void:
	blood.visible = false
	state_machine.state_changed.connect(_on_state_changed) # Para monitoreo
   

# Imprimira por la terminal el new_state en el cual se encuentra el actor
func _on_state_changed(new_state: String) -> void:
	print("Jugador cambió al estado: " + new_state)


# Aplicar la gravedad al actor
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

# Aplica el movimiento al actor
func move() -> void:
	move_and_slide()

func play_animation(animation_name: String) -> void:
	# Ejecuta la animacion si existe en el animation_player
	if animation_player.has_animation(animation_name): 
		animation_player.play(animation_name)
	# Si no existe mandamos un error a consola
	else:
		push_warning("Animación no encontrada: " + animation_name)

# Da la vuelta al sprite segun si el parametro es true o false
func flip_sprite(flip: bool) -> void:
	sprite.flip_h = flip
