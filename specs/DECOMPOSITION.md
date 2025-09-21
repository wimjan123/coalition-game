# COALITION UI Micro-Features Decomposition

**Created**: 2025-09-21
**Status**: Active Development Plan
**Source**: Decomposition of comprehensive COALITION UI specification into independently shippable micro-features

## Overview

This document breaks down the COALITION UI into **22 focused micro-features** (3-10 days each) enabling parallel development streams, clear ownership boundaries, and rapid iteration cycles.

## Desktop Foundation Domain (4 Features)

### DF-001: Window Management Core
**Branch**: `feat/window-manager`
**Goal**: Basic draggable, resizable window system for political desktop apps.

**Scope**:
- Window drag, resize, minimize, maximize functionality
- Z-order management for overlapping windows
- Window focus and activation states
- Basic window chrome (title bar, close button)
- Window snapping to screen edges

**Out of Scope**:
- App-specific content (just window containers)
- Complex layouts or tiling
- Window animations beyond basic fade

**Acceptance**:
- User can drag windows around desktop
- Windows resize with corner/edge handles
- Multiple windows maintain proper layering
- Keyboard shortcuts: Cmd+W close, Cmd+M minimize
- Windows stay within screen boundaries
- Accessibility: Focus management works with screen readers

**Dependencies**: None (foundation)
**Interfaces**:
- `WindowCreated(window_id, app_type)`
- `WindowClosed(window_id)`
- `WindowFocused(window_id)`

**Estimate**: 5 days
**Priority**: P0
**Traceability**: from FEATURES.md › Desktop OS Simulation

**Risks**:
- Window positioning edge cases on different screen sizes
- Performance with many windows open

### DF-002: Political Taskbar & Dock
**Branch**: `feat/political-taskbar`
**Goal**: Satirical taskbar with political app launchers and system indicators.

**Scope**:
- Bottom taskbar with Dutch political themed styling
- App launcher icons with satirical political imagery
- Active window indicators in taskbar
- Political time display (Week X of Electoral Cycle)
- System status indicators (coalition stability, crisis alerts)

**Out of Scope**:
- Actual app implementations (just launchers)
- Complex animations or transitions
- System settings or configuration

**Acceptance**:
- Taskbar displays at bottom of screen with political theme
- Clicking app icons triggers window creation events
- Active windows show indicators in taskbar
- Political time updates weekly and displays current phase
- Keyboard shortcut: Cmd+Space opens app launcher
- High contrast mode available for accessibility

**Dependencies**: DF-001 (Window Management)
**Interfaces**:
- `AppLaunchRequested(app_type)`
- `PoliticalTimeChanged(week, phase)`

**Estimate**: 4 days
**Priority**: P0
**Traceability**: from FEATURES.md › Desktop OS Simulation

**Risks**:
- Satirical imagery may need cultural review
- Icon sizing for different screen densities

### DF-003: Crisis Notification System
**Branch**: `feat/crisis-notifications`
**Goal**: Breaking news and crisis alert system with political urgency theming.

**Scope**:
- Popup notifications for breaking political events
- Crisis urgency levels (Normal, Important, Urgent, Crisis)
- Notification queuing and dismissal
- Sound alerts with Dutch political audio cues
- Integration with political event system

**Out of Scope**:
- Notification content generation (just display)
- Email or external notifications
- Complex notification scheduling

**Acceptance**:
- Notifications appear as overlays with appropriate urgency styling
- Users can dismiss notifications or act on them
- Sound alerts respect system volume settings
- Notifications queue properly during busy periods
- Keyboard navigation: Tab to actions, Esc to dismiss
- Screen reader announces notification content

**Dependencies**: DF-002 (Taskbar for indicators)
**Interfaces**:
- `CrisisNotification(level, title, message, actions)`
- `NotificationDismissed(notification_id)`

**Estimate**: 3 days
**Priority**: P0
**Traceability**: from FEATURES.md › Desktop OS Simulation

**Risks**:
- Alert fatigue if too many notifications
- Audio cues may be distracting

### DF-004: Game State Persistence
**Branch**: `feat/save-load-system`
**Goal**: Save and restore complete political game state across sessions.

**Scope**:
- Save current political situation, relationships, events
- Multiple save slots for different scenarios
- Auto-save at key political moments
- Session recovery after unexpected exit
- Save file integrity validation

**Out of Scope**:
- Cloud save synchronization
- Save file sharing between users
- Save file encryption

