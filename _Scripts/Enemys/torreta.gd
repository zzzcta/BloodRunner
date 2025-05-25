extends Node2D
class_name Torreta

@onready var arriba: Sprite2D = $Arriba
@onready var abajo: Sprite2D = $Abajo
@onready var shoot_point: Node2D = $Arriba/ShootPoint
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var flip : bool
@export_range(15,90) var range_vision : float = 45
@export var shoot_cd : float = 2
@export var bullet_path : String = ""
@export var shoot_distance : float = 150

var shoot_cont : float = 0
var loaded_bullet : PackedScene
var target_ref
var player_ref = null
var can_shoot : bool = false
var targeting_player : bool = false
var player_ded : bool = false


func _ready() -> void:
	ray_cast_2d.target_position = Vector2(shoot_distance,0)
	target_ref = get_tree().get_first_node_in_group("Player")
	target_ref.get_node("HealthComponent").died.connect(player_dead)
	health_component.died.connect(_death)
	if target_ref: loaded_bullet = load(bullet_path)
	
	if flip:
		arriba.flip_h = true
		abajo.flip_h = true
		shoot_point.position.x = -30


func _process(delta: float) -> void:
	if player_ded: return
	
	detect_player(target_ref.global_position)
	if not player_ref: return
	
	if not can_shoot: shoot_cont += delta
	if shoot_cont >= shoot_cd:
		shoot_cont = delta
		can_shoot = true
	
	look_to_player()
	aiming()
	
	if global_position.distance_to(player_ref.global_position) > shoot_distance: 
		player_ref = null


func look_to_player() -> void:
	var direction : Vector2 = (target_ref.global_position - arriba.global_position).normalized()
	var reference_dir = arriba.transform.x if not flip else -arriba.transform.x
	var angle_to_target = rad_to_deg(direction.angle())
	var min_angle = 0 + range_vision
	var max_angle = 270 + range_vision
	
	if angle_to_target < 0: angle_to_target += 360
	
	if flip:
		min_angle = 90 + range_vision
		max_angle = 270 - range_vision
	
	# Solo girar si está dentro del ángulo permitido
	if not flip and (angle_to_target >= max_angle or angle_to_target <= min_angle):
		arriba.look_at(target_ref.global_position)
		targeting_player = true
	elif flip and (angle_to_target <= max_angle and angle_to_target >= min_angle):
		arriba.look_at(target_ref.global_position)
		arriba.rotation += PI
		targeting_player = true
	else: targeting_player = false


##Funcion para decidir si disparar o no
func aiming() -> void:
	if can_shoot and targeting_player:
		can_shoot = false
		shoot()


func shoot() -> void:
	var instance = loaded_bullet.instantiate()
	animation_player.play("shoot")
	instance.position = shoot_point.global_position
	instance.rotation = shoot_point.global_rotation
	if flip: instance.rotation += PI
	get_tree().current_scene.add_child(instance)
	AudioManager.play_sfx("range_attack_enemy", 600, global_position, 2, randf_range(0.9, 1.15))
	await animation_player.animation_finished
	animation_player.play("aim")
	


func detect_player(target_pos:Vector2) -> void:
	ray_cast_2d.look_at(target_pos)
	if ray_cast_2d.is_colliding():
		var player_script = ray_cast_2d.get_collider() as Player
		if player_script and player_ref == null:
			player_ref = player_script


func player_dead() -> void:
	player_ded = true


func _death() -> void:
	animation_player.play("death")
	await animation_player.animation_finished
	AudioManager.play_sfx("die", 450, global_position, 1, randf_range(0.90, 1.1))
	queue_free()
	
