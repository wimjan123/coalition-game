# COALITION System Interfaces

**Created**: 2025-09-21
**Status**: Interface Specification for Micro-Feature Integration
**Purpose**: Define event contracts, data schemas, and navigation patterns for seamless system integration

## Event Contracts

### Core System Events

#### Window Management Events
```typescript
// DF-001: Window Management Core
interface WindowCreated {
  window_id: string;
  app_type: 'messages' | 'coalition-builder' | 'social-feed' | 'news-feed' | 'polls' | 'calendar';
  position: { x: number, y: number };
  size: { width: number, height: number };
  timestamp: number;
}

interface WindowClosed {
  window_id: string;
  app_type: string;
  final_state?: any; // App-specific state for persistence
}

interface WindowFocused {
  window_id: string;
  app_type: string;
  previous_focus?: string;
}
```

#### Political Time Events
```typescript
// PD-002: Weekly Time Progression
interface WeekAdvanced {
  new_week: number;
  phase: 'campaign' | 'formation' | 'governing' | 'crisis';
  scheduled_events: ScheduledEvent[];
  political_momentum: number;
}

interface PhaseChanged {
  old_phase: string;
  new_phase: string;
  duration_weeks: number;
  trigger_reason: string;
}

interface ScheduledEvent {
  event_id: string;
  event_type: 'debate' | 'prinsjesdag' | 'crisis' | 'coalition-meeting';
  week: number;
  importance: 1 | 2 | 3 | 4 | 5;
  preparation_time_hours: number;
}
```

#### Notification System Events
```typescript
// DF-003: Crisis Notification System
interface CrisisNotification {
  notification_id: string;
  level: 'normal' | 'important' | 'urgent' | 'crisis';
  title: string;
  message: string;
  actions: NotificationAction[];
  auto_dismiss_ms?: number;
  political_context: {
    affected_parties: string[];
    stability_impact: number;
    media_attention_level: number;
  };
}

interface NotificationAction {
  action_id: string;
  label: string;
  style: 'primary' | 'secondary' | 'danger';
  keyboard_shortcut?: string;
  consequence_preview?: string;
}

interface NotificationDismissed {
  notification_id: string;
  action_taken?: string;
  dismiss_method: 'click' | 'keyboard' | 'timeout';
}
```

### Social Media Events

#### Timeline & Posting Events
```typescript
// SM-001: Social Timeline Interface
interface PostDisplayed {
  post_id: string;
  author: PersonaIdentity;
  content: string;
  timestamp: number;
  engagement_metrics: {
    likes: number;
    shares: number;
    replies: number;
    storm_contribution: number;
  };
}

interface PostInteraction {
  post_id: string;
  action_type: 'like' | 'share' | 'reply' | 'bookmark';
  user_id: 'player';
  relationship_impact?: number;
  political_consequences?: string[];
}

// SM-002: Post Compose Interface
interface PostCreated {
  post_id: string;
  content: string;
  tone: 'formal' | 'casual' | 'aggressive' | 'defensive';
  timing: 'immediate' | 'scheduled';
  templates_used: string[];
  character_count: number;
}
```

#### AI Persona Events
```typescript
// SM-003: AI Persona Response Engine
interface PersonaResponse {
  response_id: string;
  persona_id: string;
  responding_to_post: string;
  response_content: string;
  tone: PersonaTone;
  relationship_change: number;
  storm_escalation_factor: number;
  authenticity_score: number; // 0-1, for quality monitoring
}

interface RelationshipUpdated {
  persona_id: string;
  old_score: number;
  new_score: number;
  change_reason: string;
  political_implications: string[];
}

enum PersonaTone {
  SUPPORTIVE = 'supportive',
  CRITICAL = 'critical',
  NEUTRAL = 'neutral',
  HOSTILE = 'hostile',
  SYMPATHETIC = 'sympathetic'
}
```

