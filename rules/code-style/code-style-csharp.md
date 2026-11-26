---
paths:
  - "**/*.cs"
---

# code-style-csharp

## Layout and formatting
* One top-level type per file, with the file named after the type. The namespace mirrors the folder path (ie. `ZoneEd.States.Picking`, `PostProjectBuild.Steps.Step`). Shared libraries use `RiverNyxx.<Area>`.
* `using`s go at the top, outside the namespace. Aliases resolve clashes: `using WpfColor = System.Windows.Media.Color;`, `using Object = UnityEngine.Object;`.
* Single-statement `if`/`else`/`foreach` bodies always use braces.
* `else if` chains and `using (…)` stacks are written without extra nesting:
  ```csharp
  using (var inStream = new MemoryStream(indexBuf))
  using (var outStream = File.OpenWrite(outFilePath))
  using (var writer = new BinaryWriter(outStream))
  {
  ```
* Long parameter lists or argument lists wrap onto continuation lines indented one extra level. Builder-style calls put one argument per line.
* Trailing commas in multi-line object initializers, collection initializers, and enum lists.
* Use `#region Name` / `#endregion` more heavily as the file gets longer, with a blank line inside each boundary, to group related members, (e.g. `#region Properties for binding`, `#region Property changed callbacks`, `#region IDisposable`, `#region Args/Output`, `#region Helpers`), and per-feature regions (e.g. `#region Maintenance Mode`). Regions may nest. For very isolated features, fields that belong to it are declared inside that feature's region, otherwise they are hoisted to the top of the class.

## Naming
* Types, methods, properties, events, constants, and `static readonly` fields: `PascalCase`.
* Private and protected instance fields: `_camelCase`.
* Locals and parameters: `camelCase`.
* Constants that belong to a group use `Group_Name` (`MaxLength_Attempting`, `Projects_DescriptionLength`). Enum members may do the same (`Op_ZeroLg`, `Op_Terminate`).
* Interfaces start with `I` (`IPicker<T>`, `IPickable`). Base classes end in `Base` (`ZoneEdStateBase<T>`, `CopyOutputFilesStepBase`). Extension classes are named `<Type>Extensions`.
* Custom delegates are named `…Handler` (ie. `BugReportResponseHandler`, `WWWOutputHandler`) and are declared right beside the API that uses them. They are preferred over raw `Action`/`Func` in public APIs.
* WPF event handlers are named `Owner_OnEvent` (`MainWindow_OnLoaded`, `ComboBox_ChannelNames_OnSelectionChanged`, `PassListView_OnRemoveClicked`). Named XAML elements use `Type_Purpose` where that's useful (`ComboBox_ProjectListing`).
* Value converters are named `<What>To<What>Converter`. Each exposes a singleton, `public static readonly XConverter Instance = new XConverter();`, and XAML references that singleton.

## Idioms
* Use `var` wherever the type is obvious or noisy, and an explicit type when declaring without initializing (`string filename;`, `byte[] indexBuf = null;`).
* String interpolation (`$"…"`) rather than `string.Format`. Use `nameof(...)` for property-change notifications, switch cases, and argument exceptions.
* Expression-bodied members for trivial getters and overrides: `public string LayoutBinPath => _layoutBinPath;`, `protected override bool CanMultiPick => false;`.
* `callback?.Invoke(...)` for optional callbacks and events.
* Prefix increment in `for` loops: `for (var i = 0; i < n; ++i)`.
* Validate arguments at the top with `throw new ArgumentNullException(nameof(x))`. Throw `InvalidOperationException` or `NotSupportedException` for misuse. When a "shouldn't happen" condition is detected anyway, include a clear message: `"… This shouldn't be possible"`.
* Custom exceptions form small hierarchies under a project-level base (`PostProjectBuildException` → `StepException`). Each one has a minimal `(string message) : base(message) { }` constructor.
* Use the full Dispose pattern (`Dispose()` + `protected virtual Dispose(bool isDisposing)` + an `_isDisposed` guard + `GC.SuppressFinalize`) for classes that own resources.
