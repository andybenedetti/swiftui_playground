# Tool Workflows

## MCP Servers Available

| Server | Purpose | Key Tools |
|--------|---------|-----------|
| **xcodebuild** | Build, run, test, simulator control | `build_sim`, `build_run_sim`, `screenshot`, `tap`, `gesture` |
| **apple-docs** | Apple documentation lookup | `search_framework_symbols`, `get_apple_doc_content` |
| **xcodeproj** | Xcode project file manipulation | `add_file`, `remove_file`, `create_group` |
| **swiftlens** | Swift LSP / code analysis | `swift_analyze_file`, `swift_validate_file`, `swift_get_hover_info` |
| **xcode-diagnostics** | Structured build errors | `get_xcode_projects`, `get_project_diagnostics` |

## Development Workflow

### Adding a New Component

```
1. Write Swift file
   └─> SwiftUIPlayground/Components/{Category}/{Name}Playground.swift

2. Update navigation
   └─> ComponentCategory.swift (add item + destination)

3. Add to project (use xcodeproj MCP)
   └─> add_file tool

4. Validate code (use swiftlens MCP)
   └─> swift_validate_file tool

5. Build
   └─> build_sim tool

6. If build fails, get structured errors
   └─> get_project_diagnostics tool

7. Run and test
   └─> build_run_sim tool
   └─> screenshot tool
   └─> tap / gesture tools for interaction
```

### Debugging Build Failures

```
1. Run build
   └─> build_sim

2. If failure, get structured diagnostics
   └─> get_project_diagnostics
   └─> Returns: file path, line number, error message, fix-it suggestions

3. Fix the identified issues

4. Rebuild and verify
```

### Looking Up SwiftUI APIs

```
1. Search for symbols in a framework
   └─> search_framework_symbols(framework: "swiftui", namePattern: "*View")

2. Get detailed documentation
   └─> get_apple_doc_content(url: "https://developer.apple.com/documentation/...")

3. Check platform availability
   └─> includePlatformAnalysis: true option
```

## Simulator Commands

```
# List available simulators
list_sims

# Boot a simulator
boot_sim

# Open Simulator app
open_sim

# Build and run
build_run_sim

# Take screenshot
screenshot

# UI interactions
tap(x: 100, y: 200)
gesture(preset: "scroll-down")
type_text(text: "Hello")
```

## Build Commands (Manual Fallback)

If MCP tools aren't available:

```bash
# Build for simulator
xcodebuild -scheme SwiftUIPlayground \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' \
  build

# Clean build
xcodebuild -scheme SwiftUIPlayground clean

# Run tests
xcodebuild -scheme SwiftUIPlayground \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' \
  test
```

## Session Setup Defaults

At start of session, set xcodebuild MCP defaults:

```
session-set-defaults:
  - workspacePath or projectPath
  - scheme: "SwiftUIPlayground"
  - simulatorName: "iPhone 16"
  - useLatestOS: true
```

## Tool Decision Guide

| Task | Tool to Use |
|------|-------------|
| Build the app | `build_sim` (xcodebuild MCP) |
| Run the app | `build_run_sim` (xcodebuild MCP) |
| Add file to project | `add_file` (xcodeproj MCP) |
| Check Swift code for errors | `swift_validate_file` (swiftlens MCP) |
| Get build error details | `get_project_diagnostics` (xcode-diagnostics MCP) |
| Look up SwiftUI API | `search_framework_symbols` (apple-docs MCP) |
| Take screenshot | `screenshot` (xcodebuild MCP) |
| Test UI interaction | `tap`, `gesture` (xcodebuild MCP) |

## MCP Server Installation Commands

For reference, here's how each server was installed:

```bash
# Apple Docs
claude mcp add apple-docs -- npx -y @kimsungwhee/apple-docs-mcp@latest

# XcodeBuild
claude mcp add xcodebuild -- npx -y xcodebuildmcp@latest

# xcodeproj (requires Docker)
claude mcp add xcodeproj -- docker run --pull=always --rm -i \
  -v "$PWD:/workspace" ghcr.io/giginet/xcodeproj-mcp-server:latest /workspace

# SwiftLens (requires uv/uvx)
claude mcp add swiftlens -- uvx swiftlens

# Xcode Diagnostics
pip3 install git+https://github.com/leftspin/mcp-xcode-diagnostics.git
claude mcp add xcode-diagnostics -- python3 -m mcp_xcode_diagnostics
```
