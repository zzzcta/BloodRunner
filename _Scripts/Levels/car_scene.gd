extends Node2D

@onready var camera_starting: Marker2D = $AnimatedSprite2D/CameraStartingPosition
@onready var camera_finish: Marker2D = $AnimatedSprite2D/CameraFinishPosition
@onready var control: DialogueBox = $CanvasLayer/dialogue_box
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_file("*.tscn") var target_scene : String
@export var transition_message: String


func _ready() -> void:
	AudioManager.play_music("TheHiddenOne", 0.1, true)
	$AnimatedSprite2D/Camera2D.position = camera_starting.position
	AudioManager.play_sfx("die", 2000, global_position, 1, 1)
	
	await get_tree().create_timer(2.0).timeout
	
	var tween: Tween = create_tween()
	
	tween.tween_property($AnimatedSprite2D/Camera2D, "position", camera_finish.position, 8).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property($AnimatedSprite2D/Camera2D, "zoom", Vector2(2.0, 2.0), 8).set_trans(Tween.TRANS_CUBIC)
	
	
	await get_tree().create_timer(8.0).timeout
	control.init_dialogue("AUX6B_001","AUX6B")
	await control.dialogue_end
	await get_tree().create_timer(2.0).timeout
	control.init_dialogue("AUX6B_002","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_003","AUX6B")
	await control.dialogue_end
	
	
	animated_sprite_2d.play("acople")
	await animated_sprite_2d.animation_finished
	await get_tree().create_timer(1.0).timeout
	
	animated_sprite_2d.play("idle_brazo")
	
	control.init_dialogue("AUX6B_004","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_005","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_006","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_007","AUX6B")
	await get_tree().create_timer(2.0).timeout
	await control.dialogue_end
	control.init_dialogue("AUX6B_008","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_009","AUX6B")
	await control.dialogue_end
	control.init_dialogue("AUX6B_010","AUX6B")
	await control.dialogue_end
	await get_tree().create_timer(2.0).timeout
	
	SceneTransition.change_scene(target_scene, transition_message)

func _process(delta: float) -> void:
	$AnimatedSprite2D.position.x -= 500.0 * delta
