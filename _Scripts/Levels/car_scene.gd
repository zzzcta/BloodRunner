extends Node2D

@onready var camera_starting: Marker2D = $AnimatedSprite2D/CameraStartingPosition
@onready var camera_finish: Marker2D = $AnimatedSprite2D/CameraFinishPosition
@onready var control: DialogueBox = $CanvasLayer/Control

@export_file("*.tscn") var target_scene : String

func _ready() -> void:
	$Timer.start()
	
	$AnimatedSprite2D/Camera2D.position = camera_starting.position
	
	await get_tree().create_timer(2.0).timeout
	
	var tween: Tween = create_tween()
	
	tween.tween_property($AnimatedSprite2D/Camera2D, "position", camera_finish.position, 8).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property($AnimatedSprite2D/Camera2D, "zoom", Vector2(2.0, 2.0), 8).set_trans(Tween.TRANS_CUBIC)
	
	control.init_dialogue("KING_001","Kingpin")
	
	
func _on_timer_timeout() -> void:
	SceneTransition.change_scene(target_scene)

func _process(delta: float) -> void:
	$AnimatedSprite2D.position.x -= 500.0 * delta
