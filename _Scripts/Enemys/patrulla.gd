extends Node
class_name Patrullas

@onready var new_patrol_cd: Timer = $NewPatrolCD

var agent: NavigationAgent2D
var enemy_base: CharacterBody2D
var animation_player: AnimationPlayer 
var sprite_2d: Sprite2D 

@export var patrol_speed : float = 2000
@export var patrulla_distancia : float = 30

var navigation_ready : bool = false
var target_reached : bool = false
var target : Vector2 = Vector2.ZERO

func _ready() -> void:
	enemy_base = get_parent() as CharacterBody2D
	agent = enemy_base.get_node("NavigationAgent2D")
	animation_player = enemy_base.get_node("AnimationPlayer")
	sprite_2d = enemy_base.get_node("Sprite2D")
	
	if enemy_base.has_signal("navigation_load"): 
		enemy_base.navigation_load.connect(navigation_ok)
	else: navigation_ready = true
	
	target = _select_next_point()


func _process(delta: float) -> void:
	if not navigation_ready: return
	if enemy_base.player_ref != null: return
	if target == Vector2.ZERO: return
	
	var distance = enemy_base.global_position.distance_to(target)
	
	if distance < 3: 
		_on_target_reached()
	else:
		move_to_target(delta,target)


func move_to_target(delta, target) -> void:
	if not navigation_ready: return
	agent.target_position = target
	var next_position = agent.get_next_path_position()
	var direction = (next_position - enemy_base.global_position).normalized()
	
	enemy_base.velocity.x = direction.x * patrol_speed * delta
	if enemy_base._detect_fall(enemy_base.velocity.x): 
		enemy_base.move_and_slide()
		animation_player.play("walk")
		sprite_2d.flip_h = false if sign(enemy_base.velocity.x) == 1 else true
	else:
		_on_target_reached()
		return


func _select_next_point() -> Vector2:
	var rng : int = -1 if randf() < 0.5 else 1
	return Vector2(enemy_base.global_position.x - (patrulla_distancia * rng), enemy_base.global_position.y)

func navigation_ok() -> void:
	navigation_ready = true


func _on_target_reached() -> void:
	target_reached = true
	target = Vector2.ZERO
	animation_player.play("idle")
	new_patrol_cd.start()


func _on_new_patrol_cd_timeout() -> void:
	new_patrol_cd.wait_time = randf_range(1,3)
	target = _select_next_point()