**Acceptance**:
- Manual save preserves all game state accurately
- Load restores exact political situation and UI state
- Auto-save triggers weekly and before major decisions
- Multiple save slots allow scenario exploration
- Save corruption is detected and reported
- Keyboard shortcuts: Cmd+S save, Cmd+O load

**Dependencies**: None (core system)
**Interfaces**:
- `GameStateSaved(slot_id, timestamp)`
- `GameStateLoaded(slot_id)`

**Estimate**: 6 days
**Priority**: P0
**Traceability**: from FEATURES.md › Save & Continue System

**Risks**:
- Save file format changes breaking compatibility
- Large save files with complex political state

## Social Media Domain (5 Features)

### SM-001: Social Timeline Interface
**Branch**: `feat/social-timeline`
**Goal**: Twitter-like scrollable timeline displaying political posts and responses.

**Scope**:
- Infinite scroll timeline with post cards
- Post display: avatar, handle, party affiliation, timestamp
- Like, share, reply interaction buttons
- Timeline filtering (All, Mentions, Trends)
- Keyboard navigation (J/K scroll, standard shortcuts)

**Out of Scope**:
- Post content generation (uses mock data)
- Real social media integration
- Complex timeline algorithms

**Acceptance**:
- Timeline scrolls smoothly with J/K keyboard navigation
- Post cards display all required information clearly
- Clicking interaction buttons triggers appropriate events
- Timeline filters work correctly
- Accessibility: Screen readers can navigate posts
- High contrast mode for better visibility

**Dependencies**: DF-001 (Window Management)
**Interfaces**:
- `PostDisplayed(post_id, author, content)`
- `PostInteraction(post_id, action_type)`

**Estimate**: 4 days
**Priority**: P1
**Traceability**: from SOCIAL_AND_MEDIA.md › AI-Driven Social Media Simulation

**Risks**:
- Performance with large numbers of posts
- Timeline scrolling smoothness

### SM-002: Post Compose Interface
**Branch**: `feat/post-composer`
**Goal**: Political post composition with quick response templates.

**Scope**:
- Multi-line text input with character counting
- Quick response templates: Defend, Reframe, Attack, Clarify
- Political tone preview before posting
- Draft saving for unfinished posts
- Post scheduling for political timing

**Out of Scope**:
- Rich text formatting or media upload
- Advanced scheduling features
- Post analytics

**Acceptance**:
- Text input supports multi-line posts with character limit
- Template buttons populate composer with appropriate political language
- Tone preview shows likely political impact
- Keyboard shortcut: N for new post, Cmd+Enter to send
- Draft auto-saves every 30 seconds
- Accessibility: Screen reader compatible, focus management

**Dependencies**: None (standalone UI)
**Interfaces**:
- `PostCreated(content, tone, timing)`
- `DraftSaved(draft_id, content)`

**Estimate**: 3 days
**Priority**: P1
**Traceability**: from SOCIAL_AND_MEDIA.md › AI-Driven Social Media Simulation

**Risks**:
- Template language may need political expert review
- Character counting edge cases

### SM-003: AI Persona Response Engine
**Branch**: `feat/ai-personas`
**Goal**: Generate authentic political responses from Dutch AI personas.

**Scope**:
- 9 distinct persona types with authentic Dutch political voices
- Response generation based on post content and political context
- Relationship tracking affecting response tone
- Response timing variation (immediate to delayed)
- Rule-based fallback when AI unavailable

**Out of Scope**:
- Real-time LLM integration (offline-first)
- Learning from player behavior
- Custom persona creation

**Acceptance**:
- Each persona generates responses consistent with their political archetype
- Response tone varies based on relationship with player
- Responses appear within 2-5 seconds of player posts
- Rule-based responses work when offline
- Personas maintain voice consistency across interactions
- Cultural accuracy validated by Dutch political experts

**Dependencies**: None (core AI system)
**Interfaces**:
- `PersonaResponse(persona_id, post_id, response_content, tone)`
- `RelationshipUpdated(persona_id, change_amount)`

**Estimate**: 8 days
**Priority**: P1
**Traceability**: from SOCIAL_AND_MEDIA.md › AI Persona Categories

**Risks**:
- AI response quality and consistency
- Cultural authenticity of Dutch political voices

### SM-004: Storm Detection & Escalation
**Branch**: `feat/storm-mechanics`
**Goal**: Political social media storm detection and escalation system.

