extends Node2D

# Cell: Base class for all cell types

signal cell_selected

# Cell properties
var cell_type = "generic" # Type of cell
var size_multiplier = 1.0 # Size scaling factor
var has_nucleus = false   # Whether the cell has a nucleus
var dna_replicated = false # Whether DNA has been replicated
var organelles = []       # List of organelles in the cell

# Visuals
var base_color = Color(0.7, 0.85, 0.9, 0.9) # Base cell color
var outline_color = Color(0.2, 0.4, 0.7, 1.0) # Cell membrane color
var outline_thickness = 2.0 # Cell membrane thickness
var selected = false # Whether cell is currently selected

func _init(type = "generic", has_nucleus_val = false) -> void:
	cell_type = type
	has_nucleus = has_nucleus_val
	
	# Set colors based on cell type
	match type:
		"bacteria":
			base_color = Color(0.7, 0.85, 0.9, 0.9)
			outline_color = Color(0.2, 0.4, 0.7, 1.0)
		"animal":
			base_color = Color(0.9, 0.8, 0.8, 0.9)
			outline_color = Color(0.7, 0.3, 0.3, 1.0)
		"plant":
			base_color = Color(0.8, 0.9, 0.8, 0.9)
			outline_color = Color(0.3, 0.7, 0.3, 1.0)
		_:
			# Default colors already set
			pass

func _ready() -> void:
	# Make cell clickable
	input_pickable = true
	input_event.connect(_on_Cell_input_event)

func _draw() -> void:
	# Draw cell body (cytoplasm)
	var radius = 50.0 * size_multiplier
	draw_circle(Vector2.ZERO, radius, base_color)
	
	# Draw cell membrane (outline)
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, outline_color, outline_thickness)
	
	# Draw selection indicator if selected
	if selected:
		draw_arc(Vector2.ZERO, radius + 5, 0, TAU, 64, Color(1.0, 1.0, 0.2, 1.0), 2.0)
	
	# Draw nucleus if present
	if has_nucleus:
		var nucleus_radius = radius * 0.3
		draw_circle(Vector2.ZERO, nucleus_radius, Color(0.4, 0.4, 0.6, 1.0))
		
		# Draw nucleolus
		draw_circle(Vector2.ZERO, nucleus_radius * 0.4, Color(0.3, 0.3, 0.5, 1.0))
	
	# Draw DNA
	_draw_dna()
	
	# Draw organelles
	_draw_organelles()

# Draw DNA
func _draw_dna() -> void:
	var radius = 50.0 * size_multiplier
	
	if has_nucleus:
		# Draw DNA inside nucleus
		var nucleus_radius = radius * 0.3
		
		if dna_replicated:
			# Draw replicated chromosomes
			draw_circle(Vector2(-nucleus_radius * 0.3, 0), 5, Color(0.7, 0.2, 0.2, 1.0))
			draw_circle(Vector2(nucleus_radius * 0.3, 0), 5, Color(0.7, 0.2, 0.2, 1.0))
		else:
			# Draw single chromosome
			draw_circle(Vector2.ZERO, 5, Color(0.7, 0.2, 0.2, 1.0))
	else:
		# For prokaryotes, draw DNA in the cytoplasm
		if dna_replicated:
			# Draw replicated DNA (circular)
			draw_arc(Vector2(-radius * 0.2, 0), 10, 0, TAU, 32, Color(0.7, 0.2, 0.2, 0.8), 2.0)
			draw_arc(Vector2(radius * 0.2, 0), 10, 0, TAU, 32, Color(0.7, 0.2, 0.2, 0.8), 2.0)
		else:
			# Draw single DNA (circular)
			draw_arc(Vector2.ZERO, 15, 0, TAU, 32, Color(0.7, 0.2, 0.2, 0.8), 2.0)

# Draw organelles
func _draw_organelles() -> void:
	var radius = 50.0 * size_multiplier
	
	# Only draw organelles if eukaryote
	if has_nucleus:
		# Draw a few mitochondria
		_draw_mitochondrion(Vector2(radius * 0.5, radius * 0.3), 10, 5)
		_draw_mitochondrion(Vector2(-radius * 0.4, radius * 0.4), 12, 6)
		_draw_mitochondrion(Vector2(radius * 0.3, -radius * 0.5), 8, 4)
		
		# Draw some endoplasmic reticulum
		_draw_endoplasmic_reticulum(Vector2(-radius * 0.3, -radius * 0.4), 20, 10)

# Draw a mitochondrion
func _draw_mitochondrion(position: Vector2, length: float, width: float) -> void:
	var color = Color(0.9, 0.5, 0.5, 0.8)
	var outline_color = Color(0.8, 0.4, 0.4, 1.0)
	
	# Draw oval shape
	var points = PackedVector2Array()
	for i in range(12):
		var angle = i * TAU / 12
		var x = cos(angle) * length
		var y = sin(angle) * width
		points.append(Vector2(x, y) + position)
	
	draw_colored_polygon(points, color)
	
	# Draw outline
	for i in range(12):
		var start_point = points[i]
		var end_point = points[(i + 1) % 12]
		draw_line(start_point, end_point, outline_color, 1.0)
	
	# Draw cristae (internal folds)
	var cristae_count = 3
	var cristae_spacing = length * 2 / (cristae_count + 1)
	
	for i in range(cristae_count):
		var x = position.x - length + cristae_spacing * (i + 1)
		draw_line(Vector2(x, position.y - width * 0.7), Vector2(x, position.y + width * 0.7), outline_color, 1.0)

# Draw endoplasmic reticulum
func _draw_endoplasmic_reticulum(position: Vector2, width: float, height: float) -> void:
	var color = Color(0.6, 0.6, 0.9, 0.7)
	var outline_color = Color(0.5, 0.5, 0.8, 1.0)
	
	var y_step = height / 4
	
	for i in range(5):
		var y = position.y - height / 2 + i * y_step
		var x_start = position.x - width / 2
		var x_end = position.x + width / 2
		
		if i % 2 == 0:
			draw_line(Vector2(x_start, y), Vector2(x_end, y), outline_color, 1.5)
		else:
			draw_line(Vector2(x_start + 5, y), Vector2(x_end - 5, y), outline_color, 1.5)
	
	# Connect the horizontal lines
	for i in range(4):
		var y_top = position.y - height / 2 + i * y_step
		var y_bottom = y_top + y_step
		
		if i % 2 == 0:
			draw_line(Vector2(position.x + width / 2, y_top), Vector2(position.x + width / 2 - 5, y_bottom), outline_color, 1.5)
		else:
			draw_line(Vector2(position.x - width / 2, y_top), Vector2(position.x - width / 2 + 5, y_bottom), outline_color, 1.5)

# Replicate DNA in the cell
func replicate_dna() -> void:
	dna_replicated = true
	queue_redraw()

# Reset DNA to unreplicated state
func reset_dna() -> void:
	dna_replicated = false
	queue_redraw()

# Set the cell size multiplier
func set_size(multiplier: float) -> void:
	size_multiplier = multiplier
	queue_redraw()

# Handle selection events
func select() -> void:
	selected = true
	queue_redraw()
	cell_selected.emit()

# Deselect the cell
func deselect() -> void:
	selected = false
	queue_redraw()

# Handle input events
func _on_Cell_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		select()

# Divide the cell and return a new cell
func divide() -> Node2D:
	# Create a new cell of the same type
	var new_cell = load("res://scripts/biology/base/Cell.gd").new(cell_type, has_nucleus)
	new_cell.size_multiplier = size_multiplier
	
	# Reset DNA for both cells
	reset_dna()
	new_cell.reset_dna()
	
	return new_cell