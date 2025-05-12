class_name StateMachine
extends Node

# Señal emitida cada vez que hay un cambio de estado
signal state_changed(state_name: String)

var actor: CharacterBody2D = null # El objeto que posee esta maquina de estados

var current_state: State = null # Estado activo actualmente
var states: Dictionary[String, Object] = {} # Mapeo de nombres de estados a instancias de State

func _ready() -> void:
	await owner.ready # Esperamos a que el nodo padre este reeeady 
	actor = owner as CharacterBody2D  # Guardamos una referencia al dueño de esta maquina de estados
	# Si nuestro actor no es un tipo CharacterBody2D crash
	if !actor: 
		push_error("actor is not CharacterBody2D")
		return
	# Registramos los estados hijos 
	for child in get_children():
		if child is State: # Solo guardaremos los hijos que sean extiendan la clase States
			var state: State = child as State
			# Guardamos el estado en nuestro diccionario para acceso rapido
			states[state.name.to_lower()] = state
			# Configuramos referencias en el estado
			state.state_machine = self
			state.actor = actor
		else:
			push_warning("Child: " + child.name + " is not a State")
	
	# Si no hay estado inicial definido y tenemos estados disponibles, 
	# seleccionamos el primero como estado inicial
	if states.size() > 0 and current_state == null:
		var initial_state: String = states.values()[0].name.to_lower()
		change_state(initial_state)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

## Gestiona los cambios entre estados
func change_state(state_name: String) -> void:
	# Si ya tenemos un estado activo, lo desactivamos 
	if current_state:
		current_state.exit()
	
	# Activamos el nuevo estado si existe
	if states.has(state_name.to_lower()):
		current_state = states[state_name.to_lower()]
		current_state.enter()
		# Notificamos del cambio de estado
		emit_signal("state_changed", state_name)
	# Notificamos error si no existe el estado
	else:
		push_error("Estado no encontrado: " + state_name)
