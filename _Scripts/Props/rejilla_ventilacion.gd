extends Node2D
# Diccionario para mantener registro de los cuerpos dentro del area
var bodies_inside: Dictionary[Object, Variant] = {}
@export var impulse_force_player: float = 300
@export var impulse_force_player_transform: float = 800

func _ready():
	AudioManager.play_sfx("fan", 150, global_position)
	# Conectar señales para entrada y salida de cuerpos
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	
func _physics_process(_delta) -> void:
	
	# Aplicar impulso a todos los cuerpos que esten dentro del area2D
	for body in bodies_inside.keys():
		if is_instance_valid(body) and body.has_node("HealthComponent"):
			var impulse_force = bodies_inside[body]
			body.velocity.y = min(body.velocity.y, -impulse_force)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.has_node("HealthComponent"):
		var impulse_force = impulse_force_player
		var body_collision_mask: int = body.get_collision_mask()
		
		# Determinar la fuerza de impulso basada en la mascara de colision
		if body_collision_mask == 41:
			impulse_force = impulse_force_player_transform
		
		# Registrar el cuerpo y su fuerza de impulso
		bodies_inside[body] = impulse_force
		
		# Aplicar un impulso inicial
		body.velocity.y -= impulse_force
		
		print("Cuerpo con HealthComponent ha entrado: ", body.name)
	else:
		print("No HealthComponent found on ", body.name)

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Eliminar el cuerpo del registro cuando sale del area
	if bodies_inside.has(body):
		bodies_inside.erase(body)
		print("Cuerpo ha salido: ", body.name)
