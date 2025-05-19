extends Node

# ProgressTracker: Manages user progress through the modules

signal module_completed(module_name)
signal quiz_completed(module_name, score)

var module_progress = {}
var quiz_scores = {}

func _ready() -> void:
	# Load saved progress data
	await get_tree().process_frame  # Wait one frame to ensure DataManager is initialized
	var data_manager = get_parent().get_node("DataManager")  # DataManager is a sibling node
	
	if data_manager:
		var progress_data = data_manager.load_progress()
		
		# Initialize module progress from saved data
		if progress_data.has("modules"):
			module_progress = progress_data["modules"]
		
		# Initialize quiz scores from saved data
		if progress_data.has("quizzes"):
			quiz_scores = progress_data["quizzes"]

# Mark a specific module step as completed
func complete_module_step(module: String, step: String) -> void:
	# Initialize module if not exists
	if !module_progress.has(module):
		module_progress[module] = {
			"completed": false,
			"steps_completed": []
		}
	
	# Add step if not already completed
	if !module_progress[module]["steps_completed"].has(step):
		module_progress[module]["steps_completed"].append(step)
		
	# Save progress
	_save_progress()

# Mark an entire module as completed
func complete_module(module: String) -> void:
	# Initialize module if not exists
	if !module_progress.has(module):
		module_progress[module] = {
			"completed": false,
			"steps_completed": []
		}
	
	# Mark as completed
	module_progress[module]["completed"] = true
	
	# Save progress
	_save_progress()
	
	# Emit completion signal
	module_completed.emit(module)

# Record quiz score
func record_quiz_score(module: String, score: float) -> void:
	# Initialize quiz entry if not exists
	if !quiz_scores.has(module):
		quiz_scores[module] = {
			"best_score": 0.0,
			"attempts": 0,
			"history": []
		}
	
	# Update quiz data
	quiz_scores[module]["attempts"] += 1
	quiz_scores[module]["history"].append({
		"score": score,
		"timestamp": Time.get_unix_time_from_system()
	})
	
	# Update best score if current is better
	if score > quiz_scores[module]["best_score"]:
		quiz_scores[module]["best_score"] = score
	
	# Save progress
	_save_progress()
	
	# Emit completion signal
	quiz_completed.emit(module, score)

# Check if a module has been completed
func is_module_completed(module: String) -> bool:
	if !module_progress.has(module):
		return false
		
	return module_progress[module]["completed"]

# Check if a specific module step has been completed
func is_step_completed(module: String, step: String) -> bool:
	if !module_progress.has(module):
		return false
		
	return module_progress[module]["steps_completed"].has(step)

# Get best quiz score for a module
func get_best_quiz_score(module: String) -> float:
	if !quiz_scores.has(module):
		return 0.0
		
	return quiz_scores[module]["best_score"]

# Get overall progress percentage across all modules
func get_overall_progress() -> float:
	var total_modules = 7 # binary_fission, mitosis, amphibian, bird, human, comparison, quiz
	var completed_modules = 0
	
	for module in module_progress.keys():
		if module_progress[module]["completed"]:
			completed_modules += 1
			
	if total_modules > 0:
		return float(completed_modules) / float(total_modules) * 100.0
	else:
		return 0.0

# Reset all progress (for debugging or user requested reset)
func reset_all_progress() -> void:
	module_progress = {}
	quiz_scores = {}
	_save_progress()

# Save progress to file
func _save_progress() -> void:
	var progress_data = {
		"modules": module_progress,
		"quizzes": quiz_scores
	}
	
	var data_manager = get_parent().get_node("DataManager")  # DataManager is a sibling node
	if data_manager:
		data_manager.save_progress("progress", progress_data)