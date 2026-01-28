# SwiftUI Playground

An interactive iOS app for exploring SwiftUI components with live parameter editing and code generation. Built for iOS 17+.

## Features

- **Live Preview**: See components update in real-time as you adjust parameters
- **Code Generation**: Copy ready-to-use SwiftUI code that reflects your customizations
- **Searchable**: Quickly find any component
- **Collapsible Categories**: Organized navigation with expandable sections
- **Comments Toggle**: Choose whether generated code includes explanatory comments

## Components (72)

### Controls (16)
- Button, Toggle, Slider, Stepper, Picker
- DatePicker, ColorPicker, TextField, SecureField, TextEditor
- ProgressView, Gauge, Menu, Link, ShareLink, MultiDatePicker

### Layout (9)
- VStack, HStack, ZStack, Grid (LazyVGrid)
- Spacer, Divider, ViewThatFits, TimelineView, GeometryReader

### Text & Images (4)
- Text, Label, Image, AsyncImage

### Lists & Containers (8)
- List, ScrollView, Form
- TabView, Sheet, Alert
- DisclosureGroup, ContentUnavailableView

### Shapes (5)
- Rectangle, RoundedRectangle, Circle
- Ellipse, Capsule

### Effects (5)
- Shadow, Blur, Rotation
- Opacity, Scale

### Gestures (3)
- TapGesture, LongPressGesture, DragGesture

### Animation (4)
- Animation Curves, withAnimation, Transition, PhaseAnimator

### Modifiers (5)
- Frame, Padding, Background, Overlay, ClipShape

### Navigation (4)
- NavigationLink, Toolbar, NavigationSplitView, NavigationPath

### Drawing (3)
- Path, Canvas, Custom Shape

### Media (2)
- VideoPlayer, PhotosPicker

### Charts (4)
- Bar Chart, Line Chart, Area Chart, Pie Chart

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

### Day 3: Apple Docs MCP in Action

Today I put the Apple Docs MCP server to work. It's a game-changer for discovering APIs and verifying signatures before writing code.

#### The Research Phase

I used `search_framework_symbols` to explore SwiftUI's available views and `get_apple_doc_content` to pull detailed documentation including platform availability. The MCP returned actual code examples from Apple's docs, which I used to ensure my implementations matched the official API signatures.

Key discoveries:
- **MultiDatePicker** - I didn't know this existed! It's different from DatePicker and allows selecting multiple dates.
- **ContentUnavailableView** has a built-in `.search` preset - no need to build custom empty states for search results.
- **ViewThatFits** evaluates children in order and shows the first one that fits - useful for responsive layouts.

#### Batch 1 Complete

Added 4 new components:
1. **Link** - Simple URL navigation. The API is just `Link("Title", destination: url)`.
2. **ShareLink** - Native share sheet with optional subject/message fields.
3. **DisclosureGroup** - Expandable sections with `isExpanded` binding. Supports nesting.
4. **ContentUnavailableView** - iOS 17+ empty states. The built-in `.search` preset is particularly elegant.

#### Batch 2 Complete

Added 4 more components discovered through Apple Docs MCP:
1. **MultiDatePicker** - Select multiple dates (iOS 16+). Different from DatePicker - uses `Set<DateComponents>`.
2. **ViewThatFits** - Responsive layouts that evaluate children in order and show the first one that fits.
3. **TimelineView** - Time-based updates with schedule options (.periodic, .animation, .everyMinute).
4. **GeometryReader** - Access size and position information for custom layouts.

We're now at **50 components** across 7 categories. The XcodeBuild MCP made testing instant - build, run, and screenshot all from the conversation.

### Day 4: Animation Category

Today we added the Animation category - something I'd been looking forward to since we started planning next steps.

#### The New Playgrounds

1. **Animation Curves** - This one is satisfying to play with. You can compare all the timing curves side-by-side: linear, easeIn, easeOut, easeInOut, spring, bouncy, and snappy. Each has a distinct feel - linear is mechanical, spring feels natural, bouncy is playful.

2. **withAnimation** - Demonstrates how to wrap state changes in animation blocks. The playground lets you scale, rotate, and fade a shape with different animation curves.

3. **Transition** - Shows how views can animate as they appear and disappear. Includes slide, opacity, scale, move, push, combined, and asymmetric transitions. The asymmetric option (scale in, fade out) is particularly elegant.

4. **PhaseAnimator** - This iOS 17+ API is powerful for multi-step animations. The playground shows both continuous (loops forever) and triggered (fires on tap) modes. Great for attention-grabbing effects.

#### Technical Note

I initially tried to include `.blurReplace` as a transition type, but discovered it's not available as an `AnyTransition` member in iOS 18.5. Replaced it with `.scale.combined(with: .opacity)` which achieves a similar visual effect.

#### Modifiers Category

Also added the Modifiers category - these are the bread-and-butter modifiers every SwiftUI developer uses daily:

1. **Frame** - Fixed sizing with width/height, or flexible with maxWidth/maxHeight. The alignment picker shows how content sits within the frame.

2. **Padding** - Choose specific edges (horizontal, vertical, or individual) with adjustable amounts. The border toggle helps visualize padding boundaries.

3. **Background** - Three options: solid color, gradient, or material (blur). The rounded shape toggle with corner radius slider shows real-world patterns.

