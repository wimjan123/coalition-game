# COALITION Code Style and Conventions

## Code Quality Standards (Constitutional Requirements)

### Naming Conventions
- **GDScript**: snake_case for variables, functions, and files
- **JavaScript/TypeScript**: camelCase for variables and functions
- **Functions**: Single-purpose with clear, descriptive names
- **Maximum Function Length**: 30 lines

### Code Quality Requirements
- All code MUST pass automated linting
- All code MUST pass automated formatting
- All code MUST pass static analysis tools
- Code reviews required for ALL changes

### Documentation Standards
- **All public APIs**: Comprehensive documentation required
- **Functions/Classes**: Docstrings mandatory for all public functions
- **API Endpoints**: OpenAPI documentation required
- **Game Mechanics**: Design documentation in /docs/mechanics/

### Linting and Formatting Tools
- **GDScript**: GDScript static analyzer + gdformat
- **JavaScript/TypeScript**: ESLint + Prettier
- **Automated formatting**: On commit (git hooks)

## Constitutional Principles

### Test-Driven Development (NON-NEGOTIABLE)
- TDD cycle: Write tests → Get approval → Watch fail → Implement → Refactor
- Contract tests required for all APIs
- Integration tests for cross-module communication  
- Unit tests for all business logic
- NO code merges without full test coverage

### Performance Standards
- 60fps during normal gameplay
- Scene transitions <1 second
- AI responses <2 seconds
- Memory usage <2GB peak
- Scene instantiation <100ms

### UX Consistency Requirements  
- Desktop OS simulation authenticity
- Consistent design patterns across political apps
- Keyboard shortcuts work consistently
- Loading states for operations >500ms
- Contextual, helpful error messages

### Game Immersion Priority
- Satirical content serves gameplay first, humor second
- Political references researched for accuracy
- UI metaphors consistent with Dutch political culture
- No fourth wall breaking except designated areas
- Player agency preserved in all scenarios

## Review Process
- **All Changes**: Peer review required
- **Performance Impact**: Technical lead approval  
- **UI Changes**: UX lead approval
- **Constitutional Compliance**: Verified in all PRs