extends Node

# Constants.gd: Defines global constants for the application

# Version
const VERSION = "0.1.0"

# Module names
const MODULE_BINARY_FISSION = "binary_fission"
const MODULE_MITOSIS = "mitosis"
const MODULE_AMPHIBIAN = "amphibian"
const MODULE_BIRD = "bird"
const MODULE_HUMAN = "human"
const MODULE_COMPARISON = "comparison"
const MODULE_QUIZ = "quiz"

# Mode types
const MODE_EXPLORE = "explore"
const MODE_GUIDED = "guided"

# Reading levels
const READING_LEVEL_1 = 1 # Ages 6-7
const READING_LEVEL_2 = 2 # Ages 8-10
const READING_LEVEL_3 = 3 # Ages 11+

# Quiz question types
const QUESTION_MULTIPLE_CHOICE = "multiple_choice"
const QUESTION_ORDERING = "ordering"
const QUESTION_MATCHING = "matching"
const QUESTION_DRAG_DROP = "drag_drop"
const QUESTION_LABELING = "labeling"

# Reproduction process steps
const BINARY_FISSION_STEPS = [
    "cell_preparation",
    "dna_replication",
    "cell_elongation",
    "cell_division",
    "growth_phase"
]

const MITOSIS_STEPS = [
    "interphase",
    "prophase",
    "metaphase",
    "anaphase",
    "telophase",
    "cytokinesis"
]

const MEIOSIS_STEPS = [
    "interphase",
    "prophase_i",
    "metaphase_i",
    "anaphase_i",
    "telophase_i",
    "prophase_ii",
    "metaphase_ii",
    "anaphase_ii",
    "telophase_ii",
    "cytokinesis"
]

# Animation durations (in seconds)
const ANIMATION_DURATION_SLOW = 3.0
const ANIMATION_DURATION_NORMAL = 2.0
const ANIMATION_DURATION_FAST = 1.0

# File paths
const AUDIO_NARRATION_PATH = "res://assets/audio/narration/level_%d/%s.ogg"
const AUDIO_SFX_PATH = "res://assets/audio/sfx/%s.ogg"
const AUDIO_MUSIC_PATH = "res://assets/audio/music/%s.ogg"