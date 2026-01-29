# SwiftUI + Claude Code: Complete Setup Guide

How to set up Claude Code for efficient SwiftUI/iOS 17+ development on any Xcode project, starting from a blank directory.

---

## 1. Prerequisites

On the Mac, you need:
- **Xcode** (with iOS Simulator runtimes installed)
- **Claude Code** CLI (`claude`)
- **Node.js / npm** (for MCP servers that use npx)
- **Docker** (for xcodeproj MCP server)
- **Python 3 + pip** (for xcode-diagnostics MCP server)
- **uv** (for swiftlens MCP server — install via `brew install uv`)

## 2. MCP Server Setup

These five MCP servers give Claude full Xcode development capability. Run each command once:

```bash
# 1. xcodebuild — Build, run, test, simulator control, UI interaction
#    The primary tool for compiling and interacting with the app
claude mcp add xcodebuild -- npx -y xcodebuildmcp@latest

# 2. xcodeproj — Xcode project file manipulation
#    Add/remove files, targets, groups, build settings, SPM packages
#    Eliminates manual pbxproj editing
claude mcp add xcodeproj -- docker run --pull=always --rm -i \
  -v "$PWD:/workspace" ghcr.io/giginet/xcodeproj-mcp-server:latest /workspace

# 3. apple-docs — Apple Developer Documentation
#    Search frameworks, read API docs, check platform availability
claude mcp add apple-docs -- npx -y @kimsungwhee/apple-docs-mcp@latest

# 4. swiftlens — Swift code analysis
#    Validate Swift files before building (catch errors early)
claude mcp add swiftlens -- uvx swiftlens

# 5. xcode-diagnostics — Structured build errors
#    Get file paths, line numbers, and fix-it suggestions from build failures
pip3 install git+https://github.com/leftspin/mcp-xcode-diagnostics.git
claude mcp add xcode-diagnostics -- python3 -m mcp_xcode_diagnostics
```

### What Each Server Does

| Server | Key Tools | Use When |
|--------|-----------|----------|
| **xcodebuild** | `build_sim`, `build_run_sim`, `test_sim`, `screenshot`, `tap`, `gesture`, `describe_ui`, `type_text` | Building, running, testing, and interacting with the simulator |
| **xcodeproj** | `add_file`, `add_target`, `create_group`, `set_build_setting`, `add_swift_package` | Modifying the Xcode project structure |
| **apple-docs** | `search_framework_symbols`, `get_apple_doc_content`, `search_apple_docs` | Looking up SwiftUI APIs and documentation |
| **swiftlens** | `swift_validate_file` | Checking Swift code for errors before building |
| **xcode-diagnostics** | `get_project_diagnostics` | Getting structured error details after a build failure |

## 3. Session Startup

At the start of every session, set up the xcodebuild MCP session defaults. This tells the build tools which project, scheme, and simulator to use:

```
# Step 1: Discover the project
mcp__xcodebuild__discover_projs(workspaceRoot: "/path/to/project")

# Step 2: Set session defaults
mcp__xcodebuild__session-set-defaults(
    projectPath: "/path/to/Project.xcodeproj",  # or workspacePath for .xcworkspace
    scheme: "YourScheme",
    simulatorId: "SIMULATOR-UUID"                # get from list_sims
)
```

To find available simulators:
```
mcp__xcodebuild__list_sims()
```

Pick one and use its UUID for `simulatorId`. Avoid `simulatorName` + `useLatestOS` when multiple OS versions are installed — using the UUID directly is more reliable.

## 4. Core Workflows

### Build
```
mcp__xcodebuild__build_sim()
```

### Build and Run
```
mcp__xcodebuild__build_run_sim()
```
This builds the app and launches it in the simulator.

### Take a Screenshot
```
mcp__xcodebuild__screenshot()
```
Returns the simulator screen as an image you can see directly.

### Interact with the Simulator
```
# Get precise element coordinates (always do this before tapping)
mcp__xcodebuild__describe_ui()

# Tap at coordinates or by accessibility label
mcp__xcodebuild__tap(x: 196, y: 400)

# Scroll, swipe
mcp__xcodebuild__gesture(preset: "scroll-down")

# Type text (tap a text field first)
mcp__xcodebuild__type_text(text: "Hello world")
```

**Important**: Always call `describe_ui` before `tap` to get accurate coordinates. Never guess coordinates from screenshots.

