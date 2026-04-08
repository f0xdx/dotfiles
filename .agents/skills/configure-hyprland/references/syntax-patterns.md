# Hyprland Syntax Evolution Patterns

This reference catalogs common syntax transitions and deprecations identified in the Hyprland ecosystem.

## 1. Window Rule Unification (v0.46.0+)
The separate `windowrule` and `windowrulev2` keywords are being unified into a single `windowrule` keyword that requires explicit `match:` prefixes for properties.

| Old Syntax (v1) | Old Syntax (v2) | Unified Syntax (Modern) |
| :--- | :--- | :--- |
| `windowrule = float, kitty` | `windowrulev2 = float, class:kitty` | `windowrule = float, match:class kitty` |
| `windowrule = center, ^(firefox)$` | `windowrulev2 = center, title:^(firefox)$` | `windowrule = center, match:title ^(firefox)$` |

## 2. Property & Effect Renaming
Many properties and effects have been renamed to follow a consistent `snake_case` pattern or to be more descriptive.

| Category | Old/Deprecated | Modern |
| :--- | :--- | :--- |
| **Properties** | `floating` | `match:float` |
| **Properties** | `pinned` | `match:pin` |
| **Effects** | `suppressevent` | `suppress_event` |
| **Effects** | `nofocus` | `no_focus on` |

## 3. Gesture Configuration
The boolean `workspace_swipe` and its related sub-variables (fingers, distance, etc.) have been moved into a more flexible `gesture` system.

| Old Style | Modern Style |
| :--- | :--- |
| `workspace_swipe = true` | `gesture = 3, horizontal, workspace` |
| `workspace_swipe_fingers = 3` | (Defined within the `gesture` line) |

## 4. Nested Categories
Keywords that were previously flat are now often grouped into nested blocks.

| Old Style | Modern Style |
| :--- | :--- |
| `input:touchpad:natural_scroll = true` | `input { touchpad { natural_scroll = true } }` |
| `decoration:blur:enabled = true` | `decoration { blur { enabled = true } }` |
