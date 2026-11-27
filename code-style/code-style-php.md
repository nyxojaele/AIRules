---
paths:
  - "**/*.php"
---
# code-style-php

**Server/API and class code** (`inc/classes/*`, `public/projects/*`, `public/projects/admin/*`):
* Allman braces, 4-space indentation, and single-statement `if`s must use braces.
* `PascalCase` functions and methods (ie. `TryCreateDir`, `CheckPostFileForErrors`, `CleanupForAbort`), `camelCase` variables and properties, and typed parameters (`string $filePath`). Use modern PHP 8 features where they fit: `enum`, `readonly class`, constructor property promotion, `\Throwable`.
* Use `require_once dirname(__FILE__).'/…'` for includes. Class files end with `?>`.
* SQL is written as multi-line double-quoted strings: uppercase keywords, one clause per line, and continuation conditions (`AND …`, `JOIN …`) indented beneath:
  ```php
      "
      SELECT id
      FROM versions
      WHERE project_id=$project_id
          AND channel_id IS NULL
      "
  ```
  Always call `$result->free()` once you've finished with a result. Wrap multi-step writes in `transaction` and abort on failure.
