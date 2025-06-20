extends Node

# Reproductores
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var combat_player: AudioStreamPlayer2D = $CombatPlayer

# Estos arrays contendran reproductores adicionales para cada categoría
var sfx_player_pool: Array[AudioStreamPlayer2D]
var combat_player_pool: Array[AudioStreamPlayer2D]

# Tamaño de los pool
const MAX_SIMULTANEOUS_SFX: int = 5
const MAX_SIMULTANEOUS_COMBAT: int = 3

# Diccionarios de sonidos
var music_tracks: Dictionary[String, Object]
var sfx_sounds: Dictionary[String, Object]
var combat_sounds: Dictionary[String, Object]

func _ready() -> void:
	_setup_audio_pools()
	_load_audio_resources()

func _setup_audio_pools() -> void:
	# Creamos reproductores adicionales para sfx_sounds
	for i in MAX_SIMULTANEOUS_SFX:
		var new_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		# Copiamos la configuracion del reproductor principal
		new_player.bus = sfx_player.bus
		new_player.attenuation = sfx_player.attenuation
		new_player.max_distance = sfx_player.max_distance
		# Añadimos el reproductor a la escena y al pool
		add_child(new_player)
		sfx_player_pool.append(new_player)
	
	# Hacemos lo mismo para combat_sounds
	for i in MAX_SIMULTANEOUS_COMBAT:
		var new_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		new_player.bus = combat_player.bus
		new_player.attenuation = combat_player.attenuation
		new_player.max_distance = combat_player.max_distance
		add_child(new_player)
		combat_player_pool.append(new_player)
	
	print("Audio pools created - SFX: ", sfx_player_pool.size(), ", Combat: ", combat_player_pool.size())
	
func _find_available_player(pool: Array[AudioStreamPlayer2D], main_player: AudioStreamPlayer2D) -> AudioStreamPlayer2D:
	# Primero intentamos usar el reproductor principal si esta libre
	if !main_player.playing:
		return main_player
	
	# Si el principal esta ocupado, buscamos en el pool
	for player in pool:
		if !player.playing:
			return player
	
	# Si todos estan ocupados, usamos el mas antiguo
	var oldest_player: AudioStreamPlayer2D = pool[0]
	var oldest_time: float = 0.0
	
	for player in pool:
		var playback_position: float = player.get_playback_position()
		if playback_position > oldest_time:
			oldest_time = playback_position
			oldest_player = player
	
	return oldest_player

func play_sfx(sound_name: String, max_distance: int = 2000, position: Vector2 = Vector2.ZERO, volume: float = 1.0, pitch: float = 1.0) -> void:
	if !sound_name in sfx_sounds:
		print("SFX sound not found: ", sound_name)
		return
	
	# Encontramos un reproductor disponible
	var player: AudioStreamPlayer2D = _find_available_player(sfx_player_pool, sfx_player)
	
	# Configuramos y reproducimos el sonido
	player.stream = sfx_sounds[sound_name]
	player.global_position = position
	player.max_distance = max_distance
	player.volume_db = linear_to_db(volume)
	player.pitch_scale = pitch
	player.play()

func play_combat_sound(sound_name: String, position: Vector2 = Vector2.ZERO, volume: float = 1.0, pitch: float = 1.0) -> void:
	if !sound_name in combat_sounds:
		print("Combat sound not found: ", sound_name)
		return
	
	var player: AudioStreamPlayer2D = _find_available_player(combat_player_pool, combat_player)
	
	player.stream = combat_sounds[sound_name]
	player.global_position = position
	player.volume_db = linear_to_db(volume)
	player.pitch_scale = pitch
	player.play()

func play_music(track_name: String, volume: float, fade_in: bool = false) -> void:
	if !track_name in music_tracks:
		print("Music track not found: ", track_name)
		return
	
	music_player.stream = music_tracks[track_name]
	music_player.volume_db = linear_to_db(volume)
	music_player.play()
	
	if fade_in:
		music_player.volume_db = -80
		var tween: Tween = create_tween()
		tween.tween_property(music_player, "volume_db", linear_to_db(volume), 1.5)
		
func stop_music() -> void:
	if music_player.playing:
		music_player.volume_db = -80
		var tween: Tween = create_tween()
		tween.tween_property(music_player, "volume_db", 0, 2.0)
		
		
func _load_audio_resources() -> void:
	# SFX
	sfx_sounds["fan"] = preload("res://Audio/sfx/fan.wav")
	sfx_sounds["die"] = preload("res://Audio/sfx/Die.wav")
	sfx_sounds["door"] = preload("res://Audio/sfx/Door.wav")
	sfx_sounds["jump"] = preload("res://Audio/sfx/Jump_Player.wav")
	sfx_sounds["hit"] = preload("res://Audio/sfx/Hit.wav")
	sfx_sounds["run"] = preload("res://Audio/sfx/Run.wav")
	sfx_sounds["transform"] = preload("res://Audio/sfx/Transform.wav")
	sfx_sounds["range_attack_enemy"] = preload("res://Audio/sfx/Range_Attack_Enemy.wav")
	sfx_sounds["range_shoot_bad"] = preload("res://Audio/sfx/range_shoot_bad.wav")
	sfx_sounds["Slit"] = preload("res://Audio/sfx/Slit.wav")
	sfx_sounds["melee_attack_player"] = preload("res://Audio/sfx/Melee_Attack_Player.wav")
	sfx_sounds["range_attack_player"] = preload("res://Audio/sfx/Range_Attack_Player.wav")
	sfx_sounds["bullet_died"] = preload("res://Audio/sfx/bullet_died.wav")
	
	
	
	# Musica
	music_tracks["NaturalLife"] = preload("res://Audio/music/DavidKBD - HexaPuppies Pack - 05 - Natural Life - 3(1).ogg")
	music_tracks["LightYearCity"] = preload("res://Audio/music/DavidKBD - Pink Bloom Pack - 09 - Lightyear City.ogg")
	music_tracks["Portal to Underworld"] = preload("res://Audio/music/DavidKBD - Pink Bloom Pack - 02 - Portal to Underworld.ogg")
	music_tracks["TheHiddenOne"] = preload("res://Audio/music/DavidKBD - Pink Bloom Pack - 07 - The Hidden One.ogg")
	music_tracks["Disaster"] = preload("res://Audio/music/DavidKBD - HexaPuppies Pack - 09 - Disaster - 1.ogg")
