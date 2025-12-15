---
name: nfr-product-lens
description: Surface non-functional requirements (security, observability, cost, performance, reliability) as product requirements. This skill should be used when extracting product implications from technical docs, conversations, or architecture decisions. Triggers on requests to identify NFRs, surface hidden product requirements, translate technical constraints to product terms, or ensure nothing is missed in product specs. Works with architecture docs, technical conversations, or any context where non-functional concerns have product impact.
---

# Non-Functional Requirements as Product Requirements

## Overview

Non-functional requirements (NFRs) are often treated as "engineering concerns" but they directly impact users, costs, and business viability. This skill surfaces NFRs in product-centric terms, ensuring they're captured as first-class product requirements rather than afterthoughts buried in technical docs.

## When to Use

- Reviewing architecture docs or technical proposals for product implications
- Ensuring product specs capture non-functional concerns
- Translating engineering constraints into product language
- Auditing existing requirements for gaps
- Facilitating conversations between product and engineering

## NFR Categories and Product Impact

### Security & Privacy

| Technical Concern | Product Requirement |
|-------------------|---------------------|
| Authentication method | "Users can sign in with [email/SSO/social]. Password reset takes [X] steps" |
| Data isolation (multi-tenancy) | "Users never see another business's data, even in error states" |
| Encryption at rest/transit | "Customer data is encrypted—we can represent this in security questionnaires" |
| Session management | "Users stay logged in for [X days]. Logging out on one device affects [all/just that device]" |
| Audit logging | "We can answer 'who changed what, when' for compliance/disputes" |
| Data retention/deletion | "When a user deletes their account, their data is [removed immediately/retained for X days/anonymized]" |

**Questions to surface:**
- What happens if credentials are compromised?
- Can admins see/impersonate user data?
- What's our liability if there's a breach?

### Reliability & Availability

| Technical Concern | Product Requirement |
|-------------------|---------------------|
| Uptime SLA | "App is available [99%/99.9%] of the time—[X hours/minutes] downtime per month acceptable" |
| Offline capability | "Users can [view only/full functionality] without internet. Changes sync when reconnected" |
| Data durability | "User data survives [device loss/server failure/regional outage]" |
| Graceful degradation | "If [service X] is down, users can still [do Y] but not [do Z]" |
| Conflict resolution | "If two users edit the same thing, [last save wins/they're prompted to merge/first save wins]" |

**Questions to surface:**
- What's the user experience during an outage?
- How much data loss is acceptable (seconds? minutes? none)?
- Do users need to know when they're offline?

### Performance & Responsiveness

| Technical Concern | Product Requirement |
|-------------------|---------------------|
| Page/screen load time | "Screens load in under [X seconds] on [3G/4G/WiFi]" |
| Search/query speed | "Search results appear within [X seconds] for typical queries" |
| Sync latency | "Changes appear on other devices within [seconds/minutes/when they refresh]" |
| Batch operation limits | "Users can [import/export/delete] up to [X] items at once" |
| File size limits | "Attachments up to [X MB]. Larger files [rejected/compressed/chunked]" |

**Questions to surface:**
- What does "fast enough" mean for our users?
- Are there operations that block users from doing other things?
- What's the experience on slow/unreliable connections?

### Scalability & Limits

| Technical Concern | Product Requirement |
|-------------------|---------------------|
| User/tenant limits | "Each business can have up to [X] staff and [Y] customers" |
| Data volume limits | "Users can store up to [X] tasks/records/GB" |
| API rate limits | "Power users/integrations can make [X] requests per [minute/hour]" |
| Concurrent users | "Up to [X] people can use the app simultaneously per business" |
| Growth assumptions | "Architecture supports [X] total users before requiring changes" |

**Questions to surface:**
- What happens when users hit limits? (Hard block? Warning? Upsell?)
- Are limits per-user, per-business, or global?
- What's our biggest customer going to look like?

### Cost & Resource Consumption

| Technical Concern | Product Requirement |
|-------------------|---------------------|
| Infrastructure costs | "Each active user costs ~$[X]/month to serve" |
| Third-party service costs | "We pay $[X] per [API call/GB stored/email sent]" |
| Cost scaling | "Costs scale [linearly/exponentially] with users—[X] users = $[Y]/month" |
| Resource-intensive features | "[Feature X] costs [Y] per use—consider usage limits or pricing tier" |
| Free tier boundaries | "Free users can [do X] but [Y] requires paid plan" |

**Questions to surface:**
- Which features are expensive to provide?
- What user behaviors could blow up our costs?
- Can a single bad actor hurt us financially?

### Observability & Support

| Technical Concern | Product Requirement |
|-------------------|---------------------|
| Error visibility | "When something breaks, users see [friendly message/error code/nothing]" |
| Support tools | "Support team can [view user's data/impersonate/see their actions]" |
| Debugging capability | "We can diagnose issues within [minutes/hours/days]" |
| Usage analytics | "We know [which features are used/where users drop off/what causes churn]" |
| Alerting | "We learn about outages [before users/when users report/from monitoring]" |

**Questions to surface:**
- How do users report problems?
- Can we proactively reach out when we detect issues?
- What data do we need to diagnose a support ticket?

### Compliance & Legal

| Technical Concern | Product Requirement |
|-------------------|---------------------|
| Data residency | "User data is stored in [US/EU/user's region]" |
| Regulatory requirements | "We comply with [GDPR/HIPAA/SOC2/none yet]" |
| Export capability | "Users can export all their data in [format] within [timeframe]" |
| Terms enforcement | "We can [suspend/terminate] accounts that violate terms" |
| Audit requirements | "We retain [logs/records] for [X years] for compliance" |

**Questions to surface:**
- What regulations apply to our target market?
- What happens if a user requests data deletion?
- Do we need to support legal holds?

## Extraction Process

### From Architecture Docs

1. Scan each section for implicit product decisions
2. Look for numbers (limits, timeouts, SLAs)
3. Identify "boring" technical choices with user impact
4. Note assumptions stated as facts
5. Flag decisions marked as "simple" or "for now"

### From Conversations

1. Listen for technical constraints mentioned casually
2. Ask "what does the user experience when X happens?"
3. Probe edge cases: "what if they're offline/over limit/concurrent?"
4. Challenge assumptions: "how do we know users are okay with X?"

### From Existing Specs

1. Check for NFR gaps using categories above
2. Verify stated requirements have acceptance criteria
3. Ensure limits and thresholds are explicit
4. Confirm error/edge cases are covered

## Output Format

Structure extracted NFRs as product requirements:

```markdown
# Non-Functional Product Requirements

## [Category]

### [Requirement Name]
**User Impact:** What users experience
**Constraint:** The technical boundary
**Acceptance Criteria:** How we verify this is met
**Trade-off:** What we give up for this choice
**Reversibility:** Easy/Medium/Hard to change later

### [Next Requirement]
...
```

## Red Flags to Surface

Always call out when you find:

- **Unstated limits** — "up to X" without saying what happens at X+1
- **Assumed acceptable** — "users won't mind" without validation
- **Deferred decisions** — "we'll figure this out later" for critical paths
- **Single points of failure** — one service/person/process that can break everything
- **Cost unknowns** — usage-based pricing without usage projections
- **Implicit SLAs** — reliability expectations without explicit targets
