---
paths:
  - "**/*.xaml.cs"
  - "**/*.xaml"
---
# code-style-wpf.md

* **WPF bindable properties** use an explicit backing field, an equality early-out, and `OnPropertyChanged(nameof(Prop))`:
  ```csharp
  private string _layerName;
  public string LayerName
  {
      get => _layerName;
      set
      {
          if (value == _layerName)
              return;
          _layerName = value;
          OnPropertyChanged(nameof(LayerName));
      }
  }
  ```
