extends Node2D

@export var destination_teleport: NodePath  # Ruta al otro punto de teletransporte
@export var teleport_cooldown: float = 0.5  # Tiempo de espera entre teleports

var destination: Node2D
var teleporting_player: CharacterBody2D = null  # Referencia al jugador que se esta teletransportando
var can_teleport: bool = true  # Controla si este teleport puede activarse

func _ready() -> void:
	# Verificamos y conectamos al destino
	if destination_teleport.is_empty():
		push_warning("No se ha configurado un destino para este teleport")
		return
		
	destination = get_node_or_null(destination_teleport)
	
	# Conectamos las señales
	$Area2D.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	# Verificamos que podemos teleportar y que el cuerpo sea un jugador
	if !can_teleport or !body.is_in_group("Player"):
		return
		
	if destination:
		
		# Guardamos referencia al jugador que se teleporta
		teleporting_player = body
		
		# Desactivamos este teleport
		can_teleport = false
		
		# Desactivamos el teleport de destino para evitar rebotes
		if destination.has_method("disable_teleport"):
			destination.disable_teleport()
		
		# Teletransportamos al jugador
		
		var tween: Tween = create_tween()
		
		tween.tween_property(body, "global_position", destination.global_position, 0.25).set_trans(Tween.TRANS_QUAD)
		
		# Iniciamos un temporizador para reactivar los teleports despues de un tiempo
		var timer = get_tree().create_timer(teleport_cooldown)
		timer.timeout.connect(_on_cooldown_timeout)

func _on_cooldown_timeout() -> void:
	# Reactivamos este teleport
	can_teleport = true
	
	# Reactivamos el teleport de destino
	if destination and destination.has_method("enable_teleport"):
		destination.enable_teleport()
	
	# Limpiamos la referencia al jugador
	teleporting_player = null

# Metodos para activar/desactivar el teleport desde fuera
func disable_teleport() -> void:
	can_teleport = false
	
func enable_teleport() -> void:
	can_teleport = true
