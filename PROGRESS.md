# SwiftUI Playground - Progress Tracker

## Project Overview
An interactive iOS app showcasing SwiftUI components with live parameter editing and code generation. Built for developers who want to quickly explore SwiftUI APIs and copy working code.

## Current Status: 63 Components Complete

### Completed
- [x] GitHub repo: https://github.com/andybenedetti/swiftui_playground
- [x] Xcode project structure created manually (no Xcode GUI needed)
- [x] Navigation system with searchable, collapsible component list
- [x] Reusable `ComponentPage` layout (preview + controls + code tabs)
- [x] `CodePreview` with copy functionality and comments toggle (@AppStorage)
- [x] Generic parameter controls (`SliderControl`, `PickerControl`, `ToggleControl`, `ColorControl`, `TextFieldControl`)
- [x] 50 component playgrounds implemented across 7 categories
- [x] Apple Docs MCP server configured (restart Claude Code to activate)

### Component Inventory (63 total)
| Category | Count | Components |
|----------|-------|------------|
| Controls | 16 | Button, Toggle, Slider, Stepper, Picker, DatePicker, ColorPicker, TextField, SecureField, TextEditor, ProgressView, Gauge, Menu, Link, ShareLink, MultiDatePicker |
| Layout | 9 | VStack, HStack, ZStack, Grid, Spacer, Divider, ViewThatFits, TimelineView, GeometryReader |
| Text & Images | 4 | Text, Label, Image, AsyncImage |
| Lists & Containers | 8 | List, ScrollView, Form, TabView, Sheet, Alert, DisclosureGroup, ContentUnavailableView |
| Shapes | 5 | Rectangle, RoundedRectangle, Circle, Ellipse, Capsule |
| Effects | 5 | Shadow, Blur, Rotation, Opacity, Scale |
| Gestures | 3 | TapGesture, LongPressGesture, DragGesture |
| Animation | 4 | Animation Curves, withAnimation, Transition, PhaseAnimator |
| Modifiers | 5 | Frame, Padding, Background, Overlay, ClipShape |
| Navigation | 4 | **NavigationLink**, **Toolbar**, **NavigationSplitView**, **NavigationPath** |

### Architecture Decisions
1. **Navigation**: `NavigationStack` with `searchable` modifier - simple, native, iOS 17+
2. **Collapsible Sections**: Using `Section(isExpanded:)` with custom binding to `Set<ComponentCategory>`
3. **State**: Each playground owns its `@State` - isolated, follows modern-swift.md guidelines
4. **Code Generation**: Computed `generatedCode` property that reflects current state - always accurate
5. **User Preferences**: `@AppStorage("includeComments")` for code comment toggle
6. **Project Structure**: Feature-based organization (Components/Controls/, Components/Layout/, etc.)

### Files Structure
```
SwiftUIPlayground/
├── SwiftUIPlaygroundApp.swift
├── Navigation/
│   ├── ContentView.swift          # Main nav with search + collapsible sections
│   └── ComponentCategory.swift    # Enum for categories + ComponentDestination
├── Shared/
│   ├── ComponentPage.swift        # 3-panel layout: preview, controls tab, code tab
│   ├── CodePreview.swift          # Syntax display + copy button + comments toggle
│   └── ParameterControl.swift     # SliderControl, PickerControl, ToggleControl, ColorControl, TextFieldControl
└── Components/
    ├── Controls/ (16 files)
    ├── Layout/ (9 files)
    ├── TextAndImages/ (4 files)
    ├── ListsAndContainers/ (8 files)
    ├── Shapes/ (5 files)
    ├── Effects/ (5 files)
    ├── Gestures/ (3 files)
    ├── Animation/ (4 files)
    ├── Modifiers/ (5 files)
    └── Navigation/ (4 files)
```

### Next Steps - Ideas for Future Sessions
- [x] **Test the Apple Docs MCP** - ✅ DONE! See findings below
- [x] **Add Animation category** - ✅ DONE! Animation Curves, withAnimation, Transition, PhaseAnimator
- [ ] **Add more Navigation components** - NavigationLink, NavigationSplitView, Toolbar, ToolbarItem
- [ ] **Add Drawing category** - Path, Canvas, custom shapes
- [ ] **Add Accessibility category** - accessibilityLabel, accessibilityHint, VoiceOver examples
- [ ] **Add State Management category** - @State, @Binding, @Observable, @Environment examples
- [ ] **Add Modifiers category** - Common modifiers like .frame, .padding, .background, .overlay
- [ ] **Consider adding a "Favorites" feature** - Let users bookmark frequently used components
- [ ] **Consider adding a "History" feature** - Remember recent parameter configurations
- [ ] **Run on real device** - Test touch interactions, especially gestures

