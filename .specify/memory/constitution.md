<!--
Sync Impact Report:
Version change: New constitution v1.0.0 (initial ratification)
Principles established:
- I. Test-Driven Development (NON-NEGOTIABLE)
- II. Code Quality Standards
- III. User Experience Consistency
- IV. Performance Requirements
- V. Game Immersion Priority

New sections:
- Code Quality Standards: Linting, formatting, naming conventions
- Performance Standards: Specific targets for game engine optimization
- User Experience Standards: Desktop OS simulation consistency

Templates requiring updates:
✅ No updates needed - templates already reference constitution compliance
✅ plan-template.md: Constitution Check section aligned
✅ spec-template.md: Quality requirements compatible
✅ tasks-template.md: TDD enforcement compatible

Follow-up TODOs: None
-->

# COALITION Constitution

## Core Principles

### I. Test-Driven Development (NON-NEGOTIABLE)
TDD cycle strictly enforced: Write tests → Get approval → Watch tests fail → Implement to pass → Refactor. All features MUST have tests written before implementation begins. Contract tests required for all APIs, integration tests for all cross-module communication, and unit tests for all business logic. No code merges without full test coverage and all tests passing.

*Rationale: Political simulation requires reliable, predictable behavior. Game mechanics must work consistently across all scenarios, and satirical content delivery depends on precise timing and messaging that can only be ensured through comprehensive testing.*

### II. Code Quality Standards
All code must pass automated linting (ESLint/GDScript linter), formatting (Prettier/gdformat), and static analysis tools. Naming conventions: snake_case for GDScript, camelCase for JavaScript/TypeScript. Functions must be single-purpose with clear, descriptive names. Maximum function length: 30 lines. All public APIs must have comprehensive documentation. Code reviews required for all changes.

*Rationale: Game development involves complex state management and AI systems. Poor code quality leads to bugs that break immersion and satirical timing. Consistent style enables team collaboration and reduces cognitive load when debugging complex political scenarios.*

### III. User Experience Consistency
Desktop OS simulation must maintain authentic feel throughout all interactions. UI animations and transitions must be smooth (60fps target). All political apps must follow consistent design patterns established in the UI system. Keyboard shortcuts must work consistently across all apps. Loading states and progress indicators required for all operations >500ms. Error messages must be contextual and helpful.

*Rationale: The game's core appeal depends on believable desktop OS simulation. Inconsistent UX breaks the illusion and reduces satirical impact. Political tension is built through seamless interaction flow that keeps players engaged in the fiction.*

### IV. Performance Requirements
Game must maintain 60fps during normal gameplay on target hardware (Intel i5 equivalent, 8GB RAM). Scene transitions must complete within 1 second. AI response generation must complete within 2 seconds. Memory usage must not exceed 2GB during peak gameplay. All assets must be optimized for size without quality loss. Performance regression testing required for all releases.

*Rationale: Political simulations involve complex AI systems and real-time social media feeds. Performance issues break immersion and reduce the impact of time-sensitive political events. Smooth performance maintains the illusion of a real political environment.*

### V. Game Immersion Priority
Satirical content must serve gameplay first, humor second. All political references must be researched for accuracy before satirical adaptation. UI metaphors must stay consistent with Dutch political culture. Breaking the fourth wall is prohibited except in designated meta-commentary areas. Real-world political events should inspire content, not dictate it. Player agency must be preserved in all political scenarios.

*Rationale: Effective political satire requires deep immersion in the simulated world. Players must believe in the political environment before they can appreciate the humor. Surface-level jokes break immersion and reduce the game's educational and satirical value.*

## Code Quality Standards

**Automated Enforcement**: ESLint for JavaScript/TypeScript, GDScript static analyzer for game logic, automated formatting on commit.

**Documentation Requirements**: All public functions, classes, and modules must have docstrings. API endpoints require OpenAPI documentation. Game mechanics require design documentation in /docs/mechanics/.

**Review Process**: All code changes require peer review. Performance-impacting changes require approval from technical lead. UI changes require approval from UX lead.

## Performance Standards

**Godot Engine Optimization**: Scene instantiation <100ms, shader compilation cached, texture streaming optimized for memory constraints.

**AI Response Timing**: Social media responses within 2 seconds, coalition negotiation AI within 1 second, complex political scenario analysis within 5 seconds.

**Resource Management**: Automatic memory management for political event history, asset streaming for large political datasets, performance profiling integrated into CI/CD.

## User Experience Standards

**Desktop OS Consistency**: Window management follows OS conventions, keyboard shortcuts match platform standards, visual feedback for all user actions.

**Political Context Preservation**: UI state must persist across game sessions, political relationships visualized consistently, time progression clearly communicated.

**Accessibility**: Keyboard navigation for all features, screen reader compatibility for text content, colorblind-safe political party representations.

## Governance

**Constitution Authority**: This constitution supersedes all other development practices and coding standards.

**Amendment Process**: Amendments require technical lead approval, full team review, and migration plan for existing code. Breaking changes require MAJOR version increment.

**Compliance Review**: All pull requests must verify constitutional compliance. Code reviews must check adherence to principles. Performance regressions block merges until resolved.

**Complexity Justification**: Any violation of simplicity principles must be documented with specific technical rationale and alternative approaches considered.

**Version**: 1.0.0 | **Ratified**: 2025-01-20 | **Last Amended**: 2025-01-20