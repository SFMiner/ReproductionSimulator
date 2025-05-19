extends Node

# ReadingLevelManager: Handles reading level adjustments in the UI

signal level_changed(new_level)

var current_level: int = 1 # 1, 2, or 3

func _ready() -> void:
	# Get initial reading level from GameManager
	# Check if we're in the same scene tree as GameManager
	var game_manager = get_node_or_null("/root/Main/GameManager")
	if game_manager:
		current_level = game_manager.get_reading_level()
		
		# Connect to GameManager reading level signal
		game_manager.reading_level_changed.connect(_on_game_manager_level_changed)

# Change the current reading level
func set_reading_level(level: int) -> void:
	if level >= 1 and level <= 3:
		current_level = level
		
		# Update GameManager
		var game_manager = get_node_or_null("/root/Main/GameManager")
		if game_manager:
			game_manager.set_reading_level(level)
		
		# Emit our own signal
		level_changed.emit(level)

# Get text content appropriate for current reading level
func get_content_for_level(content_id: String) -> String:
	var data_manager = get_node_or_null("/root/Main/GameManager/DataManager")
	if data_manager:
		return data_manager.load_content(content_id, current_level)
	return "Content not available: " + content_id

# Format a string for the current reading level
func format_for_level(content_id: String, params: Dictionary = {}) -> String:
	var content = get_content_for_level(content_id)
	
	# Replace parameters in the text
	for key in params.keys():
		content = content.replace("{" + key + "}", str(params[key]))
		
	return content

# Signal handler for GameManager reading level changes
func _on_game_manager_level_changed(level: int) -> void:
	current_level = level
	level_changed.emit(level)