### Run Tests
```
# Run all tests
mcp__xcodebuild__test_sim()

# Run a specific test
mcp__xcodebuild__test_sim(
    extraArgs: ["-only-testing:TargetName/TestClass/testMethod"]
)
```

### Debug Build Failures
```
# Step 1: Build fails
mcp__xcodebuild__build_sim()  # returns error

# Step 2: Get structured diagnostics (optional — build output usually sufficient)
mcp__xcode-diagnostics__get_project_diagnostics()
```

## 5. Project Management via xcodeproj MCP

Never edit `project.pbxproj` by hand. Use the xcodeproj MCP server:

### Add a File to the Project
```
mcp__xcodeproj__add_file(
    project_path: "Project.xcodeproj",
    file_path: "Sources/NewFile.swift",
    target_name: "MyApp",
    group_name: "Sources"
)
```

### Create a Group (Folder Reference)
```
mcp__xcodeproj__create_group(
    project_path: "Project.xcodeproj",
    group_name: "NewFolder",
    path: "NewFolder",          # creates a real directory mapping
    parent_group: "Sources"
)
```

### Add a Target
```
mcp__xcodeproj__add_target(
    project_path: "Project.xcodeproj",
    target_name: "MyAppTests",
    product_type: "unitTestBundle",
    bundle_identifier: "com.example.app.tests"
)
```

### Set Build Settings
```
mcp__xcodeproj__set_build_setting(
    project_path: "Project.xcodeproj",
    target_name: "MyAppTests",
    configuration: "All",
    setting_name: "TEST_HOST",
    setting_value: "$(BUILT_PRODUCTS_DIR)/MyApp.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/MyApp"
)
```

### Add Swift Package Dependencies
```
mcp__xcodeproj__add_swift_package(
    project_path: "Project.xcodeproj",
    package_url: "https://github.com/org/package",
    requirement: "from: 1.0.0",
    target_name: "MyApp"
)
```

### Important xcodeproj Limitation

The `add_target` tool does not create a `productReference` for new targets. For unit test targets, you must manually add three things to `project.pbxproj`:

1. A `PBXFileReference` for the `.xctest` product:
```
ID /* Target.xctest */ = {isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = Target.xctest; sourceTree = BUILT_PRODUCTS_DIR; };
```

2. Add it to the `Products` PBXGroup's `children` array

3. Add `productReference = ID;` to the `PBXNativeTarget` entry

Also add the test target to the scheme's `<Testables>` section in the `.xcscheme` file for `xcodebuild test` to find it.

## 6. Preview Rendering with ImageRenderer

For verifying SwiftUI views without navigating through the full app, set up an ImageRenderer-based test target:

### Setup

1. Create a test target (see Section 5) hosted in the app
2. Set `TEST_HOST`, `BUNDLE_LOADER`, `GENERATE_INFOPLIST_FILE = YES`
3. Add dependency on the app target
4. Add to the scheme's `<Testables>`

### PreviewRenderer Utility
```swift
import SwiftUI
import UIKit

@MainActor
enum PreviewRenderer {
    nonisolated static let defaultSize = CGSize(width: 393, height: 852)
    nonisolated static let defaultScale: CGFloat = 2.0
    nonisolated static let defaultOutputPath = "/tmp/swiftui_preview.png"

    @discardableResult
    static func renderToFile<V: View>(
        _ view: V,
        size: CGSize = defaultSize,
        scale: CGFloat = defaultScale,
        outputPath: String = defaultOutputPath
    ) -> Bool {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = scale
        guard let data = renderer.uiImage?.pngData() else { return false }
        do {
            try data.write(to: URL(fileURLWithPath: outputPath))
            return true
        } catch { return false }
    }
}
```

### Test File
```swift
import XCTest
import SwiftUI
@testable import YourApp

final class PreviewRenderTests: XCTestCase {
    @MainActor
    func testRenderPreview() throws {
        // Change this to render any view
        let view = NavigationStack { SomeView() }
        let success = PreviewRenderer.renderToFile(view)
        XCTAssertTrue(success)
    }
}
```

### Workflow
```
# 1. Edit the test to specify which view to render
# 2. Run the test
mcp__xcodebuild__test_sim(
    extraArgs: ["-only-testing:AppTests/PreviewRenderTests/testRenderPreview"]
)
# 3. Read the rendered image
Read("/tmp/swiftui_preview.png")
```

