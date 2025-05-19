extends CanvasLayer

@onready var texture_progress_bar: TextureProgressBar = $MarginContainer/TextureProgressBar

func _ready() -> void:
	SignalBuss.health_changed.connect(on_health_changed)
	SignalBuss.level_finished.connect(on_level_finished)
	
func on_health_changed(current_health: float, max_health: float) -> void:
	texture_progress_bar.step = 1 / max_health
	var last_value = texture_progress_bar.value
	texture_progress_bar.value = lerpf(last_value, current_health, 1)
	texture_progress_bar.max_value = max_health

func on_level_finished() -> void:
	self.visible = false
