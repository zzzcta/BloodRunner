extends Node2D
class_name Torreta

@onready var arriba: Sprite2D = $Arriba
@onready var abajo: Sprite2D = $Abajo
@onready var shoot_point: Node2D = $Arriba/ShootPoint

@export var flip : bool
@export_range(15,90) var range_vision : float = 45
@export var shoot_cd : float = 0.5
@export var bullet_path : String = ""

var shoot_cont : float = 0
var loaded_bullet : PackedScene
var target_ref
var can_shoot : bool = false
var targeting_player : bool = false


func _ready() -> void:
	target_ref = get_tree().get_first_node_in_group("Player")
	if target_ref: loaded_bullet = load(bullet_path)
	
	if flip:
		arriba.flip_h = true
		abajo.flip_h = true
		shoot_point.position.x = -30


func _process(delta: float) -> void:
	if not target_ref: return
	
	if not can_shoot: shoot_cont += delta
	if shoot_cont >= shoot_cd:
		shoot_cont = delta
		can_shoot = true
	
	look_to_player()
	aiming()


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
	instance.position = shoot_point.global_position
	instance.rotation = shoot_point.global_rotation
	if flip: instance.rotation += PI
	get_tree().current_scene.add_child(instance)