#### Storm System Events
```typescript
// SM-004: Storm Detection & Escalation
interface StormDetected {
  storm_id: string;
  topic_id: string;
  level: 'calm' | 'brewing' | 'storm';
  intensity: number; // 0-100
  contributing_posts: string[];
  affected_demographics: string[];
  estimated_duration_hours: number;
}

interface StormEscalated {
  storm_id: string;
  topic_id: string;
  old_level: string;
  new_level: string;
  escalation_triggers: string[];
  political_impact_prediction: {
    approval_change: number;
    coalition_stability_impact: number;
    media_attention_multiplier: number;
  };
}

interface StormResolved {
  storm_id: string;
  final_level: string;
  duration_hours: number;
  total_political_impact: PoliticalImpact;
  lessons_learned: string[]; // For AI persona learning
}
```

### Political System Events

#### Coalition Events
```typescript
// CB-001: Seat Visualization & Mathematics
interface CoalitionUpdated {
  coalition_id: string;
  party_list: PartyAllocation[];
  total_seats: number;
  is_viable: boolean; // >= 76 seats
  compatibility_score: number; // 0-100
  formation_difficulty: 'easy' | 'moderate' | 'difficult' | 'impossible';
}

interface SeatCountChanged {
  coalition_seats: number;
  opposition_seats: number;
  uncommitted_seats: number;
  majority_achieved: boolean;
}

// CB-002: Portfolio Trading System
interface PortfolioAllocated {
  ministry: MinistryType;
  allocated_to_party: string;
  strategic_value: number;
  party_satisfaction: number;
  coalition_stability_impact: number;
}

interface TradingProposal {
  proposal_id: string;
  offering_party: string;
  receiving_party: string;
  ministries_offered: MinistryType[];
  ministries_requested: MinistryType[];
  proposal_value_balance: number;
}

// CB-003: Coalition Stability Tracking
interface StabilityUpdated {
  old_percentage: number;
  new_percentage: number;
  change_factors: StabilityFactor[];
  trend_direction: 'improving' | 'stable' | 'declining';
  crisis_risk_level: number;
}

interface StabilityWarning {
  current_level: number;
  threshold: 'concern' | 'danger' | 'critical';
  risk_factors: string[];
  recommended_actions: string[];
  time_to_crisis_estimate_days?: number;
}
```

#### Political Relationship Events
```typescript
// PD-003: Relationship Tracking System
interface RelationshipChanged {
  actor_id: string;
  actor_type: 'party-leader' | 'journalist' | 'interest-group' | 'public-segment';
  old_score: number;
  new_score: number;
  change_reason: string;
  political_consequences: string[];
  affects_coalition_stability: boolean;
}

interface TrustLevel {
  coalition_partner: string;
  trust_score: number; // 0-100
  confidence_level: number; // 0-100
  relationship_trajectory: 'improving' | 'stable' | 'declining';
  breaking_point_estimate?: number; // Trust level at which partner leaves
}
```

### Communication Events

#### Messaging System Events
```typescript
// MSG-001: Political Contact System
interface ContactSelected {
  contact_id: string;
  contact_type: 'party-leader' | 'journalist' | 'advisor' | 'interest-group';
  availability_status: 'available' | 'busy' | 'crisis' | 'unreachable';
  relationship_context: {
    current_score: number;
    recent_interactions: number;
    political_alignment: number;
  };
}

interface ContactStatusChanged {
  contact_id: string;
  new_status: string;
  reason: string;
  estimated_availability_return?: number; // minutes
}

// MSG-002: Political Messaging Interface
interface MessageSent {
  message_id: string;
  contact_id: string;
  content: string;
  style: 'formal' | 'pragmatic' | 'snarky' | 'custom';
  relationship_impact: number;
  political_consequences: string[];
  urgency_level: number;
}

interface MessageReceived {
  message_id: string;
  sender_id: string;
  content: string;
  urgency_level: 'routine' | 'important' | 'urgent' | 'crisis';
  requires_response: boolean;
  response_deadline?: number; // timestamp
}
```