**Scope**:
- Storm level tracking: Calm → Brewing → Storm
- Topic clustering for storm identification
- Escalation triggers based on engagement and sentiment
- Storm impact calculation on polls and coalition stability
- Storm decay and resolution mechanics

**Out of Scope**:
- Crisis level storms (marked as Extension)
- Cross-platform storm tracking
- Historical storm analytics

**Acceptance**:
- System detects when posts generate unusual engagement
- Storm levels escalate realistically based on political content
- Storm impact affects relevant game systems appropriately
- Storms naturally decay without player intervention
- Storm status visible in UI with appropriate urgency
- Political experts validate storm escalation patterns

**Dependencies**: SM-001 (Timeline), SM-003 (AI Responses)
**Interfaces**:
- `StormDetected(topic_id, level, intensity)`
- `StormEscalated(topic_id, old_level, new_level)`

**Estimate**: 6 days
**Priority**: P1
**Traceability**: from SOCIAL_AND_MEDIA.md › Social Storm Mechanics

**Risks**:
- Storm detection sensitivity tuning
- Balancing storm impact on gameplay

### SM-005: Impact Metrics Dashboard
**Branch**: `feat/impact-metrics`
**Goal**: Real-time display of political social media impact metrics.

**Scope**:
- Followers delta tracking with visual trends
- Momentum meter showing current political trajectory
- Legitimacy indicator based on establishment acceptance
- Metric history charts over political timeline
- Impact breakdown by demographic and region

**Out of Scope**:
- Complex statistical analysis
- Metric prediction or forecasting
- External metric validation

**Acceptance**:
- Metrics update in real-time as player posts and interacts
- Visual indicators clearly show positive/negative trends
- Historical charts help players understand long-term impact
- Metrics correlate with other game systems appropriately
- Color-blind friendly visualization with text alternatives
- Keyboard navigation through metric details

**Dependencies**: SM-003 (AI Responses), SM-004 (Storm Mechanics)
**Interfaces**:
- `MetricUpdated(metric_type, old_value, new_value)`
- `ImpactCalculated(post_id, follower_delta, momentum_change)`

**Estimate**: 4 days
**Priority**: P1
**Traceability**: from SOCIAL_AND_MEDIA.md › AI-Driven Social Media Simulation

**Risks**:
- Metric calculation complexity
- UI clarity for multiple simultaneous metrics

## Political Data Domain (3 Features)

### PD-001: Party & Coalition Models
**Branch**: `feat/political-models`
**Goal**: Core data structures for Dutch political parties and coalition mathematics.

**Scope**:
- Party definitions with seats, ideology, red lines
- Coalition compatibility calculations
- 150-seat Tweede Kamer mathematics with D'Hondt system
- Portfolio ministry definitions and strategic values
- Relationship tracking between parties and player

**Out of Scope**:
- UI visualization (handled by other features)
- Historical party data beyond current election
- Dynamic party position changes

**Acceptance**:
- Party compatibility scores calculated accurately using ideological positions
- Coalition mathematics enforce 76+ seat majority requirement
- D'Hondt seat allocation matches real Dutch electoral system
- Red lines correctly prevent incompatible coalitions
- Portfolio values reflect authentic Dutch political priorities
- Political experts validate party positioning accuracy

**Dependencies**: None (core data)
**Interfaces**:
- `CoalitionViable(party_list, total_seats, compatibility_score)`
- `PortfolioValue(ministry, party_type, strategic_importance)`

**Estimate**: 5 days
**Priority**: P0
**Traceability**: from DUTCH_POLITICS.md › Coalition Formation Mechanics

**Risks**:
- Political positioning accuracy and bias
- Coalition mathematics complexity

### PD-002: Weekly Time Progression
**Branch**: `feat/time-progression`
**Goal**: Political calendar system with weekly turns and electoral cycles.

**Scope**:
- Week-based time progression through electoral cycles
- Phase transitions: Campaign → Formation → Governing → Crisis
- Event scheduling for debates, crises, Prinsjesdag
- Time-sensitive decision deadlines
- Political momentum tracking over time

**Out of Scope**:
- Real-time clock synchronization
- Complex event dependencies
- Historical timeline navigation

**Acceptance**:
- Time advances weekly with clear phase indicators
- Events trigger appropriately for current political phase
- Deadlines create proper pressure for player decisions
- Phase transitions feel natural and politically authentic
- Calendar displays upcoming political events clearly
- Momentum changes reflect realistic political timing

