extends CanvasLayer

# SceneTransition: Handles smooth transitions between scenes

signal transition_completed

@onready var animation_player = $AnimationPlayer
@onready var black_rect = $ColorRect

func _ready() -> void:
	black_rect.visible = false
	
	# Connect to scene transition signal
	# Look for GameManager in the scene tree
	var game_manager
	
	# Try to find GameManager at different possible locations
	if get_tree().current_scene.name == "Main":
		# If we're in the Main scene
		if get_tree().current_scene.has_node("GameManager"):
			game_manager = get_tree().current_scene.get_node("GameManager")
	else:
		# Try other possible paths
		game_manager = get_node_or_null("/root/Main/GameManager")
		if not game_manager:
			game_manager = get_node_or_null("/root/GameManager")
	
	if game_manager:
		game_manager.scene_transition_requested.connect(transition_to)

# Fade to black, change scene, then fade back in
func transition_to(target_scene: String) -> void:
	# Make overlay visible and play fade in animation
	black_rect.visible = true
	animation_player.play("fade_to_black")
	
	# Wait for animation to finish
	await animation_player.animation_finished
	
	# Change to the target scene
	var error = get_tree().change_scene_to_file(target_scene)
	if error != OK:
		push_error("Error changing scene to: " + target_scene)
	
	# Play fade out animation
	animation_player.play("fade_from_black")
	
	# Wait for animation to finish
	await animation_player.animation_finished
	
	# Hide overlay
	black_rect.visible = false
	
	# Emit completion signal
	transition_completed.emit()