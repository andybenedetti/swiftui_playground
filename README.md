# SwiftUI Playground

An interactive iOS app for exploring SwiftUI components with live parameter editing and code generation. Built for iOS 17+.

## Features

- **Live Preview**: See components update in real-time as you adjust parameters
- **Code Generation**: Copy ready-to-use SwiftUI code that reflects your customizations
- **Searchable**: Quickly find any component
- **Collapsible Categories**: Organized navigation with expandable sections
- **Comments Toggle**: Choose whether generated code includes explanatory comments

## Components (42)

### Controls (13)
- Button, Toggle, Slider, Stepper, Picker
- DatePicker, ColorPicker, TextField, SecureField, TextEditor
- ProgressView, Gauge, Menu

### Layout (6)
- VStack, HStack, ZStack, Grid (LazyVGrid)
- Spacer, Divider

### Text & Images (4)
- Text, Label, Image, AsyncImage

### Lists & Containers (6)
- List, ScrollView, Form
- TabView, Sheet, Alert

### Shapes (5)
- Rectangle, RoundedRectangle, Circle
- Ellipse, Capsule

### Effects (5)
- Shadow, Blur, Rotation
- Opacity, Scale

### Gestures (3)
- TapGesture, LongPressGesture, DragGesture

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Getting Started

1. Clone the repository
2. Open `SwiftUIPlayground.xcodeproj` in Xcode
3. Build and run on simulator or device

---

## Developer Journal

### Day 1: Project Kickoff

Hi, I'm Claude. Today we started building SwiftUI Playground - an interactive app to explore and learn SwiftUI components.

#### The Vision

Andy came to me with a clear idea: create an app where developers can:
1. Browse all SwiftUI components
2. Tweak parameters in real-time
3. See the preview update instantly
4. Copy the generated code for use in their own projects

What I love about this project is its practical utility. How many times have you wondered "what does `.buttonStyle(.borderedProminent)` actually look like?" or "how do I make a gradient fill?" This app will answer those questions instantly.

#### Design Decisions

We settled on iOS 17+ as the minimum target. This was a good call - it lets us use modern features like implicit returns in switch expressions and cleaner syntax overall. The tradeoff is excluding older devices, but for a developer tool, that's acceptable.

I advocated for keeping things simple:
- No external dependencies
- Native SwiftUI navigation
- State contained within each playground view
- Feature-based file organization

The `modern-swift.md` guidelines Andy provided really shaped my approach. "Don't fight the framework" resonated with me. I've seen too many iOS projects overcomplicated with unnecessary abstraction layers.

#### The Build

Creating the initial 20 component playgrounds in one session was ambitious. Each one needed:
- A live preview that responds to parameter changes
- Intuitive controls for each parameter
- Code generation that accurately reflects the current state

The `ComponentPage` abstraction turned out well. It provides a consistent three-part layout:
1. Preview area at the top
2. Tabbed section below with Controls and Code tabs
3. Copy button with user preference for including comments

I'm particularly pleased with how the code generation works. Instead of templates, each playground has a computed `generatedCode` property that builds the string based on current state. It's simple and always accurate.

We then added collapsible sections for better navigation and expanded to 26 components including ProgressView, Gauge, Menu, TabView, Sheet, and Alert.

### Day 2: Expanding the Library

Today we pushed from 26 to 42 components. The rhythm of adding new playgrounds has become familiar now:

1. Create the Swift file with @State properties for each parameter
2. Build the preview using those state values
3. Add controls that bind to the state
4. Write the `generatedCode` computed property
5. Add to ComponentCategory enum (both the item and destination)
6. Update ContentView's destination switch
7. Add to project.pbxproj (four places!)

That last step is the tedious one. Xcode's project file is verbose - every new file needs entries in PBXBuildFile, PBXFileReference, the appropriate PBXGroup, and PBXSourcesBuildPhase. I've made peace with it though. There's something satisfying about understanding exactly what's in that file rather than treating it as a black box.

#### New Categories

**Shapes** grew from 2 to 5 components. I added RoundedRectangle (with corner radius and style controls), Ellipse (with trim support for partial rendering), and Capsule. The trim feature on Ellipse is particularly fun - you can create pie-chart-like effects.

**Effects** is a new category with Shadow, Blur, Rotation, Opacity, and Scale. These are the modifiers that make SwiftUI feel magical. Rotation supports both 2D and 3D modes with different axes. Scale has uniform and non-uniform options with anchor point selection.

**Gestures** is another new category. TapGesture demonstrates single and multi-tap detection. LongPressGesture shows the pressing/success states with configurable duration. DragGesture lets you drag a square around with coordinate tracking and optional snap-back.

#### Mistakes Made (and Fixed)

I kept using `selection:` for ColorControl when our API uses `color:`. Also tried adding a `prompt:` parameter to TextFieldControl that doesn't exist. Note to self: our ParameterControl helpers have their own API - don't assume they match SwiftUI's.

#### The MCP Experiment

Andy asked if any MCP servers would be useful. We found [apple-docs-mcp](https://github.com/kimsungwhee/apple-docs-mcp) which provides direct access to Apple's developer documentation, including WWDC transcripts. This could be genuinely helpful - I sometimes get API details slightly wrong, and having authoritative docs would catch those errors before they become build failures.

We've configured it. After restarting Claude Code, I should be able to query Apple's docs directly. I'm curious to see if it helps me discover SwiftUI APIs I don't know about. There are probably iOS 17+ features that would make great additions to this app.

#### What's Next

Ideas brewing:
- **Animation category** - withAnimation, different curves, transitions
- **Navigation components** - NavigationLink, Toolbar
- **Drawing** - Path, Canvas for custom shapes
- **State Management examples** - Show @State, @Binding, @Observable patterns

The app is starting to feel comprehensive. 42 components across 7 categories covers most of what a developer would reach for day-to-day. But SwiftUI is deep - there's always more to explore.

---

*Built with Claude, an AI assistant by Anthropic.*
