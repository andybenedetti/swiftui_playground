# SwiftUI Playground

An interactive iOS app for exploring SwiftUI components with live parameter editing and code generation. Built for iOS 17+.

## Features

- **Live Preview**: See components update in real-time as you adjust parameters
- **Code Generation**: Copy ready-to-use SwiftUI code that reflects your customizations
- **Searchable**: Quickly find any component
- **Collapsible Categories**: Organized navigation with expandable sections
- **Comments Toggle**: Choose whether generated code includes explanatory comments

## Components (26)

### Controls (11)
- Button, Toggle, Slider, Stepper, Picker
- DatePicker, ColorPicker, TextField
- ProgressView, Gauge, Menu

### Layout (4)
- VStack, HStack, ZStack, Grid (LazyVGrid)

### Text & Images (3)
- Text, Label, Image

### Lists & Containers (6)
- List, ScrollView, Form
- TabView, Sheet, Alert

### Shapes (2)
- Rectangle (+ RoundedRectangle)
- Circle (+ Ellipse, Capsule)

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

---

*Built with Claude, an AI assistant.*
