extends Node

@onready var dialogue_box: DialogueBox = $"../../CanvasLayer/dialogue_box"
@onready var player_test: Player = $"../../player_test"
@onready var camera_2d: Camera2D = $"../../player_test/Camera2D"
@onready var kill_bigmin: Node2D = $"../kill_bigmin"
@onready var bigmin: CharacterBody2D = $"../Bigmin"
@onready var abajo: RichTextLabel = $"../Abajo"


var opened : bool = false

func _ready() -> void:
	bigmin.bigmin_died.connect(_bigmin_dead)

func _on_body_entered(_body: Node2D) -> void:
	if opened : return
	
	opened = true
	print("Empieza la fiesta")
	player_test.on_start_dialogue()
	player_test.velocity = Vector2.ZERO
	player_test.move_and_slide()
	
	var tween = create_tween()
	var pos := camera_2d.position + (Vector2(1,-0.5) * 80)
	tween.tween_property(camera_2d, "position", pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(2.0).timeout
	dialogue_box.init_dialogue("BIGMIN_001","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_002","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("AUX6B_018","AUX6B")
	
	await dialogue_box.dialogue_end
	
	await get_tree().create_timer(2.0).timeout
	dialogue_box.init_dialogue("BIGMIN_003","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_004","Bigmin")
	
	await dialogue_box.dialogue_end
	
	await get_tree().create_timer(2.0).timeout
	dialogue_box.init_dialogue("BIGMIN_005","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_006","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_007","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_008","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_009","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_010","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("BIGMIN_011","Bigmin")
	
	await dialogue_box.dialogue_end
	dialogue_box.init_dialogue("AUX6B_019","AUX6B")
	
	await dialogue_box.dialogue_end
	
	camera_2d.position = Vector2.ZERO
	player_test.on_finish_dialogue()
	kill_bigmin.activate()


func _bigmin_dead() -> void:
	kill_bigmin.de_activate()
	kill_bigmin.queue_free()
	abajo.set_visible(true)
	queue_free()