## Apple Docs MCP Test Results (Day 3)

### MCP Tools Verified Working
- `search_framework_symbols` - Browse all symbols in a framework by type/pattern
- `get_apple_doc_content` - Get full documentation with code examples
- `get_documentation_updates` - Track SwiftUI changes
- `includePlatformAnalysis` option - Shows iOS version requirements

### Components Discovered & Verified (Prioritized)

**High Priority - Simple & Useful:**
| Component | iOS | Description | Complexity |
|-----------|-----|-------------|------------|
| `Link` | 14+ | Opens URLs in browser/app | Simple |
| `ShareLink` | 16+ | Native share sheet | Simple |
| `DisclosureGroup` | 14+ | Expandable sections with binding | Simple |
| `ContentUnavailableView` | 17+ | Empty states with `.search` preset | Simple |

**Medium Priority - More Complex but Valuable:**
| Component | iOS | Description | Complexity |
|-----------|-----|-------------|------------|
| `MultiDatePicker` | 16+ | Select multiple dates (NEW discovery!) | Medium |
| `ViewThatFits` | 16+ | Responsive - shows first child that fits | Medium |
| `TimelineView` | 15+ | Time-based updates with schedules | Medium |
| `GeometryReader` | 13+ | Get size/position info | Medium |

**Lower Priority - Requires Additional Setup:**
| Component | iOS | Description | Complexity |
|-----------|-----|-------------|------------|
| `PhotosPicker` | 16+ | Photo library (requires `import PhotosUI`) | Higher |
| `OutlineGroup` | 14+ | Hierarchical data display | Higher |

### Animation APIs Verified
- `Animation` struct: `.linear`, `.easeIn`, `.easeOut`, `.easeInOut`, `.spring`
- `withAnimation(_:_:)` - Wrap state changes
- `.animation(_:value:)` - Modifier for specific value changes
- `AnimationCompletionCriteria` - For completion handlers (iOS 17+)
- `.repeatCount()`, `.repeatForever()` - Animation modifiers

### Key API Signatures Confirmed
```swift
// Link - simple!
Link("View Terms", destination: URL(string: "https://example.com")!)

// ShareLink - also simple
ShareLink(item: URL(string: "https://example.com")!)
ShareLink("Share", item: url) // with custom label

// DisclosureGroup - has isExpanded binding
DisclosureGroup("Settings", isExpanded: $isExpanded) {
    Toggle("Option", isOn: $option)
}

// ContentUnavailableView - has preset!
ContentUnavailableView.search // For empty search results
ContentUnavailableView {
    Label("No Mail", systemImage: "tray.fill")
} description: {
    Text("New mail will appear here.")
}

// ViewThatFits - evaluates children in order
ViewThatFits(in: .horizontal) {
    HStack { /* wide layout */ }
    VStack { /* narrow layout */ }
}

// TimelineView - for animations/clocks
TimelineView(.periodic(from: Date(), by: 1)) { context in
    Text(context.date.formatted())
}
```

### Components I Want to Add (updated & prioritized)
**Batch 1 (Quick Wins): ✅ COMPLETE**
- [x] `Link` - Opens URLs (iOS 14+)
- [x] `ShareLink` - Native share sheet (iOS 16+)
- [x] `DisclosureGroup` - Expandable content (iOS 14+)
- [x] `ContentUnavailableView` - Empty states (iOS 17+)

**Batch 2 (Medium effort): ✅ COMPLETE**
- [x] `MultiDatePicker` - Multiple date selection (iOS 16+)
- [x] `ViewThatFits` - Adaptive layouts (iOS 16+)
- [x] `TimelineView` - Time-based updates (iOS 15+)
- [x] `GeometryReader` - Layout information (iOS 13+)

**Batch 3 (Animation category):**
- Animation curves playground
- withAnimation examples
- Transitions

**Batch 4 (Requires more work):**
- `PhotosPicker` - Photo library access (requires PhotosUI)
- `OutlineGroup` - Hierarchical lists
- `Canvas` - Custom drawing

## MCP Server Setup
Two MCP servers have been added to this project:

### 1. Apple Docs MCP
```bash
claude mcp add apple-docs -- npx -y @kimsungwhee/apple-docs-mcp@latest
```
Provides access to:
- `search_documentation` - Search Apple docs
- `get_api_details` - Get specific API info
- `search_wwdc` - Search WWDC session transcripts
- `get_framework_index` - List all APIs in a framework
- `check_platform_availability` - Version compatibility