4. **Overlay** - Four practical examples: notification badge, checkmark icon, stroke border, and gradient overlay (great for text on images).

5. **ClipShape** - Mask content to shapes. The circle option is perfect for avatars - something developers reach for constantly.

#### Navigation Category

Finally added proper navigation components - a notable gap we've had since the beginning:

1. **NavigationLink** - The fundamental navigation primitive. Shows three styles: simple text, icon+label, and custom content with subtitles.

2. **Toolbar** - Demonstrates toolbar items with different placements. The principal placement for center items is surprisingly useful.

3. **NavigationSplitView** - Two and three column layouts. Best experienced on iPad, but the playground shows the concept on iPhone too.

4. **NavigationPath** - Programmatic navigation control. The deep linking example shows how to push multiple views at once - essential for handling URLs or notifications.

We're now at **63 components** across **10 categories**.

### Day 5: Drawing Category

Today we added the Drawing category - a natural progression from Shapes, focusing on custom graphics.

#### The New Playgrounds

1. **Path** - The foundation of custom drawing. Demonstrates four path types:
   - Lines (triangle)
   - Curves (quadratic Bezier creating a lens shape)
   - Arc (270-degree arc)
   - Star (calculated using trigonometry)

   Each can be rendered as fill or stroke with adjustable line width and color.

2. **Canvas** - Immediate mode drawing with GraphicsContext. Three demo types show different use cases:
   - Animated particles arranged in a circle with rainbow colors (uses TimelineView)
   - Color bars (spectrum visualization)
   - Checkerboard pattern with alternating squares and circles

3. **Custom Shape** - Shows how to implement the Shape protocol for reusable, resizable graphics:
   - **Polygon** - Any regular polygon (triangle through dodecagon)
   - **HeartShape** - Bezier curves and arcs combined
   - **WaveShape** - Sine wave with filled area below
   - **BadgeShape** - Star-like shape with alternating inner/outer radii

#### Technical Notes

The Shape protocol is elegant - you implement one method `path(in rect: CGRect) -> Path` and SwiftUI handles everything else. The shapes automatically resize, can be filled or stroked, and work with all the standard modifiers.

Canvas is different - it's immediate mode drawing like CoreGraphics. You get a GraphicsContext and draw directly. It's more powerful but less composable. I used TimelineView to animate the particle example, which shows how Canvas can create effects that would be expensive with regular SwiftUI views.

We're now at **66 components** across **11 categories**.

### Day 5 (continued): Media Category

Added the Media category for audio/video playback and photo library access.

#### The New Playgrounds

1. **VideoPlayer** - Plays video from URLs using AVKit. The playground demonstrates:
   - AVPlayer integration with SwiftUI's VideoPlayer view
   - Play/pause/stop controls
   - Seeking to start
   - Multiple sample videos (Big Buck Bunny, Sintel, Tears of Steel)

   Key insight: Create AVPlayer in a `.task` modifier to avoid recreating it on every view update.

2. **PhotosPicker** - Native photo library picker (iOS 16+). Features:
   - Single and multiple selection modes
   - Filter by media type (images, videos, or both)
   - Configurable max selection count
   - Loading selected images via `loadTransferable`

   The SwiftUI PhotosPicker is much simpler than the old PHPickerViewController - just bind to a `PhotosPickerItem` or array of items.

#### Technical Notes

Both components require framework imports beyond SwiftUI:
- VideoPlayer needs `import AVKit`
- PhotosPicker needs `import PhotosUI`

PhotosPicker returns `PhotosPickerItem` which is a placeholder - you load the actual data asynchronously using the Transferable protocol. This keeps the picker fast even with large selections.

We're now at **68 components** across **12 categories**.

### Day 5 (continued): Charts Category

Added the Charts category using Apple's Swift Charts framework (iOS 16+).

#### The New Playgrounds

1. **Bar Chart** - The workhorse of data visualization. Four styles:
   - Vertical bars (classic)
   - Horizontal bars (good for long category names)
   - Stacked bars (comparing parts of a whole)
   - Grouped bars (side-by-side comparison)

   Features corner radius control and gradient fills.

2. **Line Chart** - Perfect for trends over time:
   - Single or multiple series
   - Optional point markers
   - Smooth (Catmull-Rom) or linear interpolation
   - Adjustable line width

3. **Area Chart** - Like line charts but with filled regions:
   - Simple solid fill
   - Gradient fill (fades to transparent)
   - Stacked areas for cumulative data

4. **Pie Chart** - SectorMark for proportional data (iOS 17+):
   - Traditional pie
   - Donut (with inner radius)
   - Adjustable gap between sectors
   - Built-in legend support

#### Technical Notes

Swift Charts uses a declarative syntax that feels very SwiftUI-native. The key types are:
- `Chart` - The container view
- `BarMark`, `LineMark`, `AreaMark`, `PointMark`, `SectorMark` - The visual marks
- `.value("Label", data)` - How you bind data to visual properties

The `.foregroundStyle(by:)` modifier automatically creates legends and assigns colors when you have multiple series. The `.position(by:)` modifier on BarMark creates grouped (side-by-side) bars instead of stacked.

We're now at **72 components** across **13 categories**.

---

*Built with Claude, an AI assistant by Anthropic.*
