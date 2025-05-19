extends "res://scripts/biology/base/BiologicalProcess.gd"

# BinaryFission: Implements the binary fission process for single-celled organisms

signal dna_replication_started
signal dna_replication_completed
signal cell_elongation_started
signal cell_elongation_completed
signal division_started
signal division_completed
signal growth_started
signal growth_completed

# Define process steps
const BINARY_FISSION_STEPS = [
	"cell_preparation",
	"dna_replication",
	"cell_elongation",
	"cell_division",
	"growth_phase"
]

# Cell size growth factor
var growth_factor = 1.0

# Initialize with binary fission steps
func _init():
	super._init(BINARY_FISSION_STEPS)

# Override execute step to handle binary fission specific logic
func _execute_step(step_index: int) -> void:
	if step_index < 0 or step_index >= process_steps.size():
		return
		
	var step_name = process_steps[step_index]
	
	match step_name:
		"cell_preparation":
			_handle_cell_preparation()
		"dna_replication":
			_handle_dna_replication()
		"cell_elongation":
			_handle_cell_elongation()
		"cell_division":
			_handle_cell_division()
		"growth_phase":
			_handle_growth_phase()
	
	# Emit the step completion signal
	process_step_completed.emit(step_name)

# Cell preparation step
func _handle_cell_preparation() -> void:
	# Reset growth factor
	growth_factor = 1.0
	
	# This step is mostly initialization, so we can advance immediately
	# In a real implementation, this might include animations or other setup

# DNA replication step
func _handle_dna_replication() -> void:
	# Signal that DNA replication has started
	dna_replication_started.emit()
	
	# In a real implementation, this would trigger animations
	# For now, we'll just use a timer to simulate the process
	
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	
	# Signal that DNA replication is complete
	dna_replication_completed.emit()

# Cell elongation step
func _handle_cell_elongation() -> void:
	# Signal that cell elongation has started
	cell_elongation_started.emit()
	
	# In a real implementation, this would animate the cell growing
	# For now, we'll use a timer and gradually increase the growth factor
	
	growth_factor = 1.0
	
	var tween = create_tween()
	tween.tween_property(self, "growth_factor", 2.0, 2.0)
	await tween.finished
	
	# Signal that cell elongation is complete
	cell_elongation_completed.emit()

# Cell division step
func _handle_cell_division() -> void:
	# Signal that division has started
	division_started.emit()
	
	# In a real implementation, this would animate the cell splitting
	# For now, we'll just use a timer to simulate the process
	
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	
	# Reset growth factor as we now have two smaller cells
	growth_factor = 1.0
	
	# Signal that division is complete
	division_completed.emit()

# Growth phase step
func _handle_growth_phase() -> void:
	# Signal that growth has started
	growth_started.emit()
	
	# In a real implementation, this would animate the new cells growing
	# For now, we'll use a timer and gradually increase the growth factor
	
	var tween = create_tween()
	tween.tween_property(self, "growth_factor", 1.5, 3.0)
	await tween.finished
	
	# Signal that growth is complete
	growth_completed.emit()
	
	# This is the last step, so the process will complete after this