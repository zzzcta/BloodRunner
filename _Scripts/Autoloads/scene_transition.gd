extends CanvasLayer

var fade_in_time: float = 1.5
var fade_out_time: float = 1.5
var visible_time: float = 5
var transition_overlay: ColorRect
var label_container: Control
var tween: Tween

func _ready() -> void:
	# Configurar la estructura para transiciones
	setup_transition_elements()
	
	# Asegurarse de que esta inicialmente transparente
	transition_overlay.color.a = 0.0
	transition_overlay.visible = false
	
	# Ocultar inicialmente el contenedor de texto
	label_container.visible = false

func setup_transition_elements() -> void:
	# Crear un nodo control para contener todos los elementos
	var container = Control.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(container)
	
	# Crear un ColorRect que cubrira toda la pantalla
	transition_overlay = ColorRect.new()
	transition_overlay.color = Color(0, 0, 0, 0)  # Negro transparente inicialmente
	transition_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_child(transition_overlay)
	
	# Crear un contenedor para el texto que estara por encima del overlay
	label_container = Control.new()
	label_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	label_container.visible = false  # Inicialmente invisible
	container.add_child(label_container)

## Funcion para mostrar texto durante la transicion
func set_transition_text(text: String, font_size: int = 24) -> void:
	# Limpiar textos anteriores
	for child in label_container.get_children():
		child.queue_free()
	
	if text == "":
		label_container.visible = false
		return
	
	# Crear nueva etiqueta
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	label.add_theme_font_size_override("font_size", font_size)
	
	label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	
	# Añadir al contenedor
	label_container.add_child(label)
	
## Funcion principal para cambiar entre escenas con transición
func change_scene(target_scene: String, transition_text: String = "") -> void:
	# Configurar el texto para la transicion
	set_transition_text(transition_text)
	
	# Mostrar el overlay
	transition_overlay.visible = true
	
	# Fade out
	await fade_out()
	
	# Mostramos el texto despues del Fade out
	if transition_text != "":
		label_container.visible = true
	
	# Tiempo de espera opcional entre transiciones
	if visible_time > 0:
		await get_tree().create_timer(visible_time).timeout
	
	# Ocultamos el texto antes del fade in
	label_container.visible = false
	
	# Cambiar la escena mientras esta en negro
	get_tree().change_scene_to_file(target_scene)
	
	# Esperar a que la escena este lista
	await get_tree().process_frame
	
	
	await fade_in()
	
	# Limpiar el texto y ocultar el overlay al finalizar
	set_transition_text("")
	transition_overlay.visible = false

# Transicion a negro
func fade_out() -> void:
	# Asegurar que el overlay esta visible
	transition_overlay.visible = true
	
	# Cancelar cualquier tween anterior
	if tween and tween.is_running():
		tween.kill()
	
	# Crear nuevo tween para fade out
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(transition_overlay, "color:a", 1.0, fade_out_time)
	
	# Esperar a que termine el tween
	await tween.finished

# Transicion desde negro
func fade_in() -> void:
	# Asegurar que el overlay esta visible y opaco
	transition_overlay.visible = true
	transition_overlay.color.a = 1.0
	
	# Cancelar cualquier tween anterior
	if tween and tween.is_running():
		tween.kill()
	
	# Crear nuevo tween para fade in
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(transition_overlay, "color:a", 0.0, fade_in_time)
	
	# Esperar a que termine el tween
	await tween.finished
