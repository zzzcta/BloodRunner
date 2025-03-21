extends CharacterBody2D
class_name PlayerTest

@onready var health_component: HealthComponent = $HealthComponent

@export var max_speed: float = 250.0 
@export var accel: float = 800.0  
@export var air_accel: float = 1000.0 
@export var friction: float = 900.0 
@export var air_friction: float = 100.0 
@export var jump_force: float = -350.0  
@export var gravity: float = 900.0  


func _ready() -> void:
	health_component.connect("died",dead)


func _physics_process(delta):
	var input_dir = Input.get_axis("move_left", "move_right")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var current_accel = accel if is_on_floor() else air_accel
	var current_friction = friction if is_on_floor() else air_friction
	
	if input_dir != 0:
		velocity.x += input_dir * current_accel * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, current_friction * delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	move_and_slide()


func dead() -> void:
	print("Player muerto")
