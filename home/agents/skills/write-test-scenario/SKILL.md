---
name: write-test-scenario
description:
  Write one or more test scenarios using GIVEN, WHEN, THEN structure based on
  provided requirements. Support BDD or TDD development workflows.
---

# Write Test Scenario

## When to use

* when asked to write test scenarios
* when working in a BDD or TDD based workflow
* before implementing tests (unit, integration, end-to-end, contract)

## Workflow

1. Analyze signatures and provided types of units under test to
   understand intent and design
2. Analyze user provided requirements
3. Derive a set of scenarios and summarize them using a simple, concise
   and short description starting with "should"
4. describe each scenario using GIVEN, WHEN, THEN form.

## Requirements

* Keep scenarios short
* Test main happy path, error paths and interference with other requirements
* Short, concise language avoiding accidental complexity

## Output

List of test scenarios following the GIVEN, WHEN, THEN format. A test scenario
number and title using a sentence describing expected behaviour using "should".

Example

Scenario 1: should add two numbers correctly
GIVEN: Two numbers x, y
WHEN: They are added together (add)
THEN: The result should be their sum

Only write scenarios, no implementation.