**Dependencies**: None (core system)
**Interfaces**:
- `WeekAdvanced(new_week, phase, scheduled_events)`
- `PhaseChanged(old_phase, new_phase, duration)`

**Estimate**: 4 days
**Priority**: P0
**Traceability**: from FEATURES.md › Time Progression & Campaign System

**Risks**:
- Event scheduling complexity
- Phase transition timing balance

### PD-003: Relationship Tracking System
**Branch**: `feat/relationship-tracking`
**Goal**: Dynamic political relationship management across all interactions.

**Scope**:
- Relationship scores with all political actors
- Relationship change tracking from decisions and communications
- Coalition partner trust and confidence levels
- Media relationship affecting coverage tone
- Public relationship segments by demographic

**Out of Scope**:
- Complex relationship algorithms
- Relationship prediction or recommendations
- Historical relationship analysis

**Acceptance**:
- Relationships change appropriately based on player actions
- Relationship levels affect interactions across all game systems
- Coalition partner relationships impact stability calculations
- Media relationships influence coverage framing
- Relationship changes feel realistic and consequential
- UI clearly indicates relationship status and recent changes

**Dependencies**: PD-001 (Political Models)
**Interfaces**:
- `RelationshipChanged(actor_id, old_score, new_score, reason)`
- `TrustLevel(coalition_partner, trust_score, confidence_level)`

**Estimate**: 5 days
**Priority**: P0
**Traceability**: from multiple sources across all apps

**Risks**:
- Relationship calculation balance
- Performance with many tracked relationships

## Messages Domain (2 Features)

### MSG-001: Political Contact System
**Branch**: `feat/political-contacts`
**Goal**: Contact list and presence system for political communications.

**Scope**:
- Hierarchical contact organization: Coalition, Opposition, Media, Interest Groups
- Contact status indicators: Available, Busy, In Crisis, Unreachable
- Relationship hints showing coalition compatibility and recent interactions
- Contact search and filtering by party, role, relationship level
- Notification integration for urgent political communications

**Out of Scope**:
- Complex contact synchronization
- Contact creation by player
- Advanced contact analytics

**Acceptance**:
- Contacts organized logically by political role and relationship
- Status indicators help player understand availability for communications
- Search finds contacts quickly by name, party, or role
- Relationship hints provide useful political context
- Keyboard navigation through contact list
- Accessibility: Screen reader support for all contact information

**Dependencies**: PD-003 (Relationship Tracking)
**Interfaces**:
- `ContactSelected(contact_id, availability_status)`
- `ContactStatusChanged(contact_id, new_status, reason)`

**Estimate**: 4 days
**Priority**: P1
**Traceability**: from FEATURES.md › Messages

**Risks**:
- Contact organization complexity
- Status update timing and accuracy

### MSG-002: Political Messaging Interface
**Branch**: `feat/political-messaging`
**Goal**: Threaded messaging system with political communication styles.

**Scope**:
- Threaded conversation display with message history
- Reply style selector: Formal, Pragmatic, Snarky + free text
- Message tone indicators and relationship impact preview
- Crisis communication workflows with urgent response options
- Message drafting and scheduling for political timing

**Out of Scope**:
- Rich text or media messaging
- Group conversations or broadcast messages
- Advanced message analytics

**Acceptance**:
- Conversation threads display clearly with proper chronological order
- Reply styles generate appropriate political language for context
- Tone indicators help player understand communication impact
- Crisis messages clearly indicate urgency and consequences
- Keyboard shortcuts: R for reply, N for new message
- Accessibility: Messages readable by screen readers with proper labeling

**Dependencies**: MSG-001 (Contact System), PD-003 (Relationship Tracking)
**Interfaces**:
- `MessageSent(contact_id, content, style, relationship_impact)`
- `MessageReceived(sender_id, content, urgency_level)`

**Estimate**: 5 days
**Priority**: P1
**Traceability**: from FEATURES.md › Messages

**Risks**:
- Message style authenticity
- Threading complexity with many messages

## Coalition Builder Domain (3 Features)

### CB-001: Seat Visualization & Mathematics
**Branch**: `feat/seat-visualization`
**Goal**: Interactive 150-seat Tweede Kamer with coalition mathematics.

**Scope**:
- Visual seat layout representing 150 Tweede Kamer seats
- Party representation by seat count and proportional coloring
- Drag-and-drop coalition building with live seat counting
- 76+ seat majority requirement enforcement
- Visual coalition viability indicators

