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
├── SwiftUIPlaygroundApp.swift      # App entry point, .tint(.indigo)
├── Info.plist                      # Full Info.plist (UILaunchScreen, usage descriptions, scene manifest)
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
    ├── Accessibility/              # accessibilityLabel, accessibilityHint, accessibilityValue, Dynamic Type, VoiceOver
    ├── TextAndImages/              # Text, Label, AttributedString, Markdown, Image, AsyncImage, SF Symbols
    ├── ListsAndContainers/         # List, ScrollView, ForEach, ScrollViewReader, Form, TabView, etc.
    ├── Shapes/                     # Rectangle, Circle, Capsule, etc.
    ├── Effects/                    # Shadow, Blur, Rotation, etc.
    ├── Gestures/                   # TapGesture, LongPressGesture, DragGesture, MagnifyGesture, RotateGesture
    ├── Animation/                  # Animation Curves, withAnimation, Transition, PhaseAnimator
    ├── Modifiers/                  # Frame, Padding, Background, Overlay, ClipShape
    ├── Navigation/                 # NavigationLink, Toolbar, NavigationSplitView, NavigationPath
    ├── Drawing/                    # Path, Canvas, Custom Shape
    ├── Media/                      # VideoPlayer, PhotosPicker
    ├── Charts/                     # Bar Chart, Line Chart, Area Chart, Pie Chart
    ├── Maps/                       # Map Basics, Map Markers, Map Camera
    ├── Sensors/                    # Location, Device Motion, Biometric Auth, Battery Monitor
    └── Styling/                    # ButtonStyle, ShapeStyle, Material, LabelStyle, ViewModifier
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
import SwiftUI           // Core UI
import AVKit             // VideoPlayer
import PhotosUI          // PhotosPicker
import Charts            // Bar, Line, Area, Pie charts
import MapKit            // Map, Marker, Annotation, MapCamera
import CoreLocation      // CLLocationUpdate, CLLocationCoordinate2D
import CoreMotion        // CMMotionManager
import LocalAuthentication // LAContext, biometric auth
```

## App Polish

- **App icon**: `Assets.xcassets/AppIcon.appiconset/AppIcon.png` — 1024x1024, abstract SwiftUI view cards on indigo gradient
- **Accent color**: `AccentColor.colorset` — Indigo, light + dark mode
- **Launch screen**: Configured via `UILaunchScreen` dict in `Info.plist` with `LaunchBackground` color + `LaunchLogo` image
- **Display name**: "SwiftUI Play" (set via `CFBundleDisplayName` in Info.plist)
- **App theming**: `.tint(.indigo)` on root `ContentView` in `SwiftUIPlaygroundApp.swift`
- **Icon generation**: Script at `/tmp/generate_icon_v3.swift` (AppKit, run with `swiftc -framework AppKit`)
