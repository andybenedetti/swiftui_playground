# Templates

## Component Playground Template

Copy this template when creating a new component playground:

```swift
import SwiftUI

struct {ComponentName}Playground: View {
    // MARK: - State
    @State private var exampleProperty = "default"
    @State private var isEnabled = true

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "{Component Name}",
            description: "Brief description of the component.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/{componentname}")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        // The live preview of the component
        Text("Preview here")
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Property", text: $exampleProperty)
            ToggleControl(label: "Enabled", isOn: $isEnabled)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        var code = """
        Text("Example")
        """

        if !isEnabled {
            code += "\n.disabled(true)"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        {ComponentName}Playground()
    }
}
```

## Adding a New Component - Checklist

### Step 1: Create the playground file
- [ ] Create `SwiftUIPlayground/Components/{Category}/{ComponentName}Playground.swift`
- [ ] Use the template above
- [ ] Implement `previewContent`, `controlsContent`, and `generatedCode`
- [ ] Add `documentationURL` parameter with official Apple documentation URL

### Step 2: Update ComponentCategory.swift
```swift
// In ComponentCategory enum, add to the appropriate category's items:
case .controls:
    return [
        // ... existing items ...
        .init(name: "{Component Name}", destination: .{componentName})  // ADD THIS
    ]

// In ComponentDestination enum:
enum ComponentDestination: String, Hashable {
    // ... existing cases ...
    case {componentName}  // ADD THIS
}

// In destination view switch:
@ViewBuilder
static func destination(for destination: ComponentDestination) -> some View {
    switch destination {
    // ... existing cases ...
    case .{componentName}:
        {ComponentName}Playground()  // ADD THIS
    }
}
```

### Step 3: Add file to project (choose one method)

**Option A: Use xcodeproj MCP (preferred)**
```
// Use the add_file tool from xcodeproj MCP server
```

**Option B: Manual pbxproj edit (4 places)**
1. PBXBuildFile section - add build file reference
2. PBXFileReference section - add file reference
3. PBXGroup section - add to appropriate Components/{Category} group
4. PBXSourcesBuildPhase - add to files list

### Step 4: Build and test
```bash
# Using xcodebuild MCP:
build_sim
build_run_sim
screenshot
```

## Adding a New Category - Checklist

### Step 1: Create the folder
- [ ] Create `SwiftUIPlayground/Components/{NewCategory}/`

### Step 2: Update ComponentCategory.swift
```swift
// Add new case to ComponentCategory enum:
enum ComponentCategory: String, CaseIterable {
    // ... existing cases ...
    case newCategory = "New Category"  // ADD THIS
}

// Add items for the new category:
var items: [ComponentItem] {
    switch self {
    // ... existing cases ...
    case .newCategory:
        return [
            .init(name: "First Component", destination: .firstComponent),
        ]
    }
}
```

### Step 3: Add category group to pbxproj
- Add PBXGroup for the new category folder
- Add group reference to parent Components group

### Step 4: Create component playgrounds
- Follow "Adding a New Component" checklist for each

## Enum Pattern for Options

When a component has multiple style/type options:

```swift
enum StyleOption: String, CaseIterable {
    case option1 = "Option 1"
    case option2 = "Option 2"
    case option3 = "Option 3"

    // If SwiftUI type differs from display name:
    var swiftUIValue: SomeSwiftUIType {
        switch self {
        case .option1: .value1
        case .option2: .value2
        case .option3: .value3
        }
    }
}

// Usage in controls:
PickerControl(
    label: "Style",
    selection: $selectedStyle,
    options: StyleOption.allCases,
    optionLabel: { $0.rawValue }
)

// Usage in preview:
SomeView()
    .modifier(selectedStyle.swiftUIValue)
```