**Out of Scope**:
- Individual politician representation
- Historical seat changes
- Predictive seat modeling

**Acceptance**:
- Seat visualization accurately represents 150-seat proportional system
- Dragging parties into coalition updates total seat count immediately
- Visual indicators clearly show when 76+ majority achieved
- Coalition becomes invalid if seats drop below majority
- Color coding helps distinguish parties and coalition status
- Keyboard alternatives to drag-and-drop for accessibility

**Dependencies**: PD-001 (Political Models)
**Interfaces**:
- `CoalitionUpdated(party_list, total_seats, is_viable)`
- `SeatCountChanged(coalition_seats, opposition_seats)`

**Estimate**: 5 days
**Priority**: P1
**Traceability**: from DUTCH_POLITICS.md › Tweede Kamer

**Risks**:
- Visual clarity with many small parties
- Drag-and-drop interaction complexity

### CB-002: Portfolio Trading System
**Branch**: `feat/portfolio-trading`
**Goal**: Ministry allocation through strategic portfolio trading.

**Scope**:
- Ministry cards with strategic importance indicators
- Drag-and-drop allocation to coalition parties
- Portfolio value calculation based on party priorities
- Trading proposals and negotiation workflows
- Real-time coalition stability impact from allocations

**Out of Scope**:
- Complex multi-party negotiations
- Historical portfolio data
- Portfolio performance tracking

**Acceptance**:
- Ministry cards clearly show strategic value for different party types
- Portfolio allocation updates coalition stability appropriately
- Trading system reflects authentic Dutch political priorities
- Allocation conflicts (multiple parties wanting same ministry) handled clearly
- Keyboard navigation through portfolio options
- Visual design reflects ministerial importance and party preferences

**Dependencies**: PD-001 (Political Models), CB-001 (Seat Visualization)
**Interfaces**:
- `PortfolioAllocated(ministry, party, strategic_value)`
- `TradingProposal(offering_party, receiving_party, ministries)`

**Estimate**: 6 days
**Priority**: P1
**Traceability**: from DUTCH_POLITICS.md › Portfolio Trading System

**Risks**:
- Portfolio value balance and authenticity
- Trading interface complexity

### CB-003: Coalition Stability Tracking
**Branch**: `feat/coalition-stability`
**Goal**: Real-time coalition stability meter with breakdown analysis.

**Scope**:
- Overall coalition stability percentage with visual indicator
- Stability component breakdown by policy area and relationship
- Trend tracking showing stability changes over time
- Warning system for approaching critical thresholds
- What-if analysis for potential coalition changes

**Out of Scope**:
- Complex predictive modeling
- Stability optimization recommendations
- Historical comparison across governments

**Acceptance**:
- Stability meter updates immediately when coalition or relationships change
- Component breakdown helps player understand stability factors
- Warning indicators appear when stability drops to dangerous levels
- What-if scenarios accurately predict stability impact
- Visual design clearly communicates stability urgency
- Accessibility: Numerical stability values alongside visual indicators

**Dependencies**: PD-001 (Political Models), PD-003 (Relationship Tracking)
**Interfaces**:
- `StabilityUpdated(old_percentage, new_percentage, factors)`
- `StabilityWarning(current_level, threshold, risk_factors)`

**Estimate**: 4 days
**Priority**: P1
**Traceability**: from DUTCH_POLITICS.md › Coalition Stability Factors

**Risks**:
- Stability calculation accuracy and balance
- Warning threshold tuning

## News & Media Domain (2 Features)

### NM-001: News Event Clustering
**Branch**: `feat/news-clustering`
**Goal**: Aggregated news coverage with multiple outlet perspectives.

**Scope**:
- Event clustering from multiple Dutch media sources
- Story development timeline showing coverage evolution
- Cross-reference tracking from social media posts to news coverage
- Event importance scoring affecting prominence
- Media outlet bias representation in story selection

**Out of Scope**:
- Real-time news integration
- Complex natural language processing
- User-generated news content

**Acceptance**:
- Related stories cluster appropriately under major events
- Story timelines show realistic development patterns
- Social media influence on news coverage visible and accurate
- Media outlet bias affects story prominence appropriately
- Event importance reflects authentic Dutch political priorities
- Navigation between related stories works smoothly

