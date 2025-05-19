extends Node

# DataManager: Handles all data loading and saving operations

const USER_PREFS_PATH = "res://data/settings/user_preferences.json"
const DEFAULT_SETTINGS_PATH = "res://data/settings/default_settings.json"
const PROGRESS_DATA_PATH = "res://data/progress/completion_data.json"

# Load text content based on reading level
func load_content(content_id: String, reading_level: int) -> String:
	var file_path = "res://data/content/text/level_%d/%s.txt" % [reading_level, content_id]
	var content = ""
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		content = file.get_as_text()
		return content
	
	# If file not found for specific level, try to load from level 1 as fallback
	if reading_level > 1:
		return load_content(content_id, 1)
		
	return "Content not found: " + content_id

# Load quiz questions
func load_questions(module: String) -> Array:
	var file_path = "res://data/content/questions/%s.json" % module
	var questions = []
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			questions = json.get_data()
	
	return questions

# Load glossary definitions based on reading level
func load_glossary(reading_level: int) -> Dictionary:
	var file_path = "res://data/content/definitions/glossary_level_%d.json" % reading_level
	var definitions = {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			definitions = json.get_data()
	
	return definitions

# Save user preferences
func save_user_preferences(preferences: Dictionary) -> void:
	var current_prefs = load_user_preferences()
	
	# Update with new preferences
	for key in preferences.keys():
		current_prefs[key] = preferences[key]
		
	var file = FileAccess.open(USER_PREFS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(current_prefs))

# Load user preferences
func load_user_preferences() -> Dictionary:
	var preferences = {}
	
	# First try to load existing preferences
	var file = FileAccess.open(USER_PREFS_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			preferences = json.get_data()
	else:
		# If no preferences exist, load defaults
		var default_file = FileAccess.open(DEFAULT_SETTINGS_PATH, FileAccess.READ)
		if default_file:
			var json = JSON.new()
			var parse_result = json.parse(default_file.get_as_text())
			if parse_result == OK:
				preferences = json.get_data()
				
				# Save defaults as current preferences
				save_user_preferences(preferences)
	
	return preferences

# Save progress data
func save_progress(module: String, progress_data: Dictionary) -> void:
	var all_progress = load_progress()
	all_progress[module] = progress_data
	
	var file = FileAccess.open(PROGRESS_DATA_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(all_progress))

# Load progress data
func load_progress() -> Dictionary:
	var progress = {}
	
	var file = FileAccess.open(PROGRESS_DATA_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			progress = json.get_data()
	
	return progress