extends Node
class_name Dialogues


var all_dialogues : Dictionary = {
	"KING_001" : "¿Qué crees que haces chico?",
	"KING_002" : "¿Cometido? Eso es a lo que has venido...",
	"KING_003" : "Tu agencia da pena, es absurdo. Juzgar a los demás en base a estadisticas es una cosa.",
	"KING_004" : "Pero dictar sentencias es otra cosa, otra cosa muy jodida.",
	"KING_005" : "... \nHaz lo que debas, chico.",
	"AI_001" : "Ahí esta tu objetivo, termina tu cometido.",
	"AI_002" : "Se acaba el tiempo, cumple tu mision."
}

##font,textsize,timechar,color,frame
var characters_data : Dictionary ={
	"Kingpin" : ["res://Recursos/Fuentes/MonomaniacOne-Regular.ttf",30,0.07,Color.DARK_GRAY,"res://Recursos/Sprites/UI/Border All 10.png"],
	"Artificial" : ["res://Recursos/Fuentes/Tiny5-Regular.ttf",30,0.05,Color.CORNFLOWER_BLUE,"res://Recursos/Sprites/UI/Border All 10.png"]
}