**Dependencies**: SM-004 (Storm Mechanics) for social media cross-references
**Interfaces**:
- `NewsEventCreated(event_id, sources, importance_score)`
- `StoryClustered(story_id, event_id, outlet, timestamp)`

**Estimate**: 5 days
**Priority**: P1
**Traceability**: from FEATURES.md › News Feed

**Risks**:
- Story clustering algorithm accuracy
- Media bias representation authenticity

### NM-002: Frame Perspective System
**Branch**: `feat-news-framing`
**Goal**: Four-frame news perspective switcher with authentic Dutch media bias.

**Scope**:
- Four frame types: Sympathetic, Critical, Sensational, Dismissive
- Frame switcher allowing comparison of same story across perspectives
- Authentic Dutch media outlet voice (NOS, RTL, Volkskrant, Telegraaf)
- Frame impact calculation on public opinion and coalition stability
- "Why this matters" explanatory content for political context

**Out of Scope**:
- Dynamic frame generation
- Custom frame creation
- Advanced media analysis

**Acceptance**:
- Frame switcher clearly shows different perspectives on same event
- Each frame authentically represents respective Dutch media outlet
- Frame impact on public opinion feels realistic and consequential
- Explanatory content helps players understand political significance
- Visual design distinguishes frame types clearly
- Cultural accuracy validated by Dutch media experts

**Dependencies**: NM-001 (News Clustering) for story content
**Interfaces**:
- `FramePerspective(story_id, frame_type, outlet, impact_prediction)`
- `FrameImpact(frame_type, approval_change, stability_change)`

**Estimate**: 6 days
**Priority**: P1
**Traceability**: from SOCIAL_AND_MEDIA.md › Media Framing System

**Risks**:
- Frame authenticity and cultural accuracy
- Impact calculation balance

## Polls & Calendar Domain (2 Features)

### PC-001: Political Polling Dashboard
**Branch**: `feat-polling-dashboard`
**Goal**: Political polling visualization with demographic breakdowns and trends.

**Scope**:
- Approval rating trends with historical timeline
- Seat projection models with confidence intervals
- Demographic breakdown by age, region, education, income
- Polling impact from player actions and events
- Momentum tracking affecting future polling

**Out of Scope**:
- Complex statistical modeling
- Polling methodology simulation
- Advanced demographic segmentation

**Acceptance**:
- Polling charts update appropriately based on player actions
- Demographic breakdowns reflect authentic Dutch voting patterns
- Confidence intervals help players understand polling uncertainty
- Momentum indicators predict realistic polling trajectory
- Visual design clearly communicates polling trends
- Accessibility: Data tables available alongside visual charts

**Dependencies**: PD-002 (Time Progression), SM-004 (Storm Impact)
**Interfaces**:
- `PollingUpdate(approval_rating, seat_projection, demographics)`
- `MomentumShift(direction, magnitude, contributing_factors)`

**Estimate**: 5 days
**Priority**: P1
**Traceability**: from FEATURES.md › Polls & Data

**Risks**:
- Polling calculation realism
- Demographic data accuracy

### PC-002: Political Calendar System
**Branch**: `feat-political-calendar`
**Goal**: Weekly political schedule with events, debates, and crisis management.

**Scope**:
- Weekly calendar view with political event scheduling
- Event types: Debates, Prinsjesdag, Crisis Response, Coalition Meetings
- Crisis countdown timers for urgent political decisions
- Event preparation interface with choices affecting outcomes
- Calendar integration with time progression system

**Out of Scope**:
- Complex scheduling algorithms
- External calendar synchronization
- Event performance analytics

**Acceptance**:
- Calendar clearly displays upcoming political events by week
- Event types distinguished with appropriate visual styling
- Crisis timers create appropriate urgency for player decisions
- Event preparation choices affect political outcomes realistically
- Calendar synchronizes with weekly time progression
- Keyboard navigation through calendar dates and events

**Dependencies**: PD-002 (Time Progression) for event scheduling
**Interfaces**:
- `EventScheduled(event_type, week, importance, preparation_time)`
- `CrisisDeadline(event_id, hours_remaining, consequences)`

**Estimate**: 4 days
**Priority**: P1
**Traceability**: from FEATURES.md › Calendar

**Risks**:
- Event scheduling complexity
- Crisis timing balance

## Debate Overlay Domain (2 Features - Extension)

### DO-001: 3D Debate Environment **[Extension]**
**Branch**: `feat-debate-environment`
**Goal**: Immersive 3D debate stage with Dutch parliamentary or TV studio settings.

