extends Node

@onready var health_scene: PackedScene = preload("res://Prefabs/UI/health_hud.tscn")
@onready var death_menu_scene: PackedScene = preload("res://scenes/overlaid_menus/dead_menu.tscn")
@onready var pause_menu_scene: PackedScene = preload("res://addons/maaacks_menus_template/base/scenes/overlaid_menu/menus/pause_menu.tscn")

var health_instance: CanvasLayer
var pause_menu_instance: PauseMenu
var death_scene_instance: Control
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
	AudioManager.stop_music()
	AudioManager.music_player.stream = null
	health_instance.queue_free()
	
func on_level_started(level) -> void:
	health_instance = health_scene.instantiate()
	get_child(0).add_child(health_instance)
	if level == 1:
		AudioManager.play_music("LightYearCity", 0.7)
	elif level == 2:
		AudioManager.play_music("Portal to Underworld", 0.7)

func on_player_entered_car_exit(_door_exit_position, target_scene, transition_message) -> void:
	# Asegurar que no estemos pausados al cambiar escena
	if is_paused:
		close_pause_menu()
	SceneTransition.change_scene(target_scene, transition_message)

func on_level_finished() -> void:
	if health_instance:
		health_instance.queue_free()
		health_instance = null
	
	# Limpiar menu de pausa
	if pause_menu_instance:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
	
	is_paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		if is_paused:
			close_pause_menu()
		else:
			open_pause_menu()

func open_pause_menu() -> void:
	# Crear menu si no existe
	if !pause_menu_instance:
		pause_menu_instance = pause_menu_scene.instantiate() as PauseMenu
		get_child(0).add_child(pause_menu_instance)

	# Mostrar
	pause_menu_instance.visible = true
	
func close_pause_menu() -> void:
	if pause_menu_instance:
		pause_menu_instance.visible = false
	
func pause_game() -> void:
	if !is_paused:
		open_pause_menu()

func resume_game() -> void:
	if is_paused:
		close_pause_menu()
