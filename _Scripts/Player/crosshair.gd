extends CanvasLayer

var can_turn_sprite_right: bool = true
var can_turn_sprite_left: bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SignalBuss.turned_sprite_right.connect(on_turn_sprite_right)
	SignalBuss.turned_sprite_left.connect(on_turn_sprite_left)

func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	$Crosshair.position = mouse_position
	
	if can_turn_sprite_right:
		if mouse_position.x > 320:
			SignalBuss.turn_sprite_right()
			
	if can_turn_sprite_left:
		if mouse_position.x < 320:
			SignalBuss.turn_sprite_left()
			
func on_turn_sprite_right():
	can_turn_sprite_right = false
	can_turn_sprite_left = true
	
func on_turn_sprite_left():
	can_turn_sprite_right = true
	can_turn_sprite_left = false
