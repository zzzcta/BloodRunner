extends AnimationPlayer

@onready var enemy_base: CharacterBody2D = $".."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var attack_combo_cd: Timer = $"../AttackComboCD"

var sprite_right_pos : float
var sprite_left_pos : float 
var combo_buffer : int = 0

#enum EnemyState {IDLE,CHASING,ATTACK,JUMP}
var previous_state = null

func _ready() -> void:
	sprite_right_pos = sprite_2d.position.x
	sprite_left_pos = sprite_right_pos - 20

func animate(state,direction) -> void:
	change_dir(direction)
	
	if previous_state == 2 and state == 2 and combo_buffer > 0:
		animate_combo(combo_buffer)
	
	if previous_state == state or enemy_base.can_change_state == false: return
	previous_state = state
	
	match state:
		0:
			play("idle")
		1:
			play("run")
		2:
			play("attack")
			enemy_base.can_change_state = false
		3:
			play("jump")
		_:
			play("idle")


func animate_combo(combo) -> void:
	attack_combo_cd.stop()
	var attack_anim : String = "attack"
	attack_anim += str(combo+1)
	
	play(attack_anim)
	enemy_base.can_change_state = false


func change_dir(direction:int) -> void:
	if direction == -1:
		sprite_2d.flip_h = true
		sprite_2d.position.x = sprite_left_pos
		enemy_base.attack_pos = "left"
	else:
		sprite_2d.flip_h = false
		sprite_2d.position.x = sprite_right_pos
		enemy_base.attack_pos = "right"


func end_of_attack_anim() -> void:
	if combo_buffer < 2: combo_buffer += 1
	else: combo_buffer = 0
	
	attack_combo_cd.start()
	
	enemy_base.can_change_state = true
	previous_state = null


func _on_attack_combo_cd_timeout() -> void:
	combo_buffer = 0
