extends AnimationPlayer

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
var sprite_right_pos : float
var sprite_left_pos : float 

#enum EnemyState {IDLE,CHASING,ATTACK,JUMP}
var previous_state = null
var priority_turn = ""

func _ready() -> void:
	sprite_right_pos = sprite_2d.position.x
	sprite_left_pos = sprite_right_pos - 20

func animate(state,direction) -> void:
	change_dir(direction)
	
	if previous_state == state or priority_turn != "": return
	previous_state = state
	
	match state:
		0:
			play("idle")
		1:
			play("run")
		2:
			play("attack")
			priority_turn = "attack"
		3:
			play("jump")
		_:
			play("ilde")


func change_dir(direction:int) -> void:
	if direction == -1:
		sprite_2d.flip_h = true
		sprite_2d.position.x = sprite_left_pos
	else:
		sprite_2d.flip_h = false
		sprite_2d.position.x = sprite_right_pos


func end_of_priority_anim() -> void:
	priority_turn = ""
	previous_state = null
