extends Node

@onready var camera_starting: Marker2D = $AnimatedSprite2D/CameraStartingPosition
@onready var camera_finish: Marker2D = $AnimatedSprite2D/CameraFinishPosition
@onready var control: DialogueBox = $CanvasLayer/dialogue_box
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_file("*.tscn") var target_scene : String

func _ready() -> void:
	animated_sprite_2d.play("idle_brazo")
	$AnimatedSprite2D/Camera2D.position = camera_starting.position
	
	await get_tree().create_timer(1.0).timeout
	
	var tween: Tween = create_tween()
	
	tween.tween_property($AnimatedSprite2D/Camera2D, "position", camera_finish.position, 3).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property($AnimatedSprite2D/Camera2D, "zoom", Vector2(2.0, 2.0), 3).set_trans(Tween.TRANS_CUBIC)
	
	await get_tree().create_timer(4.0).timeout
	
	control.init_dialogue("AUX6B_011","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_012","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_013","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_014","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_015","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_016","AUX6B")
	await control.dialogue_end
	await get_tree().create_timer(2.0).timeout
	control.init_dialogue("AUX6B_017","AUX6B")
	await control.dialogue_end
	
	SceneTransition.change_scene(target_scene)


func _process(delta: float) -> void:
	$AnimatedSprite2D.position.x -= 500.0 * delta
