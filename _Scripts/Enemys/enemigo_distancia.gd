extends CharacterBody2D
class_name EnemigoDistancia

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var animator: EnemyDistanceAnimator = $AnimationPlayer
@onready var shoot_point: Node2D = $ShootHandler/ShootPoint
@onready var shoot_handler: Node2D = $ShootHandler
@onready var collision_shape_2d: CollisionShape2D = $SightArea/CollisionShape2D
@onready var ray_cast_2d: RayCast2D = $SightArea/RayCast2D
@onready var fall_cast: RayCast2D = $FallCast
@onready var health_component: HealthComponent = $HealthComponent

@export var shoot_cd : float = 0.5
@export var bullet_path : String = ""
@export var speed : float = 4000
@export var distance_to_shoot : float = 120
@export var player_health_recover: float

var player_ref : Node2D = null
var loaded_bullet
var navigation_ready : bool = false
var player_on_target : bool = false ##El player se ha puesto a tiro
var player_dead : bool = false
var player_in_shape : Node2D = null
var shoot_cont : float = 0
var min_distance : float 
var max_distance : float 


func _ready() -> void:
	loaded_bullet = load(bullet_path)
	NavigationServer2D.map_changed.connect(_on_navigation_ready)
	health_component.hit.connect(_on_hit)
	health_component.died.connect(_death)
	
	max_distance = distance_to_shoot+2
	min_distance = distance_to_shoot-2


func _on_navigation_ready(_map_rid) -> void:
	navigation_ready = true


func _physics_process(delta: float) -> void:
	if not is_on_floor(): #Controlamos la gravedad
		velocity.y += 900 * delta
		move_and_slide()
	
	if player_dead: return
	
	if player_in_shape and player_ref == null:
		_detect_player(player_in_shape)
	
	if player_ref == null: return
	
	var distance = global_position.distance_to(player_ref.global_position)
	
	if distance > 300: return
	
	var _distance_to_target : float = position.distance_to(player_ref.position)
	
	_aim(delta)
	
	if distance > max_distance: _move_to_player(delta)
	elif distance < min_distance : _run_away_from_player(delta)
	else: velocity.x = 0
	
	animator.animate(player_ref.position, velocity.length())


func _move_to_player(delta) -> void:
	if not navigation_ready: return
	
	agent.target_position = player_ref.position
	var next_position = agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	
	velocity.x = direction.x * speed * delta
	if _detect_fall(velocity.x): move_and_slide()


func _run_away_from_player(delta) -> void:
	if not navigation_ready: return
	
	var direction_to : Vector2 = global_position.direction_to(player_ref.global_position)
	direction_to *= -1
	var point_to : Vector2 = global_position + (direction_to * 2)
	
	agent.target_position = point_to
	var direction = (point_to - global_position).normalized()
	
	velocity.x = direction.x * speed * delta
	if _detect_fall(velocity.x): move_and_slide()


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
	animator._on_shoot()
	AudioManager.play_sfx("range_attack_enemy", 600, global_position, 2, randf_range(0.9, 1.15))

##Devuelve el angulo opuesto en una escala angular
func wrap_angle(angle: float) -> float:
	return fmod(angle + PI, PI * 2) - PI


func _detect_player(body:Node2D) -> void:
	var direction = global_position.direction_to(body.global_position) 
	var circleShape = collision_shape_2d.shape as CircleShape2D
	var max_distance = circleShape.radius
	
	ray_cast_2d.target_position = direction * max_distance 
	
	await get_tree().process_frame
	
	if ray_cast_2d.is_colliding():
		var object := ray_cast_2d.get_collider() as Node2D
		if object.is_in_group("Player"):
			player_ref = object
			if not player_ref.get_node("HealthComponent").is_connected("died", _player_lost):
				player_ref.get_node("HealthComponent").died.connect(_player_lost)


##Funcion para que no se mate
func _detect_fall(x_dir : float) -> bool:
	var position_to_ray : Vector2 = global_position
	position_to_ray.y += 20
	var bool_return : bool = false
	
	if x_dir > 0:
		position_to_ray.x += 20
	else:
		position_to_ray.x -= 20
	
	fall_cast.global_position = position_to_ray
	
	if fall_cast.is_colliding():
		bool_return = true
	
	return bool_return


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_in_shape = body
	_detect_player(player_in_shape)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_shape = null


func _player_lost() -> void:
	player_ref = null
	player_dead = true


func _on_hit() -> void:
	animator._on_damaged()
	AudioManager.play_sfx("hit", 450, global_position, 1, randf_range(0.90, 1.1))

func _death() -> void:
	player_dead = true
	SignalBuss.enemy_die(player_health_recover, self.global_position)
	AudioManager.play_sfx("die", 450, global_position, 1, randf_range(0.95, 1.1))
	animator.play("death")
	
	await animator.animation_finished
	queue_free()
