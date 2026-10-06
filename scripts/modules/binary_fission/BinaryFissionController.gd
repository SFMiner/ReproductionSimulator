extends Control

# BinaryFissionController: Controls the binary fission module

# References to UI elements
@onready var play_button = $ControlPanel/PlayButton
@onready var pause_button = $ControlPanel/PauseButton
@onready var reset_button = $ControlPanel/ResetButton
@onready var step_button = $ControlPanel/StepButton
@onready var speed_slider = $ControlPanel/SpeedSlider
@onready var info_label = $InfoPanel/InfoLabel
@onready var progress_bar = $ProgressBar
@onready var cell_container = $CellContainer

# References to components
var single_cell: Node2D
var binary_fission: Node

# Current mode
var current_mode = "explore" # "explore" or "guided"

# Current animation speed
var animation_speed = 1.0

func _ready() -> void:
	# Initialize the binary fission process
	binary_fission = load("res://scripts/biology/reproduction/BinaryFission.gd").new()
	add_child(binary_fission)
	
	# Connect signals from binary fission process
	binary_fission.process_step_completed.connect(_on_process_step_completed)
	binary_fission.process_completed.connect(_on_process_completed)
	binary_fission.dna_replication_started.connect(_on_dna_replication_started)
	binary_fission.dna_replication_completed.connect(_on_dna_replication_completed)
	binary_fission.cell_elongation_started.connect(_on_cell_elongation_started)
	binary_fission.cell_elongation_completed.connect(_on_cell_elongation_completed)
	binary_fission.division_started.connect(_on_division_started)
	binary_fission.division_completed.connect(_on_division_completed)
	binary_fission.growth_started.connect(_on_growth_started)
	binary_fission.growth_completed.connect(_on_growth_completed)
	
	# Connect UI control signals
	play_button.pressed.connect(_on_play_pressed)
	pause_button.pressed.connect(_on_pause_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	step_button.pressed.connect(_on_step_pressed)
	speed_slider.value_changed.connect(_on_speed_changed)
	
	# Initialize UI state
	pause_button.disabled = true
	
	# Create initial cell
	_create_initial_cell()
	
	# Update information display
	_update_info_display("Welcome to Binary Fission! Press Play to start or Step to advance one phase at a time.")
	
	# Check for guided mode
	var args = get_tree().get_root().get_child(0).get_meta("module_args")
	if args and args.has("mode") and args["mode"] == "guided":
		current_mode = "guided"
		_start_guided_mode()
	
	# Set initial UI state based on mode
	_update_ui_for_mode()

# Create the initial cell
func _create_initial_cell() -> void:
	# Remove any existing cells
	for child in cell_container.get_children():
		child.queue_free()
	
	# Create a new prokaryotic cell
	single_cell = load("res://scripts/biology/base/Cell.gd").new("bacteria", false)
	single_cell.position = Vector2(cell_container.size.x / 2, cell_container.size.y / 2)
	single_cell.set_size(1.0)
	cell_container.add_child(single_cell)

# Update the information display
func _update_info_display(text: String) -> void:
	info_label.text = text
	
	# Play narration if in guided mode
	if current_mode == "guided":
		_play_narration_for_step(binary_fission.get_current_step_name())

# Play narration for a specific step
func _play_narration_for_step(step_name: String) -> void:
	var audio_manager = get_node_or_null("/root/Main/GameManager/AudioManager")
	if audio_manager:
		audio_manager.play_narration("binary_fission_" + step_name)

# UI control handlers
func _on_play_pressed() -> void:
	if binary_fission.is_complete:
		binary_fission.reset()
		_create_initial_cell()
	
	binary_fission.start()
	
	play_button.disabled = true
	pause_button.disabled = false
	step_button.disabled = true

func _on_pause_pressed() -> void:
	binary_fission.pause()
	
	play_button.disabled = false
	pause_button.disabled = true
	step_button.disabled = false

func _on_reset_pressed() -> void:
	binary_fission.reset()
	_create_initial_cell()
	
	play_button.disabled = false
	pause_button.disabled = true
	step_button.disabled = false
	
	progress_bar.value = 0
	_update_info_display("Binary fission process reset. Press Play to start again.")

func _on_step_pressed() -> void:
	if binary_fission.is_complete:
		binary_fission.reset()
		_create_initial_cell()
		
	if !binary_fission.is_running:
		binary_fission.start()
	else:
		binary_fission.advance_to_next_step()

func _on_speed_changed(value: float) -> void:
	animation_speed = value
	Engine.time_scale = value

# Process step handlers
func _on_process_step_completed(step_name: String) -> void:
	# Update progress bar
	progress_bar.value = binary_fission.get_progress_percentage()
	
	# If in guided mode, pause after each step
	if current_mode == "guided" and binary_fission.is_running and !binary_fission.is_paused:
		binary_fission.pause()
		play_button.disabled = false
		pause_button.disabled = true
		step_button.disabled = false

func _on_process_completed() -> void:
	play_button.disabled = false
	pause_button.disabled = true
	step_button.disabled = true
	
	_update_info_display("Binary fission complete! The cell has successfully divided into two identical daughter cells. Press Reset to start again.")
	
	# Mark as completed in progress tracker
	var progress_tracker = get_node_or_null("/root/Main/GameManager/ProgressTracker")
	if progress_tracker:
		progress_tracker.complete_module("binary_fission")

# Binary fission step event handlers
func _on_dna_replication_started() -> void:
	_update_info_display("DNA Replication: The bacterial DNA begins to replicate, creating a copy of the genetic material.")

func _on_dna_replication_completed() -> void:
	# Update cell visualization to show replicated DNA
	single_cell.replicate_dna()

func _on_cell_elongation_started() -> void:
	_update_info_display("Cell Elongation: The cell begins to grow and elongate, making room for the two sets of DNA.")

func _on_cell_elongation_completed() -> void:
	# Cell has reached full elongation
	pass

func _on_division_started() -> void:
	_update_info_display("Cell Division: The cell membrane begins to pinch inward at the center, separating the two DNA copies.")

func _on_division_completed() -> void:
	# Create a second cell
	var new_cell = single_cell.divide()
	cell_container.add_child(new_cell)
	
	# Position the cells
	single_cell.position = Vector2(cell_container.size.x / 3, cell_container.size.y / 2)
	new_cell.position = Vector2(2 * cell_container.size.x / 3, cell_container.size.y / 2)
	
	# Make both cells smaller initially
	single_cell.set_size(0.7)
	new_cell.set_size(0.7)

func _on_growth_started() -> void:
	_update_info_display("Growth Phase: The two daughter cells begin to grow to their full size.")

func _on_growth_completed() -> void:
	# Grow both cells to full size
	var tween = create_tween()
	tween.tween_method(Callable(single_cell, "set_size"), 0.7, 1.0, 1.0)
	
	var new_cell = cell_container.get_children()[1] if cell_container.get_child_count() > 1 else null
	if new_cell:
		var tween2 = create_tween()
		tween2.tween_method(Callable(new_cell, "set_size"), 0.7, 1.0, 1.0)

# Start guided learning mode
func _start_guided_mode() -> void:
	_update_info_display("Welcome to Guided Learning mode for Binary Fission. We'll walk through each step of how bacteria reproduce. Press Play or Step to begin.")

# Update UI based on current mode
func _update_ui_for_mode() -> void:
	if current_mode == "guided":
		$GuidedModeLabel.visible = true
		step_button.disabled = false
	else:
		$GuidedModeLabel.visible = false
