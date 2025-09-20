# COALITION Suggested Commands

## Project Development Commands

### Project Management (.specify framework)
```bash
# Create new feature specification
/spec "feature description"

# Create implementation plan from spec  
/plan

# Generate tasks from plan
/tasks

# Implement feature following constitution
/implement

# Update project constitution
/constitution
```

### Version Control
```bash
# Standard git workflow
git status
git add .
git commit -m "feat: descriptive commit message"
git push origin feature-branch

# Branch management
git checkout -b feature/new-feature
git checkout main
git merge feature/new-feature
```

### Godot Development (when project setup is complete)
```bash
# Run Godot editor
godot project.godot

# Run game in debug mode
godot --debug project.godot

# Export for macOS
godot --headless --export-release "macOS" coalition.app

# Run tests
godot --headless --script tests/run_tests.gd
```

### Code Quality Commands (future implementation)
```bash
# GDScript linting and formatting
gdformat src/
gdlint src/

# JavaScript/TypeScript (for AI integration)
npm run lint
npm run format  
npm run test

# Static analysis
godot --check-only --script src/main.gd
```

### Documentation Management
```bash
# View project documentation
ls docs/
cat docs/README.md

# Update constitution
vim .specify/memory/constitution.md

# Generate API documentation (future)
godot --headless --script tools/generate_docs.gd
```

### System Utilities (Linux)
```bash
# File operations
ls -la
find . -name "*.gd" -type f
grep -r "search_term" src/

# Process management  
ps aux | grep godot
top
htop

# Disk usage
df -h
du -sh */
```

### AI Integration Testing (future)
```bash
# Test AI endpoints
curl -X POST "localhost:8080/api/ai/response" -d '{"message": "test"}'

# Monitor AI response times
godot --headless --script tools/benchmark_ai.gd
```

### Performance Profiling (future)
```bash
# Profile game performance
godot --debug-collisions --debug-navigation project.godot

# Memory profiling
godot --debug-memory project.godot

# FPS monitoring  
godot --debug project.godot --fps
```

## Current Project State
**Note**: Most development commands are not yet applicable as the project is in the planning phase. The .specify framework commands are immediately useful for feature development planning.