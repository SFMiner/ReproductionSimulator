extends Node

# BiologicalProcess: Base class for all biological processes
# This is a base class that defines common properties and methods for biological processes

signal process_step_completed(step_name)
signal process_completed

# Array of steps in this biological process
var process_steps = []

# Current step index
var current_step = -1

# Whether process is running
var is_running = false

# Whether process is paused
var is_paused = false

# Whether process is completed
var is_complete = false

# Initialize with process steps
func _init(steps = []) -> void:
	process_steps = steps

# Start the process
func start() -> void:
	if is_running or is_complete:
		return
		
	is_running = true
	is_paused = false
	is_complete = false
	current_step = -1
	
	# Start the first step
	advance_to_next_step()

# Pause the process
func pause() -> void:
	is_paused = true

# Resume the process
func resume() -> void:
	is_paused = false

# Stop the process
func stop() -> void:
	is_running = false
	is_paused = false
	current_step = -1

# Reset the process
func reset() -> void:
	stop()
	is_complete = false

# Go to the next step
func advance_to_next_step() -> void:
	if !is_running or is_paused or is_complete:
		return
	
	current_step += 1
	
	# Check if we've completed all steps
	if current_step >= process_steps.size():
		_complete_process()
		return
	
	# Execute the current step
	_execute_step(current_step)

# Force jump to a specific step
func jump_to_step(step_index: int) -> void:
	if step_index < 0 or step_index >= process_steps.size():
		return
	
	current_step = step_index - 1
	advance_to_next_step()

# Get the name of the current step
func get_current_step_name() -> String:
	if current_step >= 0 and current_step < process_steps.size():
		return process_steps[current_step]
	return ""

# Get the current step index
func get_current_step_index() -> int:
	return current_step

# Get the total number of steps
func get_total_steps() -> int:
	return process_steps.size()

# Get the progress percentage
func get_progress_percentage() -> float:
	if process_steps.size() > 0:
		return float(current_step + 1) / float(process_steps.size()) * 100.0
	return 0.0

# Check if a specific step is completed
func is_step_completed(step_index: int) -> bool:
	return step_index < current_step

# Virtual method to implement in child classes
func _execute_step(step_index: int) -> void:
	# To be implemented by child classes
	process_step_completed.emit(process_steps[step_index])

# Handle process completion
func _complete_process() -> void:
	is_running = false
	is_complete = true
	process_completed.emit()