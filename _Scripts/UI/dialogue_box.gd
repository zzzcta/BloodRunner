extends Control
class_name DialogueBox

@onready var texture_rect: NinePatchRect = $NinePatchRect
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var dialogues : Dialogues = Dialogues.new()

signal dialogue_start()
signal dialogue_end()

var original_rect : Vector2 = Vector2.ZERO


func _ready() -> void:
	original_rect = custom_minimum_size
	set_visible(false)


func _process(delta: float) -> void:
	if rich_text_label.get_v_scroll_bar().visible: 
		custom_minimum_size -= Vector2.UP 


func init_dialogue(code : String, character : String) -> void:
	custom_minimum_size = original_rect
	var font = FontFile.new()
	var text_data = dialogues.characters_data[character]
	
	font.font_data = load(text_data[0])
	texture_rect.texture = load(text_data[4])
	
	rich_text_label.add_theme_font_override("normal_font",font)
	rich_text_label.add_theme_font_size_override("normal_font_size", text_data[1])
	rich_text_label.add_theme_color_override("default_color", text_data[3])
	rich_text_label.set_text(dialogues.all_dialogues[code])
	rich_text_label.visible_characters = 0
	
	set_visible(true)
	
	_mostrar_characteres(text_data[2])
	dialogue_start.emit()

func _mostrar_characteres(time:float) -> void:
	for i in rich_text_label.text.length():
		rich_text_label.visible_characters = i + 1
		await get_tree().create_timer(time).timeout
	dialogue_end.emit()