**Key details**:
- `ImageRenderer` requires iOS 16+ (use `@MainActor` on the enum and test method)
- Use `nonisolated` on static let constants to avoid Swift 6 warnings when used as default parameter values
- Size 393x852 = iPhone 16 screen in points; scale 2.0 = retina output
- Views using async loading (AsyncImage, Maps) render their immediate state only

## 7. Apple Docs Integration

Look up any Apple API during development:

```
# Search for symbols
mcp__apple-docs__search_framework_symbols(framework: "swiftui", namePattern: "*View")

# Read full documentation
mcp__apple-docs__get_apple_doc_content(
    url: "https://developer.apple.com/documentation/swiftui/button"
)

# Search broadly
mcp__apple-docs__search_apple_docs(query: "NavigationStack")

# Check platform availability
mcp__apple-docs__get_platform_compatibility(
    apiUrl: "https://developer.apple.com/documentation/swiftui/list"
)
```

URL pattern: `https://developer.apple.com/documentation/{framework}/{typename}`

## 8. Memory System

For multi-session projects, maintain context across sessions with markdown files in `.claude/` and the project root:

| File | Purpose |
|------|---------|
| `PROGRESS.md` | Current status, inventory, session notes — read every session start |
| `.claude/QUICK_REF.md` | API signatures that are easy to get wrong, common mistakes |
| `.claude/TEMPLATES.md` | Copy-paste templates, step-by-step checklists |
| `.claude/TOOL_WORKFLOWS.md` | MCP server inventory, when to use each tool |
| `.claude/ARCHITECTURE.md` | Project structure, file locations, key decisions |

**Session startup checklist** (add to `CLAUDE.md`):
1. Read `PROGRESS.md` — what was done last session, what's next
2. Skim `QUICK_REF.md` — refresh on APIs that are easy to get wrong
3. Set xcodebuild session defaults (project, scheme, simulator)

**After completing work**:
1. Update `PROGRESS.md` with what was accomplished
2. If you made a mistake worth remembering, add it to `QUICK_REF.md`

## 9. Lessons Learned

### Simulator Selection
- Use `simulatorId` (UUID) rather than `simulatorName` + `useLatestOS`. When multiple OS versions are installed, name-based matching can fail.
- Get the UUID from `list_sims` and set it once at session start.

### xcodeproj MCP Gaps
- `add_target` doesn't create a `productReference` — you must add it manually to pbxproj (see Section 5).
- `add_target` creates an `INFOPLIST_FILE` setting pointing to a non-existent plist. Set `GENERATE_INFOPLIST_FILE = YES` and remove the `INFOPLIST_FILE` entry.
- Always verify with `list_targets` after adding a new target.

### Scheme Configuration
- New test targets are not automatically added to the scheme's test action. Edit the `.xcscheme` XML to add a `<TestableReference>` with the target's `BlueprintIdentifier` from pbxproj.

### ImageRenderer
- Static `let` constants on a `@MainActor` type produce Swift 6 warnings when used as default parameters. Mark them `nonisolated`.
- `ImageRenderer` captures the view's immediate state — async content (remote images, map tiles) won't be loaded.
- Wrap views in `NavigationStack` if they expect a navigation context.

### Build Performance
- The xcodebuild MCP has an incremental build system. For iterative development, `build_sim` reuses previous build artifacts automatically.
- Use `preferXcodebuild: true` if the incremental system has issues.

### UI Testing via Simulator
- Always call `describe_ui` before `tap` — it returns exact frame coordinates for all accessibility elements.
- Never guess coordinates from screenshots; the coordinate spaces differ.
- `tap(label:)` works when the accessibility label exactly matches (including commas and counts).

### Asset Catalogs
- No special tooling needed. Asset catalogs are directories with `Contents.json` files. Create them with `mkdir` + `Write`.
- Color set: `Assets.xcassets/ColorName.colorset/Contents.json`
- Image set: `Assets.xcassets/ImageName.imageset/Contents.json`

### Swift Code Style
- Follow `modern-swift.md` conventions: SwiftUI-first, `@State` for local state, `@Observable` for shared state, `async/await` over Combine, feature-based file organization.
- Avoid unnecessary ViewModels, abstraction layers, or patterns from other platforms.
