# CB-001: Seat Visualization & Mathematics

**Branch**: `feat/seat-visualization`
**Domain**: Coalition Builder
**Estimate**: 5 days
**Priority**: P1

## Goal
Interactive 150-seat Tweede Kamer with coalition mathematics.

## Scope
- Visual seat layout representing 150 Tweede Kamer seats
- Party representation by seat count and proportional coloring
- Drag-and-drop coalition building with live seat counting
- 76+ seat majority requirement enforcement
- Visual coalition viability indicators

## Out of Scope
- Individual politician representation
- Historical seat changes
- Predictive seat modeling

## Acceptance Criteria
- Seat visualization accurately represents 150-seat proportional system
- Dragging parties into coalition updates total seat count immediately
- Visual indicators clearly show when 76+ majority achieved
- Coalition becomes invalid if seats drop below majority
- Color coding helps distinguish parties and coalition status
- Keyboard alternatives to drag-and-drop for accessibility

## Dependencies
- PD-001 (Political Models)

## Interfaces
**Events Published:**
- `CoalitionUpdated(party_list, total_seats, is_viable)`
- `SeatCountChanged(coalition_seats, opposition_seats)`

**Events Consumed:**
- `PartyData(party_id, seats, ideology)` from PD-001

## Traceability
from DUTCH_POLITICS.md › Tweede Kamer

## Risks & Mitigations
- **Risk**: Visual clarity with many small parties
  - **Mitigation**: Smart grouping for parties <3 seats, zoom functionality
- **Risk**: Drag-and-drop interaction complexity
  - **Mitigation**: Implement keyboard alternatives, clear visual feedback