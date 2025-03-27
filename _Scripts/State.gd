class_name State
extends Node

var state_machine: StateMachine = null  # Referencia a la maquina de estados que contiene este estado
var actor: CharacterBody2D = null  # Referencia al actor que está siendo controlado

## Se ejecuta el codigo de la funcion cuando se entra al estado
func enter():
	pass
	
## Se ejecuta el codigo de la funcion cada frame
func update(_delta: float):
	pass
	
func physics_update(_delta: float) -> void:
	pass  
	
func handle_input(_event: InputEvent) -> void:
	pass 
	

## Se ejecuta el codigo de la funcion cuando se sale del estado
func exit() -> void:
	pass
	

## Se utiliza para transicionar entre estados, se pasa como parametro el estado al cual queremos transicionar.
func transition_to(new_state: String) -> void:
	state_machine.change_state(new_state)
