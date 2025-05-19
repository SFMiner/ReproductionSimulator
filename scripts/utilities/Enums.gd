extends Node

# Enums.gd: Define global enumerations

# Reading Levels
enum ReadingLevel {
    LEVEL_1 = 1, # Ages 6-7: Simple words, picture-heavy, basic concepts
    LEVEL_2 = 2, # Ages 8-10: Intermediate vocabulary, more detailed
    LEVEL_3 = 3  # Ages 11+: Scientific terminology, comprehensive 
}

# Reproduction Types
enum ReproductionType {
    BINARY_FISSION,
    MITOSIS,
    SEXUAL_EXTERNAL,   # Amphibians - external fertilization
    SEXUAL_OVIPAROUS,  # Birds - internal fertilization, external development
    SEXUAL_VIVIPAROUS  # Mammals - internal fertilization and development
}

# Cell Types
enum CellType {
    PROKARYOTE,  # No nucleus (bacteria)
    EUKARYOTE,   # Has nucleus (animals, plants, fungi)
    GAMETE       # Sex cell (sperm, egg)
}

# Module Modes
enum ModuleMode {
    EXPLORE,  # Free exploration
    GUIDED,   # Step-by-step guided learning
    QUIZ      # Assessment mode
}

# Animation Types
enum AnimationType {
    LINEAR,
    EASE_IN,
    EASE_OUT,
    EASE_IN_OUT,
    BOUNCE,
    ELASTIC
}

# Question Types
enum QuestionType {
    MULTIPLE_CHOICE,
    ORDERING,
    MATCHING,
    DRAG_DROP,
    LABELING
}