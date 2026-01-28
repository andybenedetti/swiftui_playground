# SwiftUI Playground - Progress Tracker

## Project Overview
An interactive iOS app showcasing SwiftUI components with live parameter editing and code generation. Built for developers who want to quickly explore SwiftUI APIs and copy working code.

## Current Status: 42 Components Complete

### Completed
- [x] GitHub repo: https://github.com/andybenedetti/swiftui_playground
- [x] Xcode project structure created manually (no Xcode GUI needed)
- [x] Navigation system with searchable, collapsible component list
- [x] Reusable `ComponentPage` layout (preview + controls + code tabs)
- [x] `CodePreview` with copy functionality and comments toggle (@AppStorage)
- [x] Generic parameter controls (`SliderControl`, `PickerControl`, `ToggleControl`, `ColorControl`, `TextFieldControl`)
- [x] 42 component playgrounds implemented across 7 categories
- [x] Apple Docs MCP server configured (restart Claude Code to activate)

### Component Inventory (42 total)
| Category | Count | Components |
|----------|-------|------------|
| Controls | 13 | Button, Toggle, Slider, Stepper, Picker, DatePicker, ColorPicker, TextField, SecureField, TextEditor, ProgressView, Gauge, Menu |
| Layout | 6 | VStack, HStack, ZStack, Grid, Spacer, Divider |
| Text & Images | 4 | Text, Label, Image, AsyncImage |
| Lists & Containers | 6 | List, ScrollView, Form, TabView, Sheet, Alert |
| Shapes | 5 | Rectangle, RoundedRectangle, Circle, Ellipse, Capsule |
| Effects | 5 | Shadow, Blur, Rotation, Opacity, Scale |
| Gestures | 3 | TapGesture, LongPressGesture, DragGesture |

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
    ├── Controls/ (13 files)
    ├── Layout/ (6 files)
    ├── TextAndImages/ (4 files)
    ├── ListsAndContainers/ (6 files)
    ├── Shapes/ (5 files)
    ├── Effects/ (5 files)
    └── Gestures/ (3 files)
```

### Next Steps - Ideas for Future Sessions
- [ ] **Test the Apple Docs MCP** - use it to discover new components and verify API signatures
- [ ] **Add Animation category** - withAnimation, Animation curves, transitions, matchedGeometryEffect
- [ ] **Add more Navigation components** - NavigationLink, NavigationSplitView, Toolbar, ToolbarItem
- [ ] **Add Drawing category** - Path, Canvas, custom shapes
- [ ] **Add Accessibility category** - accessibilityLabel, accessibilityHint, VoiceOver examples
- [ ] **Add State Management category** - @State, @Binding, @Observable, @Environment examples
- [ ] **Add Modifiers category** - Common modifiers like .frame, .padding, .background, .overlay
- [ ] **Consider adding a "Favorites" feature** - Let users bookmark frequently used components
- [ ] **Consider adding a "History" feature** - Remember recent parameter configurations
- [ ] **Run on real device** - Test touch interactions, especially gestures

### Components I Want to Add (discovered while building)
- `Link` - Opens URLs
- `ShareLink` - Native share sheet
- `PhotosPicker` - Photo library access
- `DisclosureGroup` - Expandable content
- `OutlineGroup` - Hierarchical lists
- `TimelineView` - Time-based updates
- `Canvas` - Custom drawing
- `GeometryReader` - Layout information
- `ViewThatFits` - Adaptive layouts
- `ContentUnavailableView` - Empty states (iOS 17+)
- `Inspector` - Side panel (iOS 17+)

## MCP Server Setup
Apple Docs MCP has been added to this project:
```bash
claude mcp add apple-docs -- npx -y @kimsungwhee/apple-docs-mcp@latest
```
**After restarting Claude Code**, I should have access to:
- `search_documentation` - Search Apple docs
- `get_api_details` - Get specific API info
- `search_wwdc` - Search WWDC session transcripts
- `get_framework_index` - List all APIs in a framework
- `check_platform_availability` - Version compatibility

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
- **Live preview** - Would love to see the app running without manual simulator launch
- **Xcode integration** - Direct access to build warnings/errors without parsing xcodebuild output
- **Screenshot capability** - To show the user what components look like
- **Apple Docs access** - NOW AVAILABLE via MCP! Test after restart.

## Git History (key commits)
- Initial 20 components
- Added collapsible sections
- Added ProgressView, Gauge, Menu (+3)
- Added TabView, Sheet, Alert (+3)
- Added AsyncImage, Divider, Spacer (+3)
- Added Effects category: Shadow, Blur, Rotation (+3)
- Added SecureField, TextEditor, RoundedRectangle, Ellipse, Capsule, Opacity, Scale (+7)
- Added Gestures category: TapGesture, LongPressGesture, DragGesture (+3)
