# Analysis & Decision Frameworks

## Tree of Thoughts (Problem-Solving)

Use for complex problems with multiple potential solutions or architectural decisions.

### Methodology
Explore problems like a tree, branching into potential solutions before committing.

1. **Define**: What exactly needs to be solved?
2. **Generate**: Create 2-3 distinct approaches (branches).
3. **Evaluate**: Assess trade-offs (Pro/Con/Risk) for each branch.
4. **Select**: Choose based on constraints (Time, Scalability, Maintenance).

### Evaluation Criteria
* **Correctness**: Does it fully solve the problem?
* **Simplicity**: Is it the simplest working solution?
* **Maintainability**: Can others understand/modify it?
* **Scalability**: Will it work as load grows?

---

## Graph of Thoughts (Code Comprehension)

Use for understanding unfamiliar codebases or system analysis.

### Methodology
Map code relationships as a graph to understand interactions.

`[Controller] --calls--> [Service] --uses--> [Repository]`

### Analysis Strategies
* **Top-Down**: Start at entry points (main, routes) -> Follow data flow down.
* **Bottom-Up**: Start at data models/entities -> Find usages -> Build flow up.

### Mapping Checklist
* **Entry Points**: Where execution starts.
* **Data Flow**: How data transforms through the system.
* **Dependencies**: Internal and external dependencies.
* **Side Effects**: State changes and external calls.

---

## Decision Documentation

For significant technical decisions, document the following:

1. **Context**: The problem being solved.
2. **Options Considered**:
    * **Option A**: Description + Pros/Cons.
    * **Option B**: Description + Pros/Cons.
3. **Decision**: The chosen option and justification.
4. **Consequences**: Risks and long-term impacts.
