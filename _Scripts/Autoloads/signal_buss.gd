extends Node

signal level_started()
signal level_finished()

signal player_entered_car_exit(door_exit_position)

signal health_changed(current_health, max_health)

signal enemy_died(player_health_recover, enemy_die_position)

func enemy_die(player_health_recover: float, enemy_die_position: Vector2) -> void:
	emit_signal("enemy_died", player_health_recover, enemy_die_position)
	
## Se emite cuando el jugador abre la puerta que da comienzo al juego
func start_level() -> void:
	emit_signal("level_started")

## Se emite cuando el jugador abre la puerta que da final al juego
func finish_level() -> void:
	emit_signal("level_finished")

## Se emite cuando el jugador entra al coche para salir del escenario.
func player_enter_car_exit(door_exit_position: Vector2) -> void: 
	emit_signal("player_entered_car_exit", door_exit_position)

func update_health(current_health: float, max_health: float) -> void:
	emit_signal("health_changed", current_health, max_health)
