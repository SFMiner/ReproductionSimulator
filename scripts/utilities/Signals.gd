extends Node

# Signals.gd: Global signals for the application

# Signal bus for app-wide communication

# Module navigation
signal module_selected(module_name, mode)
signal return_to_menu_requested
signal module_completed(module_name)

# Reading level changes
signal reading_level_changed(level)

# Progress tracking
signal progress_updated(module, percentage)
signal step_completed(module, step)
signal quiz_completed(module, score)

# UI interaction
signal definition_requested(term)
signal help_requested(context)

# Audio
signal narration_started(content_id)
signal narration_completed
signal background_music_changed(track_name)

# Biology processes
signal process_step_started(process_name, step)
signal process_step_completed(process_name, step)
signal process_completed(process_name)

# Accessibility
signal accessibility_setting_changed(setting, value)