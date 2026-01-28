import SwiftUI

enum ComponentCategory: String, CaseIterable, Identifiable {
    case controls = "Controls"
    case layout = "Layout"
    case textAndImages = "Text & Images"
    case listsAndContainers = "Lists & Containers"
    case shapes = "Shapes"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .controls: "slider.horizontal.3"
        case .layout: "rectangle.3.group"
        case .textAndImages: "textformat"
        case .listsAndContainers: "list.bullet.rectangle"
        case .shapes: "square.on.circle"
        }
    }

    var components: [ComponentItem] {
        switch self {
        case .controls:
            [
                ComponentItem(name: "Button", destination: .button),
                ComponentItem(name: "Toggle", destination: .toggle),
                ComponentItem(name: "Slider", destination: .slider),
                ComponentItem(name: "Stepper", destination: .stepper),
                ComponentItem(name: "Picker", destination: .picker),
                ComponentItem(name: "DatePicker", destination: .datePicker),
                ComponentItem(name: "ColorPicker", destination: .colorPicker),
                ComponentItem(name: "TextField", destination: .textField),
                ComponentItem(name: "ProgressView", destination: .progressView),
                ComponentItem(name: "Gauge", destination: .gauge),
                ComponentItem(name: "Menu", destination: .menu),
            ]
        case .layout:
            [
                ComponentItem(name: "VStack", destination: .vStack),
                ComponentItem(name: "HStack", destination: .hStack),
                ComponentItem(name: "ZStack", destination: .zStack),
                ComponentItem(name: "Grid", destination: .grid),
            ]
        case .textAndImages:
            [
                ComponentItem(name: "Text", destination: .text),
                ComponentItem(name: "Label", destination: .label),
                ComponentItem(name: "Image", destination: .image),
            ]
        case .listsAndContainers:
            [
                ComponentItem(name: "List", destination: .list),
                ComponentItem(name: "ScrollView", destination: .scrollView),
                ComponentItem(name: "Form", destination: .form),
            ]
        case .shapes:
            [
                ComponentItem(name: "Rectangle", destination: .rectangle),
                ComponentItem(name: "Circle", destination: .circle),
            ]
        }
    }
}

struct ComponentItem: Identifiable, Hashable {
    let name: String
    let destination: ComponentDestination

    var id: String { name }
}

enum ComponentDestination: Hashable {
    // Controls
    case button, toggle, slider, stepper, picker, datePicker, colorPicker, textField, progressView, gauge, menu
    // Layout
    case vStack, hStack, zStack, grid
    // Text & Images
    case text, label, image
    // Lists & Containers
    case list, scrollView, form
    // Shapes
    case rectangle, circle
}