**Scope**:
- 3D Tweede Kamer chamber environment with authentic layout
- Smooth transition from desktop to debate overlay
- Dynamic lighting and atmosphere responding to debate tension
- Audience reaction visualization through movement and ambient sound
- Camera angle selection affecting player perspective

**Out of Scope**:
- Photo-realistic rendering
- Complex 3D character animation
- VR or AR support

**Acceptance**:
- 3D environment feels authentically Dutch political
- Transition to/from desktop smooth and intuitive
- Lighting and atmosphere enhance debate tension appropriately
- Audience reactions visible and contribute to immersion
- Performance maintains 60+ FPS on target hardware
- Accessibility: Alternative 2D mode available

**Dependencies**: DF-001 (Window Management) for overlay integration
**Interfaces**:
- `DebateEnvironmentLoaded(setting_type, participant_count)`
- `AtmosphereChanged(tension_level, audience_sentiment)`

**Estimate**: 8 days
**Priority**: P2 (Extension)
**Traceability**: from FEATURES.md › 3D Debate Stage Events

**Risks**:
- 3D performance on target hardware
- Environmental authenticity accuracy

### DO-002: Live Debate Reaction System **[Extension]**
**Branch**: `feat-live-reactions`
**Goal**: Real-time debate reaction tracking with political consequences.

**Scope**:
- Live reaction ticker showing audience sentiment
- Micro-poll lines tracking opinion shifts during debate
- Clip risk meter warning of viral moment potential
- Coalition partner reaction indicators during debate
- After-action summary seeding news and social media coverage

**Out of Scope**:
- Real audience integration
- Complex sentiment analysis
- Advanced predictive modeling

**Acceptance**:
- Reaction systems update smoothly during debate performance
- Micro-polls reflect realistic opinion movement patterns
- Clip risk accurately predicts viral political moments
- Coalition reactions affect relationship and stability appropriately
- After-action summaries feel consequential for ongoing narrative
- Visual design maintains clarity during information-dense moments

**Dependencies**: DO-001 (Debate Environment), SM-004 (Storm Mechanics)
**Interfaces**:
- `DebateReaction(moment_id, sentiment_shift, viral_potential)`
- `DebateConsequences(approval_change, relationship_impacts, story_seeds)`

**Estimate**: 6 days
**Priority**: P2 (Extension)
**Traceability**: from FEATURES.md › 3D Debate Stage Events

**Risks**:
- Reaction timing and realism
- Information overload during debates

## Integration Domain (1 Feature)

### INT-001: Cross-System Event Bus
**Branch**: `feat-event-integration`
**Goal**: Event coordination system enabling communication between all micro-features.

**Scope**:
- Central event bus for inter-feature communication
- Event validation and transformation
- Event logging for debugging and analysis
- Performance monitoring for event processing
- Event replay capability for testing

**Out of Scope**:
- Complex event processing or AI
- External system integration
- Real-time synchronization

**Acceptance**:
- All micro-features communicate through event bus successfully
- Events processed without noticeable performance impact
- Event validation prevents system corruption from invalid events
- Logging helps developers debug integration issues
- Event replay enables comprehensive testing scenarios
- System remains responsive under high event volume

**Dependencies**: All other features (integration layer)
**Interfaces**:
- `EventPublished(event_type, source_feature, payload)`
- `EventProcessed(event_id, target_features, processing_time)`

**Estimate**: 4 days
**Priority**: P0
**Traceability**: Integration requirement across all features

**Risks**:
- Event bus performance bottlenecks
- Complex event dependency cycles

## Summary Statistics

**Total Features**: 22 micro-features
**Estimated Effort**: 112 days total
**Parallel Streams**: 4-5 streams possible after foundation
**P0 Features**: 6 (foundation layer)
**P1 Features**: 14 (core functionality)
**P2 Features**: 2 (extensions)

**Domain Distribution**:
- Desktop Foundation: 4 features (18 days)
- Social Media: 5 features (25 days)
- Political Data: 3 features (14 days)
- Messages: 2 features (9 days)
- Coalition Builder: 3 features (15 days)
- News & Media: 2 features (11 days)
- Polls & Calendar: 2 features (9 days)
- Debate Overlay: 2 features (14 days) **[Extension]**
- Integration: 1 feature (4 days)

**Development Approach**: Foundation → Core Features (Parallel) → Extensions → Integration