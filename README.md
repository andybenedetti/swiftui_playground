*This project was built by Claude, and he [blogged](BLOG.md) about it.*

# SwiftUI Playground

An interactive iOS app for exploring SwiftUI components with live parameter editing and code generation. Built for iOS 17+.

## Features

- **Live Preview**: See components update in real-time as you adjust parameters
- **Code Generation**: Copy ready-to-use SwiftUI code that reflects your customizations
- **Documentation Links**: Every component includes a link to official Apple documentation
- **Searchable**: Quickly find any component across all categories
- **Category Navigation**: Browse 19 organized categories, tap to see components
- **Comments Toggle**: Choose whether generated code includes explanatory comments

## Components (95)

### Accessibility (5)
- accessibilityLabel, accessibilityHint, accessibilityValue, Dynamic Type, VoiceOver

### Animation (4)
- Animation Curves, withAnimation, Transition, PhaseAnimator

### Charts (4)
- Bar Chart, Line Chart, Area Chart, Pie Chart

### Containers (6)
- Form, TabView, Sheet, Alert, DisclosureGroup, ContentUnavailableView

### Controls (16)
- Button, Toggle, Slider, Stepper, Picker
- DatePicker, ColorPicker, TextField, SecureField, TextEditor
- ProgressView, Gauge, Menu, Link, ShareLink, MultiDatePicker

### Data Flow (5)
- @State, @Binding, @Observable, @Environment, @AppStorage

### Drawing (3)
- Path, Canvas, Custom Shape

### Effects (5)
- Shadow, Blur, Rotation, Opacity, Scale

### Focus & Keyboard (3)
- @FocusState, Keyboard Toolbar, Submit Actions

### Gestures (5)
- TapGesture, LongPressGesture, DragGesture, MagnifyGesture, RotateGesture

### Images (3)
- Image, AsyncImage, SF Symbols

### Layout (9)
- VStack, HStack, ZStack, Grid (LazyVGrid)
- Spacer, Divider, ViewThatFits, TimelineView, GeometryReader

### Lists (4)
- List, ScrollView, ForEach, ScrollViewReader

### Maps (3)
- Map Basics, Map Markers, Map Camera

### Media (2)
- VideoPlayer, PhotosPicker

### Modifiers (5)
- Frame, Padding, Background, Overlay, ClipShape

### Navigation (4)
- NavigationLink, Toolbar, NavigationSplitView, NavigationPath

### Shapes (5)
- Rectangle, RoundedRectangle, Circle, Ellipse, Capsule

### Text (4)
- Text, Label, AttributedString, Markdown

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Getting Started

1. Clone the repository
2. Open `SwiftUIPlayground.xcodeproj` in Xcode
3. Build and run on simulator or device

## Development with Claude Code

This project includes a complete setup guide for AI-assisted SwiftUI development. See [`.claude/SWIFT_CLAUDE.md`](.claude/SWIFT_CLAUDE.md) for how to replicate this development environment with Claude Code, including MCP server setup, build/test workflows, preview rendering, and lessons learned.

---

*Built with Claude, an AI assistant by Anthropic.*
