extends Node

@onready var health_scene: PackedScene = preload("res://Prefabs/UI/health_hud.tscn")
@onready var death_menu_scene: PackedScene = preload("res://scenes/overlaid_menus/dead_menu.tscn")
@onready var pause_menu_scene: PackedScene = preload("res://addons/maaacks_menus_template/base/scenes/overlaid_menu/menus/pause_menu.tscn")

var health_instance: CanvasLayer
var pause_menu_instance: PauseMenu
var death_scene_instance 
var is_paused: bool = false

func _ready() -> void:
	# Asegurar que el juego inicie sin pausa
	get_tree().paused = false
	is_paused = false
	
	# Conectar señales del juego
	SignalBuss.player_died.connect(_on_player_died)
	SignalBuss.level_started.connect(on_level_started)
	SignalBuss.level_finished.connect(on_level_finished)
	SignalBuss.player_entered_car_exit.connect(on_player_entered_car_exit)

func _on_player_died () -> void:
	death_scene_instance = death_menu_scene.instantiate()
	get_child(0).add_child(death_scene_instance)
	health_instance.queue_free()
	
func on_level_started() -> void:
	health_instance = health_scene.instantiate()
	get_child(0).add_child(health_instance)

func on_player_entered_car_exit(_door_exit_position, target_scene, transition_message) -> void:
	# Asegurar que no estemos pausados al cambiar escena
	if is_paused:
		close_pause_menu()
	SceneTransition.change_scene(target_scene, transition_message)

func on_level_finished() -> void:
	if health_instance:
		health_instance.queue_free()
		health_instance = null
	
	# Limpiar menú de pausa
	if pause_menu_instance:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
	
	is_paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("ESC presionado - Estado pausa: ", is_paused)  # Debug
		if is_paused:
			close_pause_menu()
		else:
			open_pause_menu()

func open_pause_menu() -> void:
	print("Abriendo menú de pausa")  # Debug
	
	# Crear menú si no existe
	if not pause_menu_instance:
		pause_menu_instance = pause_menu_scene.instantiate() as PauseMenu
		get_child(0).add_child(pause_menu_instance)
		print("Menú de pausa instanciado")  # Debug
	
	# Mostrar
	pause_menu_instance.visible = true
	
	print("Juego pausado: ", get_tree().paused)  # Debug

func close_pause_menu() -> void:
	print("Cerrando menú de pausa")  # Debug
	
	if pause_menu_instance:
		pause_menu_instance.visible = false
	
	print("Juego reanudado: ", not get_tree().paused)  # Debug

# Funciones públicas
func pause_game() -> void:
	if not is_paused:
		open_pause_menu()

func resume_game() -> void:
	if is_paused:
		close_pause_menu()
