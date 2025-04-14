extends CharacterBody2D
class_name EnemigoDistancia

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var animator: EnemyDistanceAnimator = $AnimationPlayer
@onready var shoot_point: Node2D = $ShootHandler/ShootPoint
@onready var shoot_handler: Node2D = $ShootHandler

@export var shoot_cd : float = 0.5
@export var bullet_path : String = ""
@export var speed : float = 1200

var player_ref
var loaded_bullet
var navigation_ready : bool = false
var player_on_target : bool = false ##El player se ha puesto a tiro
var shoot_cont : float = 0


func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	loaded_bullet = load(bullet_path)
	NavigationServer2D.map_changed.connect(_on_navigation_ready)


func _on_navigation_ready(_map_rid) -> void:
	navigation_ready = true


func _physics_process(delta: float) -> void:
	if player_ref == null: return
	
	_move_to_player(delta)
	
	if not is_on_floor(): #Controlamos la gravedad
		velocity.y += 900 * delta
	
	var distance_to_target : float = position.distance_to(player_ref.position)
	
	_aim(delta)
	
	animator.animate(player_ref.position)


func _move_to_player(delta) -> void:
	if not navigation_ready: return
	
	agent.target_position = player_ref.position
	var next_position = agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	
	velocity.x = direction.x * speed * delta
	move_and_slide()


func _aim(delta : float) -> void:
	if not player_ref: return
	
	var direction = shoot_handler.global_position.direction_to(player_ref.global_position)
	var angle_to_player = direction.angle()
	
	var max_angle = PI / 4
	var min_angle = -PI / 4
	
	if animator.is_flip:
		max_angle = wrap_angle(-PI / 4 + PI) 
		min_angle = wrap_angle(PI / 4 + PI) 
	
	player_on_target = true
	#print(max_angle, "/", min_angle, " => ",angle_to_player)
	if not animator.is_flip and angle_to_player < max_angle and angle_to_player > min_angle: 
		shoot_handler.look_at(player_ref.global_position)
	elif animator.is_flip and (angle_to_player > max_angle or angle_to_player < min_angle): 
		shoot_handler.look_at(player_ref.global_position)
	else:
		player_on_target = false
	
	shoot_cont += delta
	if shoot_cont > shoot_cd:
		shoot_cont = 0
		if player_on_target: _shoot()


func _shoot() -> void: 
	var instance = loaded_bullet.instantiate()
	instance.position = shoot_point.global_position
	instance.rotation = shoot_point.global_rotation
	get_tree().current_scene.add_child(instance)

##Devuelve el angulo opuesto en una escala angular
func wrap_angle(angle: float) -> float:
	return fmod(angle + PI, PI * 2) - PI
