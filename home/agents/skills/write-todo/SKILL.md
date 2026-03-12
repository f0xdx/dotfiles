---
name: write-todo
description:
  Write one or more TODO or task items planning a detailed succession of steps
  that can be tracked and executed.
---

# Write TODO

## When to use

* when asked to write a task / TODO / 2DO in any spelling
* during planning work, when given a goal or requirement to act on
* while detailing workflows for later execution

## Workflow

For each goal / requirement provided:

1.  **Analyze Context**: Analyze user intent, requirements, and provided
    artifacts to gather context. Identify if this belongs in a markdown file
    or as a comment in code.
2.  **Identify Date**: Use today's date in `YYYY-MM-DD` format.
3.  **Plan Steps**: Plan a sequence of steps to achieve the goal / satisfy the
    requirement.
4.  **Identify Location**:
    *   If no file is provided, default to a separate `tasks.md` in the current
        directory.
    *   If an existing file is provided, determine the appropriate location
        inline (markdown or code comment).
5.  **Apply Template**: Use the `todo-template.md` as a base for the task.

## Requirements

*   **Format**: The title MUST follow the pattern: `TODO <short description of
    the goal> (<YYYY-MM-DD>)`.
*   **Header Level**: Use an appropriate markdown heading level based on
    sourrounding context (e.g., `##`) in markdown files or a comment prefix in
    code (e.g., `//` or `#`).
*   **Checklist**: Use markdown checkboxes (`* [ ]`) for all task
    steps.
*   **Completeness**: Keep steps short and minimal but ensure completeness.
*   **Clarity**: Use short, concise language.
*   **Separation**: Use a blank line above and below the each generated item

## Assets

*   [TODO Template](assets/todo-template.md): Standard template for tasks.

## Examples

### Markdown Example

```markdown
## TODO Bash Utility Support (2025-05-26)

* [ ] bash scripts reviewed / improved
* [ ] bash scripts available as home manager module
```

### Code Example (Python)

```python
# TODO Refactor database connection (2025-05-26)
#
# * [ ] use connection pool
# * [ ] add retry logic
```
