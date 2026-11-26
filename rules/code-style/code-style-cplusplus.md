---
paths:
  - "**/*.h"
  - "**/*.c"
  - "**/*.hpp"
  - "**/*.cpp"
---
# code-style-cplusplus

* Headers use `#pragma once`. In a `.cpp`, include `pch.h` (or `pchManaged.h` for C++/CLI) first, then the file's own header, a blank line, then other project and system headers.
* Classes, methods, public members, and free functions: `PascalCase`. Private members and locals: `camelCase` with no `m_` prefix (`trackInitModule`, `numInitAttempts`, `isComplete`). Constants: `PascalCase` (`MaxInitAttempts`, `BufferSize`).
* Win32-style prefixes for handles and pointers: `hInstance`, `hStdOut`, `pSwapChain`, `ppDevice`, `pFunc`. By-reference output parameters start with `out` (`outLpFile`, `outAssembly`).
* Modules made of free functions go in a `namespace` (e.g. `Output`, `ClrBridge`) instead of a static class. Module state is a set of namespace-level variables.
* `using namespace std;` is allowed in `.cpp` files but never in headers. Headers spell out `std::`.
* Prefer `bool Try…()` return values over exceptions. `catch (...)` is acceptable around Win32/CLR interop, but if an error is being swallowed, it must be accompanied by a comment explaining why.
