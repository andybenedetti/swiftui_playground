# Quick Reference

## ParameterControl API (Our Custom Controls)

These are defined in `Shared/ParameterControl.swift`. Do NOT confuse with SwiftUI APIs.

```swift
// Text input
TextFieldControl(label: "Label", text: $text)
// NO prompt: parameter!

// Color picker
ColorControl(label: "Color", color: $color)
// It's `color:` NOT `selection:`!

// Slider
SliderControl(label: "Size", value: $size, range: 0...100, format: "%.0f")

// Picker (enum selection)
PickerControl(
    label: "Style",
    selection: $style,
    options: StyleOption.allCases,
    optionLabel: { $0.rawValue }
)

// Toggle
ToggleControl(label: "Enabled", isOn: $isEnabled)
```

## Common Mistakes to Avoid

| Mistake | Correct |
|---------|---------|
| `ColorControl(selection: $color)` | `ColorControl(color: $color)` |
| `TextFieldControl(prompt: "...")` | No prompt parameter exists |
| `SliderControl(value: $cgFloat)` | Use `Binding<Double>`, not `CGFloat` |
| `let x = ...` in @ViewBuilder | Extract to helper function or use expressions |
| `MultiDatePicker(in: start...end)` | Use open range: `start..<end` |

## @ViewBuilder Rules

```swift
// BAD - variable assignment in @ViewBuilder
@ViewBuilder
var content: some View {
    let x = computeValue()  // ERROR
    Text("\(x)")
}

// GOOD - extract to helper
@ViewBuilder
var content: some View {
    Text("\(computedValue)")
}

private var computedValue: Int {
    // computation here
}
```

## SwiftUI API Quick Reference

### Animation
```swift
// Curves with duration
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

// Transitions
.transition(.slide)
.transition(.scale.combined(with: .opacity))
.transition(.asymmetric(insertion: .scale, removal: .opacity))
```

### Charts (Swift Charts)
```swift
import Charts

Chart {
    BarMark(x: .value("Label", item.label), y: .value("Value", item.value))
    LineMark(x: .value("X", item.x), y: .value("Y", item.y))
    AreaMark(x: .value("X", item.x), y: .value("Y", item.y))
    SectorMark(angle: .value("Value", item.value))
}
```

### MapKit (iOS 17+)
```swift
import MapKit

Map {
    Marker("Label", coordinate: coordinate)
    Annotation("Label", coordinate: coordinate) {
        Image(systemName: "star.fill")
    }
}
.mapStyle(.standard)
.mapCameraKeyframeAnimator(trigger: trigger) { camera in
    KeyframeTrack(\.centerCoordinate) { ... }
}
```

### Media
```swift
// VideoPlayer
import AVKit
@State private var player: AVPlayer?
VideoPlayer(player: player)
    .task { player = AVPlayer(url: url) }

// PhotosPicker
import PhotosUI
@State private var selectedItem: PhotosPickerItem?
PhotosPicker(selection: $selectedItem, matching: .images) {
    Label("Select", systemImage: "photo")
}
.onChange(of: selectedItem) { _, item in
    Task {
        if let data = try? await item?.loadTransferable(type: Data.self) {
            image = UIImage(data: data)
        }
    }
}
```

## Documentation Links (Required in every component)

Every component must include a `documentationURL` parameter in its ComponentPage call. This displays a clickable "View Documentation" button that opens the docs in an inline Safari browser.

```swift
var body: some View {
    ComponentPage(
        title: "Button",
        description: "A control that initiates an action.",
        documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/button")!,
        code: generatedCode
    ) {
        previewContent
    } controls: {
        controlsContent
    }
}
```

**URL Pattern**: `https://developer.apple.com/documentation/{framework}/{typename}`

- SwiftUI components: `swiftui/button`, `swiftui/text`, `swiftui/vstack`
- Charts: `charts/barmark`, `charts/linemark`
- MapKit: `mapkit/map`
- AVKit: `avkit/videoplayer`
- PhotosUI: `photokit/photospicker`

## Color to Code Helper

```swift
private func colorToCode(_ color: Color) -> String {
    if color == .blue { return ".blue" }
    if color == .red { return ".red" }
    if color == .green { return ".green" }
    if color == .orange { return ".orange" }
    if color == .purple { return ".purple" }
    if color == .pink { return ".pink" }
    if color == .yellow { return ".yellow" }
    return "Color(...)"
}
```

## pbxproj ID Ranges (for manual editing)

If not using xcodeproj MCP, use these ID ranges:
- Build file IDs: 072-083 (used), next: 084+
- File reference IDs: 170-181 (used), next: 182+
- Group IDs: 417-420 (used), next: 421+
