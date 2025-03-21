extends CharacterBody2D

enum EnemyState {IDLE,CHASING,ATTACK,JUMP}

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed : float = 4000 
@export var attack_threshold : float = 40
@export var attack_path : String

@export_category("Attacks position")
@export var attack_pos_left : Vector2
@export var attack_pos_right : Vector2

var navigation_ready : bool = false
var attack_pos : Vector2 = Vector2.ZERO
var player_ref : CharacterBody2D
var attack_instance : PackedScene
var state : EnemyState = EnemyState.IDLE


func _ready() -> void:
	attack_instance = load(attack_path)
	player_ref = get_tree().get_first_node_in_group("Player")
	NavigationServer2D.map_changed.connect(_on_navigation_ready)

func _on_navigation_ready(_map_rid) -> void:
	navigation_ready = true

func _physics_process(delta: float) -> void:
	if player_ref == null: return
	
	move_to_player(delta)
	
	if not is_on_floor(): #Controlamos la gravedad
		velocity.y += 900 * delta
		state = EnemyState.JUMP
	
	var distance_to_target : float = position.distance_to(player_ref.position)
	if distance_to_target <= attack_threshold:
		state = EnemyState.ATTACK
	
	#print(state)
	animation_player.animate(state,sign((position - player_ref.position).x)*-1)


func move_to_player(delta) -> void:
	if not navigation_ready: return
	
	agent.target_position = player_ref.position
	var next_position = agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	
	velocity.x = direction.x * speed * delta
	state = EnemyState.CHASING
	
	move_and_slide()


#--------CALLABLES-----
func instance_attack():
	var instance = attack_instance.instantiate()
	add_child(instance)
	instance.position = attack_pos