### News & Media Events

#### News System Events
```typescript
// NM-001: News Event Clustering
interface NewsEventCreated {
  event_id: string;
  headline: string;
  sources: NewsSource[];
  importance_score: number; // 1-10
  political_actors_involved: string[];
  estimated_media_lifespan_hours: number;
}

interface StoryClustered {
  story_id: string;
  event_id: string;
  outlet: 'nos' | 'rtl' | 'volkskrant' | 'telegraaf';
  timestamp: number;
  social_media_influence_score: number;
}

// NM-002: Frame Perspective System
interface FramePerspective {
  story_id: string;
  frame_type: 'sympathetic' | 'critical' | 'sensational' | 'dismissive';
  outlet: string;
  impact_prediction: {
    approval_change: number;
    stability_change: number;
    public_attention_level: number;
  };
  editorial_voice_authenticity: number; // 0-1
}
```

### Polling & Calendar Events

#### Polling Events
```typescript
// PC-001: Political Polling Dashboard
interface PollingUpdate {
  poll_id: string;
  approval_rating: number;
  seat_projection: SeatProjection;
  demographics: DemographicBreakdown;
  confidence_interval: number;
  polling_date: number;
  margin_of_error: number;
}

interface MomentumShift {
  direction: 'positive' | 'negative' | 'neutral';
  magnitude: number; // 0-10
  contributing_factors: string[];
  demographic_segments_affected: string[];
  estimated_duration_weeks: number;
}

// PC-002: Political Calendar System
interface EventScheduled {
  event_id: string;
  event_type: 'debate' | 'prinsjesdag' | 'crisis-response' | 'coalition-meeting';
  week: number;
  importance: number; // 1-5
  preparation_time_hours: number;
  political_stakes: string[];
}

interface CrisisDeadline {
  event_id: string;
  hours_remaining: number;
  consequences: string[];
  available_responses: ResponseOption[];
  coalition_partner_expectations: string[];
}
```

## Data Contracts

### Core Political Entities

#### Party Data Structure
```typescript
interface PoliticalParty {
  party_id: string;
  name: string;
  abbreviation: string;
  seats: number;
  ideology: IdeologicalPosition;
  red_lines: string[]; // Non-negotiable positions
  portfolio_preferences: MinistryPreference[];
  coalition_history: CoalitionExperience[];
  electoral_base: DemographicProfile;
}

interface IdeologicalPosition {
  economic: number; // -10 (socialist) to +10 (liberal)
  social: number; // -10 (conservative) to +10 (progressive)
  european: number; // -10 (eurosceptic) to +10 (federalist)
  immigration: number; // -10 (restrictive) to +10 (open)
}

interface MinistryPreference {
  ministry: MinistryType;
  preference_score: number; // 1-10
  strategic_importance: number; // 1-10
  negotiation_flexibility: number; // 1-10
}
```

#### AI Persona Structure
```typescript
interface PersonaIdentity {
  persona_id: string;
  name: string;
  handle: string;
  persona_type: 'party-leader' | 'journalist' | 'interest-group' | 'public-segment';
  archetype: PersonaArchetype;
  political_alignment: IdeologicalPosition;
  communication_style: CommunicationStyle;
  relationship_with_player: number; // -100 to +100
}

enum PersonaArchetype {
  POPULIST = 'populist',
  TECHNOCRAT = 'technocrat',
  PROGRESSIVE = 'progressive',
  TRADITIONALIST = 'traditionalist',
  JOURNALIST_PUBLIC = 'journalist-public',
  JOURNALIST_COMMERCIAL = 'journalist-commercial',
  JOURNALIST_QUALITY = 'journalist-quality',
  JOURNALIST_TABLOID = 'journalist-tabloid',
  INTEREST_GROUP = 'interest-group'
}

interface CommunicationStyle {
  formality_level: number; // 1-10
  emotional_intensity: number; // 1-10
  use_of_data: number; // 1-10
  provocativeness: number; // 1-10
  response_speed: 'immediate' | 'quick' | 'considered' | 'delayed';
}
```

