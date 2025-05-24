extends Node

signal level_started()
signal level_finished()

signal player_entered_car_exit(door_exit_position, target_scene, transition_message)

signal health_changed(current_health, max_health)

signal enemy_died(player_health_recover, enemy_die_position)

signal player_died()

func player_die() -> void:
	emit_signal("player_died")

func enemy_die(player_health_recover: float, enemy_die_position: Vector2) -> void:
	emit_signal("enemy_died", player_health_recover, enemy_die_position)
	
## Se emite cuando el jugador abre la puerta que da comienzo al juego
func start_level() -> void:
	emit_signal("level_started")

## Se emite cuando el jugador abre la puerta que da final al juego
func finish_level() -> void:
	emit_signal("level_finished")

## Se emite cuando el jugador entra al coche para salir del escenario.
func player_enter_car_exit(door_exit_position: Vector2, target_scene: , transition_message: String) -> void: 
	emit_signal("player_entered_car_exit", door_exit_position, target_scene, transition_message)

func update_health(current_health: float, max_health: float) -> void:
	emit_signal("health_changed", current_health, max_health)
