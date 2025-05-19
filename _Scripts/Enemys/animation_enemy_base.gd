extends AnimationPlayer

@onready var enemy_base: CharacterBody2D = $".."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"

#enum EnemyState {IDLE,CHASING,ATTACK,JUMP,IDLE}
var previous_state = null

func animate(state,direction) -> void:
	change_dir(direction)
	
	
	#if previous_state == 4 and state == 4:
		#print("HAY")
	
	if previous_state != 4 and state == 4: enemy_base.can_change_state = true
	if previous_state == state or enemy_base.can_change_state == false: return
	previous_state = state
	
	#print("Animando " , state)
	
	match state:
		0:
			play("idle")
		1:
			play("walk")
		2:
			play("attack")
			enemy_base.can_change_state = false
		3:
			play("jump")
		4:
			play("hit")
			enemy_base.can_change_state = false
		_:
			play("idle")
	#print(current_animation)


func change_dir(direction:int) -> void:
	if direction == -1:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false


func end_of_attack_anim() -> void:
	enemy_base.can_change_state = true
	previous_state = null
