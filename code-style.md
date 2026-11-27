---
paths:
  - "**/*.bt"
  - "**/*.h"
  - "**/*.c"
  - "**/*.hpp"
  - "**/*.cpp"
  - "**/*.cs"
  - "**/*.php"
  - "**/*.py"
  - "**/Assets/**/*.cs"
  - "**/*.xaml.cs"
  - "**/*.xaml"
---

# code-style.md

Guidance for writing code, which comes from the user's own code.

**Always match the existing style of the file you are editing first.** Use these rules for new files, and for anything the surrounding code doesn't settle.

## Cross-language principles

* **Allman braces** (opening brace on its own line)
* **Indentation:** 4 spaces. Files are CRLF on Windows projects.
* **Descriptive names.** Prefer `absFilePath`, `devspaceDirLower`, or `isAlreadyInitialized` over terse names. Abbreviations are fine only for short-lived loop or local variables (`i`, `cnt`, `kvp`, `di`).
* **Naming idioms used across languages:**
  - Boolean names start with `is`/`has`/`was`/`can`/`should`: `isError`, `hasTileBank`, `wasWritten`, `isInitComplete`.
  - `abs` marks absolute paths (`absFilePath`, `absDirPath`, `SourceFilePathAbs`). `rel`/`relative` marks relative paths.
  - `Try…` functions return `bool` for success and give results back through `out`/reference parameters: `TryGetCache(out …)`, `TryInit`, `TryHookExports`, `TryCreateDir`.
  - Responses and callbacks are named `Handle…`: `HandleSubmitBugReportResponse`, `HandleToggleCaptureAction`.
  - Init and teardown come in pairs: `Init`/`Deinit`, `TryInit`/`TryDeinit`, `InitLogging`/`DeinitLogging`.
  - A deliberately hacky function gets a `_HACK` suffix, e.g. `SetDirectoryModifiedDate_HACK`.
* **Guard clauses and early outs:** validate first and `return`/`continue` early instead of nesting deeply.
* **Multi-condition `if`s** put each condition on its own line, with the `&&`/`||` operator at the end of the line:
  ```csharp
  if (!string.IsNullOrWhiteSpace(TempZipFilePath) &&
      File.Exists(TempZipFilePath))
  ```
* **Debug-only behaviour** sits behind `#if DEBUG` / `#if _DEBUG`. Examples: local dev URLs in place of production ones, console allocation, and "Press <Enter> to continue" pauses in CLI tools (shown only when `Debugger.IsAttached`).
* Always clean up temp files and partial results, using `finally` blocks or an explicit cleanup or rollback list
* **Secrets and configuration:** read them from environment variables (`getenv('PHP_MYSQLI_SERVER')`, `PROJECT_FILES_ROOT`). Never add hard-coded credentials. When code needs to read a secret, prompt the user to ensure they are aware and can configure it appropriately.

## Comments

Comments are written as plain sentences, and explain *why*, or what the data means.

Comments DOs:
* When it's not easy to surmise the purpose of the class from its name or simple usage. A couple sentences describing the purpose of the class.
* When something unexpected is being done, such as a hack, or deliberately not using the "obvious" technique.
* To describe magic numbers and implied bit patterns.
* To describe why a specific, seemingly-unrelated, action is being taken.
* When longer methods can be split into short labelled stages, each with a one-line comment and separated by blank lines:
  ```csharp
  // Load the CCS for modification
  ...

  // Prep for MD5 checking
  ...
  ```
* When there is an outside dependency that isn't enforced by the language.
  - Whenever a value has to match something elsewhere (database column sizes, server constants, protocol keys).
  - When a hardcoded file path is expected to work.
* Use XML doc comments (`/// <summary>`) for the public-facing API within the current context.
* Use ordinary `//` comments above a member when its implementation needs explaining.

Anywhere else, leave comments out: skip ones that restate what the code already shows, and keep comments short instead of writing large blocks.

Comment formatting:
* **Normal comments** have a space after the slashes and start with a capital letter: `// Clean up temp .zip file`.
* **Tagged comments have no space after the slashes** and end with a colon: `//TODO:`, `//NOTE:`, `//HACK:`. A continuation line is indented so its text lines up under the first line's text:
  ```csharp
  //NOTE: We can't simplify this down to a SectorModeBase.WriteMultipleSectors() call because
  //      the data needs to be split at very specific offsets...
  ```
* **Project-level backlog `//TODO:`s** sit at column 0, in a block after the `using`s and before the namespace of a central file. A TODO for a specific spot in the code is indented to match that code.
* **End-of-line comments** are aligned when they appear in a related group:
  ```csharp
  private const int Projects_NameLength = 100;        // Must remain in sync with <db>.projects.name length
  private const int Categories_NameLength = 100;      // Must remain in sync with <db>.categories.name length
  ```
