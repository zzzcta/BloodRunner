extends Marker2D


var radio: float = 30.0  # Distancia desde el padre

func _process(_delta):
	# Obtener la posicion del cursor en coordenadas globales
	var mouse_position: Vector2 = get_global_mouse_position()
	
	# Calcular la direccion desde el padre hacia el cursor
	var direction: Vector2 = (mouse_position - get_parent().global_position).normalized()
	
	# Posicionar el marker en esa direccion a la distancia establecida
	position = direction * radio
	
	# rotar el marker para que "mire" hacia el cursor
	look_at(mouse_position)