#### Coalition Data Structure
```typescript
interface Coalition {
  coalition_id: string;
  parties: PartyAllocation[];
  total_seats: number;
  formation_date?: number;
  stability_percentage: number;
  portfolio_allocation: PortfolioAllocation[];
  policy_agreements: PolicyAgreement[];
  crisis_events: CrisisEvent[];
}

interface PartyAllocation {
  party_id: string;
  seats: number;
  role: 'lead' | 'major' | 'minor' | 'supporting';
  commitment_level: number; // 1-10
}

interface PortfolioAllocation {
  ministry: MinistryType;
  allocated_to: string; // party_id
  allocation_date: number;
  performance_score?: number;
}

enum MinistryType {
  PRIME_MINISTER = 'prime-minister',
  FINANCE = 'finance',
  FOREIGN_AFFAIRS = 'foreign-affairs',
  DEFENSE = 'defense',
  JUSTICE_SECURITY = 'justice-security',
  INTERIOR = 'interior',
  EDUCATION = 'education',
  HEALTH_WELFARE = 'health-welfare',
  ECONOMIC_AFFAIRS = 'economic-affairs',
  AGRICULTURE = 'agriculture',
  INFRASTRUCTURE = 'infrastructure',
  CLIMATE_ENERGY = 'climate-energy',
  HOUSING = 'housing'
}
```

#### Social Media Post Structure
```typescript
interface SocialMediaPost {
  post_id: string;
  author: PersonaIdentity | 'player';
  content: string;
  timestamp: number;
  post_type: 'original' | 'reply' | 'share';
  reply_to?: string; // post_id
  political_topic?: string;
  tone: PostTone;
  engagement_metrics: EngagementMetrics;
  storm_contribution: number; // 0-10
}

enum PostTone {
  NEUTRAL = 'neutral',
  SUPPORTIVE = 'supportive',
  CRITICAL = 'critical',
  DEFENSIVE = 'defensive',
  AGGRESSIVE = 'aggressive',
  HUMOROUS = 'humorous',
  FACTUAL = 'factual'
}

interface EngagementMetrics {
  likes: number;
  shares: number;
  replies: number;
  reach_estimate: number;
  sentiment_score: number; // -1 to +1
}
```

#### News Event Structure
```typescript
interface NewsEvent {
  event_id: string;
  headline: string;
  summary: string;
  political_actors: string[];
  issue_areas: string[];
  importance: number; // 1-10
  media_attention_level: number; // 1-10
  frames: NewsFrame[];
  social_media_origin?: string; // storm_id if originated from social media
}

interface NewsFrame {
  frame_id: string;
  frame_type: 'sympathetic' | 'critical' | 'sensational' | 'dismissive';
  outlet: 'nos' | 'rtl' | 'volkskrant' | 'telegraaf';
  headline: string;
  content_summary: string;
  political_impact: PoliticalImpact;
}

interface PoliticalImpact {
  approval_rating_change: number;
  coalition_stability_change: number;
  relationship_changes: Map<string, number>; // persona_id -> change
  momentum_change: number;
  public_attention_change: number;
}
```

### Polling & Metrics Data

#### Polling Data Structure
```typescript
interface PollingData {
  poll_id: string;
  poll_date: number;
  approval_rating: number;
  seat_projection: SeatProjection;
  demographic_breakdown: DemographicBreakdown;
  confidence_interval: number;
  margin_of_error: number;
  sample_size: number;
  polling_method: 'phone' | 'online' | 'mixed';
}

interface SeatProjection {
  total_seats: 150;
  party_projections: Map<string, number>; // party_id -> projected seats
  coalition_possibilities: CoalitionPossibility[];
  uncertainty_level: number; // 0-10
}

interface DemographicBreakdown {
  by_age: Map<string, number>; // age_group -> approval
  by_region: Map<string, number>; // region -> approval
  by_education: Map<string, number>; // education_level -> approval
  by_income: Map<string, number>; // income_bracket -> approval
}

interface CoalitionPossibility {
  parties: string[];
  total_seats: number;
  formation_probability: number; // 0-1
  stability_prediction: number; // 0-10
}
```

