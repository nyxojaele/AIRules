---
paths:
  - "**/*.bt"
---
# code-style-bt

These are used heavily to reverse-engineer game file formats.
* Group the file into sections separated by banner comments:
  ```
  //****************************
  //       ROOM STRUCTS
  //****************************
  ```
* Use `local const` for constants, `typedef struct { … } NameStruct;` for structures, and `typedef` for semantic primitive types (`typedef ulong PSXPointer <read=ReadPSXPointer>;`).
* Give important structs and types a `<read=ReadX>` display function. Use `<format=hex|binary>` and `<bgcolor=…>` to make the data readable.
* Document fields at length in end-of-line and preceding comments: bit layouts, value tables, offsets, and findings that are still uncertain ("Always 0?").
* Save and restore the read position (`local int oldPos = FTell(); … FSeek(oldPos);`) when following pointers.
