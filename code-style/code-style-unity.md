---
paths:
  - "**/Assets/**/*.cs"
---
# code-style-unity.md

* MonoBehaviour lifecycle methods are declared `public void Awake()` / `Start()`.
* Subscribe to input actions in `Awake` and handle them in `Handle…Action(InputAction.CallbackContext context)` methods.
* Custom editor menu items go under `"RN/…"`.
* Custom packages are named `RiverNyxx.<Package>` with separate `Runtime`, `Editor`, and `Tests` asmdefs.