## Keyboard Navigation Map

### Global Shortcuts (Available Across All Apps)
```typescript
interface GlobalKeyboardShortcuts {
  // Window Management
  'Cmd+W': 'Close current window';
  'Cmd+M': 'Minimize current window';
  'Cmd+Tab': 'Switch between open windows';
  'Cmd+`': 'Switch between windows of same app';

  // App Launching
  'Cmd+1': 'Open Messages app';
  'Cmd+2': 'Open Coalition Builder app';
  'Cmd+3': 'Open Social Feed app';
  'Cmd+4': 'Open News Feed app';
  'Cmd+5': 'Open Polls & Data app';
  'Cmd+6': 'Open Calendar app';

  // Game State
  'Cmd+S': 'Save game state';
  'Cmd+O': 'Load game state';
  'Cmd+N': 'New game session';

  // Accessibility
  'Cmd+Plus': 'Increase UI scale';
  'Cmd+Minus': 'Decrease UI scale';
  'Cmd+0': 'Reset UI scale to 100%';
  'F6': 'Toggle high contrast mode';

  // Crisis Management
  'Cmd+!': 'Show all active notifications';
  'Escape': 'Dismiss current notification';
}
```

### App-Specific Shortcuts
```typescript
interface SocialFeedShortcuts {
  // Timeline Navigation
  'J': 'Scroll to next post';
  'K': 'Scroll to previous post';
  'Space': 'Scroll down page';
  'Shift+Space': 'Scroll up page';

  // Post Interaction
  'L': 'Like current post';
  'R': 'Reply to current post';
  'S': 'Share current post';
  'Enter': 'Open post details';

  // Composition
  'N': 'New post';
  'Cmd+Enter': 'Send post';
  '1': 'Use Defend template';
  '2': 'Use Reframe template';
  '3': 'Use Attack template';
  '4': 'Use Clarify template';
}

interface CoalitionBuilderShortcuts {
  // Coalition Management
  'A': 'Add party to coalition';
  'R': 'Remove party from coalition';
  'C': 'Calculate coalition viability';
  'P': 'Open portfolio trading';

  // Navigation
  'Tab': 'Move between coalition elements';
  'Shift+Tab': 'Move backwards between elements';
  'Enter': 'Select/activate element';
  'Space': 'Toggle element selection';
}

interface MessagesShortcuts {
  // Message Navigation
  'Up/Down': 'Navigate contact list';
  'Enter': 'Open conversation';
  'Cmd+R': 'Reply to message';
  'Cmd+N': 'New message';

  // Communication Styles
  'F': 'Formal reply style';
  'P': 'Pragmatic reply style';
  'S': 'Snarky reply style';
  'C': 'Custom reply';
}
```

## Interface Validation

### Event Contract Compliance
- All events include required fields and proper typing
- Event timestamps use consistent format (Unix milliseconds)
- Political impact calculations use standardized ranges
- Cultural authenticity validated by Dutch experts

### Data Schema Validation
- All political positions use consistent ideological scales
- Party data reflects authentic Dutch political landscape
- Coalition mathematics enforce real Dutch parliamentary rules
- Relationship scores use consistent -100 to +100 scale

### Accessibility Standards
- All keyboard shortcuts follow platform conventions
- Navigation patterns support screen readers
- Visual elements include text alternatives
- Contrast ratios meet WCAG 2.1 AA standards

### Performance Requirements
- Event processing completes within 100ms
- Data queries return within 200ms
- UI updates occur within 16ms (60 FPS)
- Memory usage scales linearly with political complexity

---

**Integration Testing**: Each micro-feature must demonstrate successful communication through these interfaces before milestone completion.