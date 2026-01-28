# Architecture Reference

## Project Overview
An interactive iOS app showcasing SwiftUI components with live parameter editing and code generation. Built for developers who want to quickly explore SwiftUI APIs and copy working code.

## Architecture Decisions

1. **Navigation**: `NavigationStack` with `searchable` modifier - simple, native, iOS 17+
2. **Collapsible Sections**: Using `Section(isExpanded:)` with custom binding to `Set<ComponentCategory>`
3. **State**: Each playground owns its `@State` - isolated, follows modern-swift.md guidelines
4. **Code Generation**: Computed `generatedCode` property that reflects current state - always accurate
5. **User Preferences**: `@AppStorage("includeComments")` for code comment toggle
6. **Project Structure**: Feature-based organization (Components/Controls/, Components/Layout/, etc.)

## File Structure

```
SwiftUIPlayground/
├── SwiftUIPlaygroundApp.swift      # App entry point
├── Navigation/
│   ├── ContentView.swift           # Main nav with search + collapsible sections
│   └── ComponentCategory.swift     # Enum for categories + ComponentDestination
├── Shared/
│   ├── ComponentPage.swift         # 3-panel layout: preview, controls tab, code tab
│   ├── CodePreview.swift           # Syntax display + copy button + comments toggle
│   └── ParameterControl.swift      # SliderControl, PickerControl, ToggleControl, ColorControl, TextFieldControl
└── Components/
    ├── Controls/                   # Button, Toggle, Slider, etc.
    ├── Layout/                     # VStack, HStack, ZStack, Grid, etc.
    ├── TextAndImages/              # Text, Label, Image, AsyncImage
    ├── ListsAndContainers/         # List, ScrollView, Form, TabView, etc.
    ├── Shapes/                     # Rectangle, Circle, Capsule, etc.
    ├── Effects/                    # Shadow, Blur, Rotation, etc.
    ├── Gestures/                   # TapGesture, LongPressGesture, DragGesture
    ├── Animation/                  # Animation Curves, withAnimation, Transition, PhaseAnimator
    ├── Modifiers/                  # Frame, Padding, Background, Overlay, ClipShape
    ├── Navigation/                 # NavigationLink, Toolbar, NavigationSplitView, NavigationPath
    ├── Drawing/                    # Path, Canvas, Custom Shape
    ├── Media/                      # VideoPlayer, PhotosPicker
    ├── Charts/                     # Bar Chart, Line Chart, Area Chart, Pie Chart
    └── Maps/                       # Map Basics, Map Markers, Map Camera
```

## Key Files to Modify When Adding Components

| File | What to Add |
|------|-------------|
| `Components/{Category}/{Name}Playground.swift` | New playground view |
| `Navigation/ComponentCategory.swift` | Add to enum + destination switch |
| `Navigation/ContentView.swift` | Add NavigationLink case |
| `project.pbxproj` | Add file references (4 places) - OR use xcodeproj MCP |

## iOS Version Requirements

- **Minimum deployment target**: iOS 17.0
- **Features requiring iOS 17+**:
  - `Section(isExpanded:)` for collapsible sections
  - `ContentUnavailableView`
  - `PhaseAnimator`
  - New MapKit content builder syntax
  - Implicit returns in switch expressions

## Frameworks Used

```swift
import SwiftUI     // Core UI
import AVKit       // VideoPlayer
import PhotosUI    // PhotosPicker
import Charts      // Bar, Line, Area, Pie charts
import MapKit      // Map, Marker, Annotation, MapCamera
```
