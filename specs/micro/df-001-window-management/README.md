# DF-001: Window Management Core

**Branch**: `feat/window-manager`
**Domain**: Desktop Foundation
**Estimate**: 5 days
**Priority**: P0

## Goal
Basic draggable, resizable window system for political desktop apps.

## Scope
- Window drag, resize, minimize, maximize functionality
- Z-order management for overlapping windows
- Window focus and activation states
- Basic window chrome (title bar, close button)
- Window snapping to screen edges

## Out of Scope
- App-specific content (just window containers)
- Complex layouts or tiling
- Window animations beyond basic fade

## Acceptance Criteria
- User can drag windows around desktop
- Windows resize with corner/edge handles
- Multiple windows maintain proper layering
- Keyboard shortcuts: Cmd+W close, Cmd+M minimize
- Windows stay within screen boundaries
- Accessibility: Focus management works with screen readers

## Dependencies
None (foundation)

## Interfaces
**Events Published:**
- `WindowCreated(window_id, app_type)`
- `WindowClosed(window_id)`
- `WindowFocused(window_id)`

**Events Consumed:**
- None

## Traceability
from FEATURES.md › Desktop OS Simulation

## Risks & Mitigations
- **Risk**: Window positioning edge cases on different screen sizes
  - **Mitigation**: Test on multiple screen resolutions, implement bounds checking
- **Risk**: Performance with many windows open
  - **Mitigation**: Implement efficient z-order management, limit maximum windows