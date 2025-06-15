extends Door
@export var level: int

func _ready() -> void:
	super()

func on_door_died() -> void:
	super()
	SignalBuss.start_level(level)
