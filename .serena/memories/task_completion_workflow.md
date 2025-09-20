# COALITION Task Completion Workflow

## Constitutional Requirements for Task Completion

### Pre-Implementation Requirements
1. **Feature Specification**: Complete `/spec` command output with clear requirements
2. **Implementation Plan**: Complete `/plan` command with technical decisions  
3. **Task Breakdown**: Complete `/tasks` command with ordered, testable tasks
4. **Constitutional Review**: Verify compliance with all 5 core principles

### Test-Driven Development Workflow (NON-NEGOTIABLE)
1. **Write Tests First**: ALL tests must be written before implementation
2. **Get Approval**: Tests reviewed and approved before coding begins
3. **Watch Tests Fail**: Confirm tests fail as expected (red phase)
4. **Implement**: Write minimal code to make tests pass (green phase)  
5. **Refactor**: Improve code quality while keeping tests green

### Code Quality Gates
```bash
# All code must pass these checks before commit:
gdlint src/                    # GDScript linting
gdformat --check src/          # GDScript formatting  
eslint src/ai/                 # JavaScript linting (if applicable)
prettier --check src/ai/       # JavaScript formatting (if applicable)

# Static analysis
godot --check-only --script src/main.gd
```

### Performance Validation
- **FPS Testing**: Maintain 60fps during gameplay
- **Load Time Testing**: Scene transitions <1 second  
- **Memory Testing**: Peak usage <2GB
- **AI Response Testing**: <2 seconds for social media responses

### Documentation Requirements
```bash
# Update documentation after implementation:
# 1. API documentation (if new APIs added)
# 2. Game mechanics documentation in /docs/mechanics/
# 3. Update IMPLEMENTATION_PLAN.md with progress
# 4. Add docstrings to all new public functions
```

### Review Process
1. **Self-Review**: Developer reviews own code against constitution
2. **Peer Review**: Code review by team member
3. **Technical Lead Review**: For performance-impacting changes
4. **UX Lead Review**: For UI changes
5. **Constitutional Compliance**: Verify adherence to all principles

### Integration Testing
- **Contract Tests**: All API endpoints tested
- **Cross-Module Tests**: Integration between game systems
- **UI Consistency Tests**: Desktop simulation feel maintained
- **Game Flow Tests**: Complete user scenarios tested

### Pre-Commit Checklist
- [ ] All tests pass (100% coverage)
- [ ] Code passes linting and formatting
- [ ] Performance requirements met
- [ ] Documentation updated
- [ ] Constitutional compliance verified
- [ ] Peer review completed
- [ ] Integration tests pass

### Deployment Readiness
- [ ] macOS export successful  
- [ ] Game launches without errors
- [ ] Core gameplay loop functional
- [ ] AI integration working (if applicable)
- [ ] Performance targets met on target hardware

## Quality Standards
- **No TODO comments**: All implementations must be complete
- **No placeholder code**: All functions must be fully implemented  
- **No broken features**: Partial implementations not allowed
- **Political accuracy**: All political content researched and verified