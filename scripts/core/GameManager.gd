extends Node

# GameManager: Central controller for game state and functions

signal reading_level_changed(level)
signal scene_transition_requested(target_scene)

enum ReadingLevel {
	LEVEL_1 = 1, # Ages 6-7: Simple words, picture-heavy
	LEVEL_2 = 2, # Ages 8-10: Intermediate vocabulary
	LEVEL_3 = 3  # Ages 11+: Scientific terminology
}

var current_reading_level: int = ReadingLevel.LEVEL_1
var current_module: String = ""

# Reference to other managers
var data_manager: Node
var audio_manager: Node
var progress_tracker: Node

func _ready() -> void:
	# Check whether this script is attached to Main or GameManager node
	var node_name = get_tree().current_scene.name if get_tree().current_scene else name
	
	if node_name == "Main":
		# Script is attached to Main node
		if has_node("GameManager"):
			var game_manager_node = get_node("GameManager")
			data_manager = game_manager_node.get_node_or_null("DataManager")
			audio_manager = game_manager_node.get_node_or_null("AudioManager")
			progress_tracker = game_manager_node.get_node_or_null("ProgressTracker")
	else:
		# Script is attached to GameManager node
		data_manager = get_node_or_null("DataManager")
		audio_manager = get_node_or_null("AudioManager")
		progress_tracker = get_node_or_null("ProgressTracker")
	
	# Ensure nodes are properly initialized
	if data_manager:
		# Load user preferences if any
		load_user_preferences()
	else:
		# If data_manager is null, wait one frame and try again
		await get_tree().process_frame
		if data_manager:
			load_user_preferences()
	
	# If this is the Main node, initialize the game by navigating to the main menu
	if node_name == "Main":
		# Wait a moment to ensure all systems are initialized
		await get_tree().process_frame
		# Navigate to the main menu
		change_module("")  # Empty string defaults to MainMenu.tscn

# Handle switching between reading levels
func set_reading_level(level: int) -> void:
	if level >= ReadingLevel.LEVEL_1 and level <= ReadingLevel.LEVEL_3:
		current_reading_level = level
		reading_level_changed.emit(level)
		data_manager.save_user_preferences({"reading_level": level})

func get_reading_level() -> int:
	return current_reading_level

# Handle module navigation
func change_module(module_name: String) -> void:
	current_module = module_name
	
	var target_scene = ""
	
	match module_name:
		"binary_fission":
			target_scene = "res://scenes/modules/binary_fission/BinaryFissionMain.tscn"
		"mitosis":
			target_scene = "res://scenes/modules/mitosis/MitosisMain.tscn"
		"amphibian":
			target_scene = "res://scenes/modules/sexual_reproduction/amphibian/AmphibianMain.tscn"
		"bird":
			target_scene = "res://scenes/modules/sexual_reproduction/bird/BirdMain.tscn"
		"human":
			target_scene = "res://scenes/modules/sexual_reproduction/human/HumanMain.tscn"
		"comparison":
			target_scene = "res://scenes/comparison/ComparisonMain.tscn"
		"quiz":
			target_scene = "res://scenes/assessment/QuizMain.tscn"
		_:
			target_scene = "res://scenes/main/MainMenu.tscn"
	
	scene_transition_requested.emit(target_scene)
	
# Save/Load user preferences
func load_user_preferences() -> void:
	var preferences = data_manager.load_user_preferences()
	if preferences.has("reading_level"):
		set_reading_level(preferences["reading_level"])