### 2. XcodeBuild MCP
```bash
claude mcp add xcodebuild -- npx -y xcodebuildmcp@latest
```
Provides access to:
- Build projects directly (no more parsing xcodebuild output!)
- Run tests
- Manage simulators (list, launch, select)
- Get structured build diagnostics and errors
- Device management

**Requirements**: macOS 14.5+, Xcode 16.x+, Node.js 18.x+

**After restarting Claude Code**, both servers should be available.

## Lessons Learned
1. **Xcode project.pbxproj** - Complex but predictable structure:
   - PBXBuildFile: `{buildFileId} = {fileRef: fileRefId}`
   - PBXFileReference: `{fileRefId} = {path: "FileName.swift"}`
   - PBXGroup: `{groupId} = {children: [fileRefIds]}`
   - PBXSourcesBuildPhase: `files = (buildFileIds)`
   - Must add to ALL FOUR sections for new files

2. **ParameterControl API** (our custom controls, not SwiftUI):
   - `ColorControl(label:color:)` - NOT `selection:`
   - `TextFieldControl(label:text:)` - NO `prompt:` parameter
   - `SliderControl(label:value:range:format:)`
   - `PickerControl(label:selection:options:optionLabel:)`
   - `ToggleControl(label:isOn:)`

3. **@ViewBuilder limitations** - Can't use `let x = ...` variable assignments, must use expressions directly

4. **iOS 17+ features we use**:
   - `Section(isExpanded:)` for collapsible sections
   - Implicit returns in switch expressions
   - Modern `@Observable` macro (though we use @State for simplicity)

5. **Build command** for this machine:
   ```bash
   xcodebuild -scheme SwiftUIPlayground -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' build
   ```

## Mistakes to Avoid
- Don't forget to add new files to project.pbxproj (4 sections!)
- Don't use `selection:` with ColorControl - it's `color:`
- Don't add `prompt:` to TextFieldControl - it doesn't exist
- Don't use variable assignments inside @ViewBuilder blocks
- Don't assume SwiftUI API names match our ParameterControl names

## What I Wish I Had

### Fulfilled Wishes ✅
- ~~**Live preview**~~ - NOW AVAILABLE via XcodeBuild MCP! (`build_run_sim`)
- ~~**Screenshot capability**~~ - NOW AVAILABLE via XcodeBuild MCP! (`screenshot`)
- ~~**Xcode integration**~~ - NOW AVAILABLE via XcodeBuild MCP!
- ~~**Apple Docs access**~~ - NOW AVAILABLE via Apple Docs MCP!

All my original wishes have been granted! The MCP servers provide:
- Build & run apps directly (`build_sim`, `build_run_sim`)
- Take screenshots (`screenshot`)
- UI automation (`tap`, `gesture`, `type_text`)
- Simulator control (`list_sims`, `boot_sim`, `open_sim`)
- Apple documentation lookup (`search_framework_symbols`, `get_apple_doc_content`)

### Current Wishlist (Day 3)

