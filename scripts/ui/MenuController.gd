extends Control

# MenuController: Handles main menu functionality

var current_mode = "explore"  # Current selected mode

func _ready() -> void:
	# Connect button signals
	$ButtonContainer/ExploreButton.pressed.connect(_on_explore_pressed)
	$ButtonContainer/GuidedLearningButton.pressed.connect(_on_guided_learning_pressed)
	$ButtonContainer/CompareButton.pressed.connect(_on_compare_pressed)
	$ButtonContainer/QuizButton.pressed.connect(_on_quiz_pressed)
	$ButtonContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	
	# Connect module selection dialog buttons
	$ModuleSelectionDialog/ModuleContainer/BinaryFissionButton.pressed.connect(func(): _on_module_selected("binary_fission"))
	$ModuleSelectionDialog/ModuleContainer/MitosisButton.pressed.connect(func(): _on_module_selected("mitosis"))
	$ModuleSelectionDialog/ModuleContainer/AmphibianButton.pressed.connect(func(): _on_module_selected("amphibian"))
	$ModuleSelectionDialog/ModuleContainer/BirdButton.pressed.connect(func(): _on_module_selected("bird"))
	$ModuleSelectionDialog/ModuleContainer/HumanButton.pressed.connect(func(): _on_module_selected("human"))
	$ModuleSelectionDialog/ModuleContainer/CancelButton.pressed.connect(func(): $ModuleSelectionDialog.hide())
	
	# Connect settings dialog buttons
	$SettingsDialog/SettingsContainer/CloseButton.pressed.connect(_on_settings_close_pressed)
	$SettingsDialog.close_requested.connect(_on_settings_close_requested)
	
	# Connect settings buttons to appropriate functions
	var master_checkbox = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/MasterCheckBox
	master_checkbox.toggled.connect(func(button_pressed): _on_audio_setting_changed("master", button_pressed))
	
	var narration_checkbox = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/NarrationCheckBox
	narration_checkbox.toggled.connect(func(button_pressed): _on_audio_setting_changed("narration", button_pressed))
	
	var sfx_checkbox = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/SFXCheckBox
	sfx_checkbox.toggled.connect(func(button_pressed): _on_audio_setting_changed("sfx", button_pressed))
	
	var music_checkbox = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/MusicCheckBox
	music_checkbox.toggled.connect(func(button_pressed): _on_audio_setting_changed("music", button_pressed))
	
	# Play background music
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_music("menu_music")

# Custom function to show module selection with a specific mode
func show_for_mode(mode: String) -> void:
	current_mode = mode
	$ModuleSelectionDialog.show()
	$ModuleSelectionDialog.popup_centered()

# Explore Mode button
func _on_explore_pressed() -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Show the module selection dialog
	show_for_mode("explore")

# Guided Learning button
func _on_guided_learning_pressed() -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Show the module selection dialog
	show_for_mode("guided")

# Compare & Contrast button
func _on_compare_pressed() -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Navigate to comparison scene
	var game_manager = get_node_or_null("/root/Main/GameManager")
	if game_manager:
		game_manager.change_module("comparison")

# Quiz Mode button
func _on_quiz_pressed() -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Navigate to quiz scene
	var game_manager = get_node_or_null("/root/Main/GameManager")
	if game_manager:
		game_manager.change_module("quiz")

# Settings button
func _on_settings_pressed() -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Show settings dialog
	$SettingsDialog.popup_centered()

# Handle module selection
func _on_module_selected(module_name: String) -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Hide the dialog
	$ModuleSelectionDialog.hide()
	
	# Navigate to the selected module
	var game_manager = get_node_or_null("/root/Main/GameManager")
	if game_manager:
		# Add mode as metadata
		var meta = {"mode": current_mode}
		# Set meta on the current scene
		get_tree().current_scene.set_meta("module_args", meta)
		# Change to the module
		game_manager.change_module(module_name)

# Handle settings dialog close button
func _on_settings_close_pressed() -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Save settings and close dialog
	save_settings()
	$SettingsDialog.hide()

# Handle settings dialog close request (X button)
func _on_settings_close_requested() -> void:
	# Play button sound
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
	
	# Save settings and close dialog
	save_settings()
	$SettingsDialog.hide()

# Save settings to user preferences
func save_settings() -> void:
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		# Get settings from checkboxes
		var master_enabled = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/MasterCheckBox.button_pressed
		var narration_enabled = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/NarrationCheckBox.button_pressed
		var sfx_enabled = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/SFXCheckBox.button_pressed
		var music_enabled = $SettingsDialog/SettingsContainer/AudioSection/AudioGrid/MusicCheckBox.button_pressed
		
		# Apply settings
		audio_manager.set_audio_enabled(master_enabled)
		audio_manager.set_narration_enabled(narration_enabled)
		audio_manager.set_sfx_enabled(sfx_enabled)
		audio_manager.set_music_enabled(music_enabled)

# Handle audio setting changes
func _on_audio_setting_changed(setting: String, enabled: bool) -> void:
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		match setting:
			"master":
				audio_manager.set_audio_enabled(enabled)
			"narration":
				audio_manager.set_narration_enabled(enabled)
			"sfx":
				audio_manager.set_sfx_enabled(enabled)
			"music":
				audio_manager.set_music_enabled(enabled)
