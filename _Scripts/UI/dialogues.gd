extends Node
class_name Dialogues


var all_dialogues : Dictionary = {
	"BIGMIN_001" : "Le dije a Dartoe que no había escapatoria posible...",
	"BIGMIN_002" : "Cuando Maelstorm te pone una mira en la cabeza ya no hay nada que se pueda hacer.",
	"BIGMIN_003" : "¿Y bien? ¿Vas a quedarte mucho tiempo ahí, marioneta de los cojones?",
	"BIGMIN_004" : "Vienes aquí, a mi casa, mi templo, mi hogar..." ,
	"BIGMIN_005" : "con un arma que [wave]YO[/wave] mismo ayudé a fabricar...",
	"BIGMIN_006" : "¿Qué? ¿Tienes dudas? [wave]¡¿Ahora dudas?![/wave]",
	"BIGMIN_007" : "¿Cuántos de los míos has [color=red]matado[/color]? ¿A cuántos has [color=red]absorbido[/color]?",
	"BIGMIN_008" : "Sabes... yo estuve en tu lugar una vez... pero claro.",
	"BIGMIN_009" : "La nueva europa no puede seguir afiliada a unas basuras como nosotros...",
	"BIGMIN_010" : "Algún día, chico. Algún día tú también les sobrarás...",
	"BIGMIN_011" : "¿Sabes cómo te convertiste en [color=red]eso[/color]?",
	"AUX6B_001" : "Necesito confirmación Omega.",
	"AUX6B_002" : "... Confirmación omitida. [color=green]Iniciando escáner biométrico...[/color]",
	"AUX6B_003" : "Parámetros estables... [color=green]Iniciando secuencia de acople protésico...[/color]",
	"AUX6B_004" : "Todo listo Omega. Como aún estamos en una fase experimental, necesitamos calibrar...", 
	"AUX6B_005" : " la instancia y comprobar que todas sus cualidades funcionen de manera óptima.",
	"AUX6B_006" : "Maelstrom ha preparado una simulación para que pruebes todas las funciones disponibles...",
	"AUX6B_007":  "asegúrate de que todo esté a punto para tu primera misión.",
	"AUX6B_008" : "Recuerda Omega, el [color=orange]coagulante[/color] dura poco [color=green]tiempo[/color] y tu cuerpo no aguantará mucho.", 
	"AUX6B_009" : "Esto [color=green]limitará[/color] tus opciones, tienes que darte prisa, si tan solo pudieras obtener más [wave][color=red]sangre[/color][/wave]...",
	"AUX6B_010" : "Hemos llegado. Puedes empezar Omega",
	"AUX6B_011" : "Buen trabajo Omega.",
	"AUX6B_012" : "Todas las funciones de la instancia se encuentran en estado [color=green]óptimo[/color].",
	"AUX6B_013" : "Ya estás preparado para una misión de verdad.",
	"AUX6B_014" : "Tu objetivo es el líder de la célula terrorista llamada [color=red]Los Gaunts.[/color]",
	"AUX6B_015" : "Maelstorm confirma la presencia de su líder en las instalaciones.",
	"AUX6B_016" : "Recuerda Omega, [color=orange]rapidez[/color] y [color=purple]eficacia[/color].",
	"AUX6B_017" : "Hemos llegado.",
	"AUX6B_018" : "Omega mantente a la espera de confirmación.",
	"AUX6B_019" : "Confirmación recibida Omega, puedes acabar con el objetivo.",
	"AUX6B_020" : "Buen trabajo Omega.",
	"AUX6B_021" : "El objetivo ha sido eliminado con éxito.",
	"AUX6B_022" : "Veo que te has traído un pequeño recuerdo, bien...",
	"AUX6B_023" : "Tu siguiente misión será..."
}

##font,textsize,timechar,color,frame
var characters_data : Dictionary ={
	"Bigmin" : ["res://Recursos/Fuentes/MonomaniacOne-Regular.ttf",20,0.07,Color.DARK_GRAY,"res://Recursos/Sprites/UI/Border All 10.png"],
	"AUX6B" : ["res://Recursos/Fuentes/MonomaniacOne-Regular.ttf",16,0.05,Color.CORNFLOWER_BLUE,"res://Recursos/Sprites/UI/Border All 10.png"]
}