**High Impact:**
1. **Xcode project file automation** - Every new file requires 4 manual edits to `project.pbxproj`. A tool like `add_file_to_project(path)` would eliminate the most error-prone part of my workflow.
   - **Solution found:** [giginet/xcodeproj-mcp-server](https://github.com/giginet/xcodeproj-mcp-server) has `add_file`, `remove_file`, `create_group` tools
   - **Blocker:** Requires Docker (`brew install --cask docker`)
   - **Install command:** `claude mcp add xcodeproj -- docker run --pull=always --rm -i -v $PWD:/workspace ghcr.io/giginet/xcodeproj-mcp-server:latest /workspace`
2. **Swift LSP integration** - No autocomplete or type checking currently. I write code based on training data + Apple Docs, then discover errors at build time. Real LSP would catch issues earlier.
3. **Structured build errors** - When builds fail, parsing error output is messy. Structured JSON with file/line/message would help fix issues faster.

**Medium Impact:**
4. **SwiftUI Preview rendering** - Can run full app but can't render individual `#Preview` blocks. Would speed up iteration on single components.
5. **Test result parsing** - Can run tests but structured pass/fail with failure details would help.

**Nice to Have:**
6. **Asset catalog editing** - Can't easily add images/colors to `Assets.xcassets`
7. **Session memory** - Each conversation starts fresh. The progress.md helps, but deeper project memory would be useful.

## Git History (key commits)
- Initial 20 components
- Added collapsible sections
- Added ProgressView, Gauge, Menu (+3)
- Added TabView, Sheet, Alert (+3)
- Added AsyncImage, Divider, Spacer (+3)
- Added Effects category: Shadow, Blur, Rotation (+3)
- Added SecureField, TextEditor, RoundedRectangle, Ellipse, Capsule, Opacity, Scale (+7)
- Added Gestures category: TapGesture, LongPressGesture, DragGesture (+3)
- Day 3: Apple Docs MCP test + Batch 1 (Link, ShareLink, DisclosureGroup, ContentUnavailableView) (+4)
- Day 3: Batch 2 (MultiDatePicker, ViewThatFits, TimelineView, GeometryReader) (+4)

## Session Notes - Day 3

### What We Accomplished
1. **Tested Apple Docs MCP** - Works great for discovering APIs and verifying signatures
2. **Added Batch 1** - Link, ShareLink, DisclosureGroup, ContentUnavailableView
3. **Added Batch 2** - MultiDatePicker, ViewThatFits, TimelineView, GeometryReader
4. **Component count**: 42 → 50 (+8 components)
5. **Identified productivity improvement** - Found giginet/xcodeproj-mcp-server for pbxproj automation (needs Docker)

### XcodeBuild MCP Workflow
The development loop is now:
1. Write Swift files
2. Update ComponentCategory.swift (add items + destinations)
3. Update ContentView.swift (add cases)
4. Update project.pbxproj (4 places per file - still manual)
5. `build_sim` to compile
6. `build_run_sim` to launch
7. `screenshot` + `tap`/`gesture` to verify

### Common Build Errors Fixed This Session
- `Binding<CGFloat>` vs `Binding<Double>` - SliderControl expects Double
- `ClosedRange<Date>` vs `Range<Date>` - MultiDatePicker uses open range (..<)
- ViewBuilder variable assignments - Can't use `let x = ...` in @ViewBuilder, extract to helper function

### Next Session Ideas
- **Drawing category** - Path, Canvas, custom shapes
- **Accessibility category** - accessibilityLabel, accessibilityHint, VoiceOver examples
- **State Management examples** - @State, @Binding, @Observable, @Environment patterns
- Install Docker and add xcodeproj-mcp-server for automated pbxproj editing

## Session Notes - Day 4

### What We Accomplished
1. **Updated README.md** - Synced Day 3 documentation to reflect 50 components
2. **Added Animation category** - 4 new playgrounds:
   - **Animation Curves** - Compare .linear, .easeIn, .easeOut, .spring, .bouncy, .snappy
   - **withAnimation** - Demonstrate withAnimation wrapper for state changes
   - **Transition** - View transitions (.slide, .opacity, .scale, .move, .push, .combined, .asymmetric)
   - **PhaseAnimator** - iOS 17+ multi-step animations with continuous and triggered modes
3. **Component count**: 50 → 54 (+4 components)
4. **Category count**: 7 → 8 (+Animation)

### Animation APIs Used
```swift
// Animation curves with duration
.linear(duration: 1.0)
.easeIn(duration: 1.0)
.easeOut(duration: 1.0)
.easeInOut(duration: 1.0)
.spring(duration: 1.0)
.bouncy(duration: 1.0)
.snappy(duration: 1.0)

// withAnimation wrapper
withAnimation(.spring(duration: 0.5)) {
    scale = 1.5
}

// View transitions
.transition(.slide)
.transition(.scale.combined(with: .opacity))
.transition(.asymmetric(insertion: .scale, removal: .opacity))

// PhaseAnimator (iOS 17+)
PhaseAnimator(Phase.allCases) { phase in
    content.scaleEffect(phase.scale)
} animation: { phase in
    .easeInOut(duration: 0.4)
}
```

### Build Issue Fixed
- `.blurReplace` transition is not available as `AnyTransition` member
- Replaced with `.scale.combined(with: .opacity)` which achieves similar visual effect

### Modifiers Category Added
Added 5 more playgrounds for common view modifiers:
- **Frame** - Fixed and flexible sizing with alignment options
- **Padding** - Edge-specific padding with amount control
- **Background** - Color, gradient, and material backgrounds with shapes
- **Overlay** - Badge, icon, border, and gradient overlays
- **ClipShape** - Mask views to shapes (Circle, RoundedRectangle, Capsule, etc.)

**Component count**: 54 → 59 (+5 components)
**Category count**: 8 → 9 (+Modifiers)

### Navigation Category Added
Added 4 playgrounds for navigation patterns:
- **NavigationLink** - Value-based navigation with text, icon+label, and custom content styles
- **Toolbar** - Toolbar items with placement options (topBarLeading, topBarTrailing, bottomBar, principal)
- **NavigationSplitView** - Two and three column layouts for iPad
- **NavigationPath** - Programmatic navigation with push, pop, and deep linking

**Component count**: 59 → 63 (+4 components)
**Category count**: 9 → 10 (+Navigation)
