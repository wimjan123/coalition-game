# COALITION Project Structure

## Current Directory Structure
```
political-game/
├── .git/                          # Git version control
├── .gitignore                     # Git ignore rules
├── .claude/                       # Claude Code configuration
│   ├── settings.local.json
│   └── commands/                  # Custom Claude commands
├── .specify/                      # Feature development framework  
│   ├── memory/
│   │   └── constitution.md        # Project constitution (v1.0.0)
│   ├── templates/                 # Development templates
│   │   ├── spec-template.md
│   │   ├── plan-template.md
│   │   ├── tasks-template.md
│   │   └── agent-file-template.md
│   └── scripts/bash/              # Development automation scripts
├── .serena/                       # Serena MCP project configuration
│   ├── project.yml
│   └── memories/                  # Project memory files
└── docs/                          # Project documentation
    ├── README.md                  # Main project overview
    ├── VISION.md                  # Game concept and philosophy  
    ├── FEATURES.md                # Feature breakdown
    ├── STACK_CHOICE.md            # Technology decisions
    ├── DUTCH_POLITICS.md          # Political system research
    ├── SOCIAL_AND_MEDIA.md       # AI systems design
    ├── ETHICS.md                  # Content guidelines
    └── IMPLEMENTATION_PLAN.md     # Development roadmap
```

## Future Project Structure (Implementation Phase)
```
political-game/
├── project.godot                  # Godot project configuration
├── src/                           # Source code
│   ├── main.gd                   # Main game entry point
│   ├── scenes/                   # Godot scenes (.tscn files)
│   │   ├── desktop/              # Desktop OS simulation
│   │   ├── apps/                 # Political apps (messaging, polls, etc.)
│   │   ├── debates/              # 3D debate stage scenes
│   │   └── ui/                   # Shared UI components
│   ├── scripts/                  # GDScript source files
│   │   ├── core/                 # Core game systems
│   │   ├── political/            # Political simulation logic
│   │   ├── ai/                   # AI integration layer
│   │   └── ui/                   # UI controllers and behaviors
│   └── assets/                   # Game assets
│       ├── textures/             # Images and textures
│       ├── audio/                # Sound effects and music
│       ├── fonts/                # Custom fonts
│       └── data/                 # Game data (parties, issues, etc.)
├── tests/                        # Test suite
│   ├── unit/                     # Unit tests
│   ├── integration/              # Integration tests
│   └── contract/                 # API contract tests
├── tools/                        # Development tools and scripts
│   ├── export_builds.gd          # Build automation
│   ├── generate_docs.gd          # Documentation generation
│   └── benchmark_ai.gd           # Performance testing
├── ai_integration/               # AI service integration (Node.js/TypeScript)
│   ├── package.json
│   ├── src/
│   │   ├── services/             # AI service abstractions
│   │   ├── personalities/        # Political personality definitions
│   │   └── api/                  # REST API for Godot communication
│   └── tests/                    # AI integration tests
└── builds/                       # Export builds (gitignored)
    ├── macos/
    ├── windows/
    └── linux/
```

## Development Workflow Directories

### Feature Development (.specify framework)
```
specs/                            # Feature specifications (created by /spec)
├── 001-desktop-interface/
│   ├── spec.md                   # Feature specification
│   ├── plan.md                   # Implementation plan  
│   ├── research.md               # Technical research
│   ├── data-model.md             # Data structures
│   ├── contracts/                # API contracts
│   └── tasks.md                  # Implementation tasks
└── 002-coalition-mechanics/
    └── ...
```

### Documentation Organization
- **docs/**: High-level project documentation and design decisions
- **src/docs/**: Code-level documentation and API references (future)
- **.specify/memory/**: Project constitution and governance
- **.serena/memories/**: Project context and development history

## Code Organization Principles
- **Modular Architecture**: Clear separation between game systems
- **Platform Abstraction**: Cross-platform compatibility maintained
- **Offline-First**: Core functionality works without internet
- **AI Abstraction**: AI services isolated for easy testing/mocking
- **Asset Management**: Organized by type and usage context