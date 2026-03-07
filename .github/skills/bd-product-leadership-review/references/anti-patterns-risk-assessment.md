# Anti-Patterns: Risk Assessment

Failure modes where specific risk dimensions are inadequately evaluated.

## Flying Blind [Critical]

### Signs
- Outcome-based KRs are proposed but no instrumentation exists to measure them
- Team cannot produce a dashboard showing current baseline metrics
- Feature is live in production but no usage data is being collected
- "We'll add analytics later" appears in the plan

### Impact
Team cannot confirm whether outcomes are being achieved. Decisions revert to gut feel, and failed features persist because no one has data to challenge them.

### Fix
For proposals: require an instrumentation plan alongside the feature spec. For existing features: add telemetry retroactively and establish baselines before claiming success.

### Detection
- **Document patterns to search for:** "add analytics later", "track metrics post-launch", "measure after release"; KRs without corresponding instrumentation plan
- **Review questions:** "Can you show me the dashboard for this KR right now?" "What is the current baseline value?"
- **Test method:** Check if Instrumentation & Guardrails dimension scores 2 or below

---

## Untested Usability [Major]

### Signs
- No prototype or mockup was tested with real users
- UX is designed by engineers without design review
- "We'll iterate after launch" is the usability plan
- No task completion rates or success criteria for the user experience

### Impact
Feature is built but users cannot figure out how to use it, leading to low adoption, high support burden, and eventual abandonment.

### Fix
Conduct usability tests with at least 5 representative users before committing to build. Define task completion criteria.

### Detection
- **Document patterns to search for:** "iterate after launch", "collect feedback post-release"; absence of usability testing artifacts
- **Review questions:** "Who tested this with real users? What did they find?" "What are the task completion criteria?"
- **Test method:** Check if Usability Risk U1 (User Testing) scores 2 or below

---

## Feasibility Handwave [Major]

### Signs
- Timeline set by stakeholders without engineering input
- No spike or prototype for technically uncertain components
- "How hard can it be?" justification for estimates
- Dependencies on external teams not validated

### Impact
Project runs over timeline, quality suffers under deadline pressure, and technical debt accumulates from shortcuts.

### Fix
Require engineer-validated estimates. Conduct spikes for any component with technical uncertainty. Document assumptions and dependencies.

### Detection
- **Document patterns to search for:** Timeline or deadline without engineering signoff; "should be straightforward", "relatively simple" for novel components
- **Review questions:** "Did an engineer provide this estimate?" "What spike or prototype validates this timeline?"
- **Test method:** Check if Feasibility Risk F3 (Estimation Quality) or F5 (Uncertainty Reduction) scores 2 or below

---

## Viability Blindspot [Major]

### Signs
- No analysis of unit economics, margins, or cost to serve
- Legal and compliance implications not evaluated
- Go-to-market plan absent — sales and marketing not consulted
- "We'll monetize later" mindset

### Impact
Feature launches successfully from a product perspective but is unsustainable — too expensive to support, legally risky, or impossible to sell.

### Fix
Include viability assessment in every proposal. Consult legal for regulated domains. Validate GTM with sales and marketing before building.

### Detection
- **Document patterns to search for:** "monetize later", "figure out pricing after launch"; absence of unit economics or GTM section
- **Review questions:** "What does it cost to serve one user?" "Has legal reviewed this?" "Can sales articulate the value proposition?"
- **Test method:** Check if Business Viability Risk scores 2 or below

---

## Missing Guardrails [Major]

### Signs
- Single metric is optimized with no side-effect monitoring
- Team cannot answer "what could go wrong if we succeed at this metric?"
- No OEC or trade-off documentation
- Previous optimization caused unintended harm that was discovered late

### Impact
Optimizing one dimension degrades another — e.g., engagement increases but churn spikes, or conversion improves but support costs double.

### Fix
Define at least one guardrail metric per primary KR. Document acceptable trade-offs explicitly. Monitor guardrails with the same rigor as primary metrics.

### Detection
- **Document patterns to search for:** Single-metric KRs without guardrails; absence of trade-off analysis; "maximize X" without constraints
- **Review questions:** "What could go wrong if you achieve this metric?" "What are you protecting while optimizing this?"
- **Test method:** Check if Product Outcomes P4 (Guardrail Metrics) is Missing and Instrumentation I4 (Guardrail Monitoring) scores 2 or below

---

<AntiPatternSummary>
  <Pattern name="Flying Blind" severity="Critical" dimension="Instrumentation &amp; Guardrails" appliesTo="Both" />
  <Pattern name="Untested Usability" severity="Major" dimension="Usability Risk" appliesTo="Both" />
  <Pattern name="Feasibility Handwave" severity="Major" dimension="Feasibility Risk" appliesTo="Proposal" />
  <Pattern name="Viability Blindspot" severity="Major" dimension="Business Viability" appliesTo="Both" />
  <Pattern name="Missing Guardrails" severity="Major" dimension="Product Outcomes" appliesTo="Both" />
</AntiPatternSummary>
