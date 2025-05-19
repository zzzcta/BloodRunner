extends CanvasLayer

func _ready():
	SignalBuss.level_finished.connect(on_level_finished)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	$Crosshair.position = mouse_pos

func on_level_finished() -> void:
	self.visible = false
