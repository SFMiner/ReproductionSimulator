# Reproduction Simulator Project Guide

This document provides key information about the Reproduction Simulator project for Claude sessions.

## Project Overview

The Reproduction Simulator is an educational Godot 4.4 game designed to teach students about different forms of reproduction through interactive simulations. The project covers:

- Binary Fission (single-celled organisms)
- Mitosis (asexual reproduction in multicellular organisms)
- Sexual Reproduction (amphibians, birds, mammals)

The target audience ranges from elementary to high school students, with adjustable reading levels.

## Project Structure

- **Main Scene**: `/scenes/main/Main.tscn` - The entry point that initializes core systems
- **Main Menu**: `/scenes/main/MainMenu.tscn` - The main interface with mode selection buttons
- **Module Scenes**: Located in `/scenes/modules/` with specific module types in subdirectories
- **Core Scripts**:
  - `/scripts/core/GameManager.gd` - Central controller for game state and scene management
  - `/scripts/core/DataManager.gd` - Handles data loading/saving
  - `/scripts/core/AudioManager.gd` - Manages all audio playback
  - `/scripts/core/ProgressTracker.gd` - Tracks learning progress
  - `/scripts/core/SceneTransition.gd` - Handles scene transitions
- **UI Scripts**: Located in `/scripts/ui/` including `MenuController.gd`
- **Biology Scripts**: Located in `/scripts/biology/` with simulation logic

## Scene Hierarchy

- **Main** (root)
  - **GameManager** - Controls game state
    - **DataManager** - Handles data
    - **AudioManager** - Handles audio
    - **ProgressTracker** - Tracks progress
  - **SceneTransition** - Handles scene transitions

## Key Components

1. **Reading Levels**: Three levels for different age groups (6-7, 8-10, 11+)
2. **Modes**:
   - **Explore Mode**: Free exploration of reproduction types
   - **Guided Learning**: Step-by-step tutorials
   - **Compare & Contrast**: Compare different reproduction methods
   - **Quiz Mode**: Test knowledge with interactive quizzes
3. **Settings**: Audio and accessibility options

## Common Tasks

### Updating Text Content
Text content is stored in `/data/content/text/` organized by reading level.

### Adding New Modules
1. Create a new scene in `/scenes/modules/`
2. Add controller script in `/scripts/modules/`
3. Update `GameManager.change_module()` to include the new module

### Testing and Debugging
When running the project, the starting point is `Main.tscn` which initializes all systems and then transitions to the Main Menu.

### Core Systems Reference

#### Path Resolution
- Access GameManager: `get_node_or_null("/root/Main/GameManager")`
- Access Audio/Data managers: `get_node_or_null("/root/Main/GameManager/AudioManager")`

#### Scene Navigation
```gdscript
# Change to a module
game_manager.change_module("binary_fission")  # or another module name
```

#### Playing Audio
```gdscript
# Play sound effect
audio_manager.play_sfx("button_click")

# Play background music
audio_manager.play_music("menu_music")

# Play narration for content
audio_manager.play_narration("content_id")
```

## Implementation Details

- The project uses Godot 4.4 features and syntax
- Audio buses: Master, Narration, SFX, Music
- Data is stored in JSON format for settings and progress
- Text content is stored in plain text files organized by reading level

## Scene Flow

1. Application starts at `Main.tscn`
2. Main transitions to `MainMenu.tscn`
3. User selects a mode and module
4. Application transitions to the specific module scene
5. Module runs its simulation
6. User can return to the main menu or proceed to other modules