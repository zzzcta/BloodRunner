extends Door

func _ready() -> void:
	super()

func on_door_died() -> void:
	super()
	SignalBuss.finish_level()
