extends Node

# AudioManager: Handles all audio playback and management

signal narration_finished

var narration_players = {}
var sfx_players = {}
var music_player = null

var current_reading_level = 1
var audio_enabled = true
var narration_enabled = true
var sfx_enabled = true
var music_enabled = true

func _ready() -> void:
	# Initialize audio players
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Connect to game manager for reading level changes
	var game_manager = get_parent()  # AudioManager is a child of GameManager
	if game_manager:
		game_manager.reading_level_changed.connect(_on_reading_level_changed)
	
	# Load audio settings from preferences
	await get_tree().process_frame  # Wait one frame to ensure DataManager is initialized
	var data_manager = get_parent().get_node("DataManager")  # DataManager is a sibling node
	
	# Make sure data_manager exists before using it
	if data_manager:
		var preferences = data_manager.load_user_preferences()
		
		if preferences.has("audio_enabled"):
			audio_enabled = preferences["audio_enabled"]
		if preferences.has("narration_enabled"):
			narration_enabled = preferences["narration_enabled"]
		if preferences.has("sfx_enabled"):
			sfx_enabled = preferences["sfx_enabled"]
		if preferences.has("music_enabled"):
			music_enabled = preferences["music_enabled"]
		if preferences.has("reading_level"):
			current_reading_level = preferences["reading_level"]
	
	# Apply settings
	set_audio_enabled(audio_enabled)
	set_narration_enabled(narration_enabled)
	set_sfx_enabled(sfx_enabled)
	set_music_enabled(music_enabled)

# Play narration audio based on content ID and reading level
func play_narration(content_id: String) -> void:
	if !narration_enabled or !audio_enabled:
		narration_finished.emit()
		return
	
	# Stop any currently playing narration
	stop_narration()
	
	# Construct path to narration audio
	var audio_path = "res://assets/audio/narration/level_%d/%s.ogg" % [current_reading_level, content_id]
	
	# Check if audio exists
	if ResourceLoader.exists(audio_path):
		var stream = load(audio_path)
		if stream:
			# Create player if not exists
			if !narration_players.has(content_id):
				var player = AudioStreamPlayer.new()
				player.bus = "Narration"
				player.finished.connect(func(): _on_narration_finished(content_id))
				add_child(player)
				narration_players[content_id] = player
			
			# Set stream and play
			narration_players[content_id].stream = stream
			narration_players[content_id].play()
		else:
			narration_finished.emit()
	else:
		# If not found for current level, try level 1 as fallback
		if current_reading_level > 1:
			current_reading_level = 1
			play_narration(content_id)
		else:
			narration_finished.emit()

# Play sound effect
func play_sfx(sfx_name: String) -> void:
	if !sfx_enabled or !audio_enabled:
		return
	
	var audio_path = "res://assets/audio/sfx/%s.ogg" % sfx_name
	
	if ResourceLoader.exists(audio_path):
		var stream = load(audio_path)
		if stream:
			# Create player if not exists
			if !sfx_players.has(sfx_name):
				var player = AudioStreamPlayer.new()
				player.bus = "SFX"
				add_child(player)
				sfx_players[sfx_name] = player
			
			# Set stream and play
			sfx_players[sfx_name].stream = stream
			sfx_players[sfx_name].play()

# Play background music
func play_music(music_name: String, crossfade_duration: float = 1.0) -> void:
	if !music_enabled or !audio_enabled:
		return
	
	var audio_path = "res://assets/audio/music/%s.ogg" % music_name
	
	if ResourceLoader.exists(audio_path):
		var stream = load(audio_path)
		if stream:
			# If already playing, crossfade
			if music_player.playing:
				var tween = create_tween()
				tween.tween_property(music_player, "volume_db", -80.0, crossfade_duration)
				tween.tween_callback(func(): _set_music_stream(stream))
				tween.tween_property(music_player, "volume_db", 0.0, crossfade_duration)
			else:
				# Just play if nothing is playing
				music_player.stream = stream
				music_player.play()

# Stop narration
func stop_narration() -> void:
	for player in narration_players.values():
		if player.playing:
			player.stop()

# Stop music
func stop_music(fade_duration: float = 1.0) -> void:
	if music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_duration)
		tween.tween_callback(func(): music_player.stop())

# Audio setting functions
func set_audio_enabled(enabled: bool) -> void:
	audio_enabled = enabled
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !enabled)
	
	var data_manager = get_parent().get_node("DataManager")  # DataManager is a sibling node
	if data_manager:
		data_manager.save_user_preferences({"audio_enabled": enabled})

# Only affects narration audio
func set_narration_enabled(enabled: bool) -> void:
	narration_enabled = enabled
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Narration"), !enabled)
	
	var data_manager = get_parent().get_node("DataManager")  # DataManager is a sibling node
	if data_manager:
		data_manager.save_user_preferences({"narration_enabled": enabled})

# Only affects sound effects
func set_sfx_enabled(enabled: bool) -> void:
	sfx_enabled = enabled
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !enabled)
	
	var data_manager = get_parent().get_node("DataManager")  # DataManager is a sibling node
	if data_manager:
		data_manager.save_user_preferences({"sfx_enabled": enabled})

# Only affects background music
func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !enabled)
	
	var data_manager = get_parent().get_node("DataManager")  # DataManager is a sibling node
	if data_manager:
		data_manager.save_user_preferences({"music_enabled": enabled})

# Helper function for crossfading music
func _set_music_stream(stream) -> void:
	music_player.stream = stream
	music_player.play()

# Signal handlers
func _on_narration_finished(content_id: String) -> void:
	narration_finished.emit()

func _on_reading_level_changed(level: int) -> void:
	current_reading_level = level