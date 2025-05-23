extends GPUParticles2D

var player: CharacterBody2D
var is_following: bool = false
var follow_speed: float = 300.0
var attraction_force: float = 500.0

func _ready() -> void:
	SignalBuss.enemy_died.connect(on_enemy_died)
	player = get_tree().get_first_node_in_group("Player")
	emitting = false

func _process(delta: float) -> void:
	if is_following and player:
		var direction: Vector2 = (player.global_position - global_position).normalized()
		var distance: float = global_position.distance_to(player.global_position)
		
		# Acelerar mientras se acerca al jugador
		var speed: float = follow_speed + (attraction_force / max(distance, 50.0))
		global_position += direction * speed * delta
		
		# Llegar al jugador
		if distance < 10.0:
			on_reached_player()

func on_enemy_died(_player_health_recover: float, enemy_die_position: Vector2) -> void:
	global_position = enemy_die_position
	emitting = true
	restart()
	is_following = true

func on_reached_player() -> void:
	is_following = false
	emitting = false
