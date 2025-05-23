extends Node

@onready var health_scene: PackedScene = preload("res://Prefabs/UI/health_hud.tscn")

@export_file("*.tscn") var target_scene : String
@export var transition_message: String

func _ready() -> void:
	SignalBuss.level_started.connect(on_level_started)
	SignalBuss.player_entered_car_exit.connect(on_player_entered_car_exit)
	
func on_level_started() -> void:
	var health_instance: CanvasLayer = health_scene.instantiate()
	add_child(health_instance)

func on_player_entered_car_exit(_door_exit_position) -> void:
	SceneTransition.change_scene(target_scene, transition_message)
