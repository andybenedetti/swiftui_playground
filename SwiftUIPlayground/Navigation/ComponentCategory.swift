import SwiftUI

enum ComponentCategory: String, CaseIterable, Identifiable {
    case controls = "Controls"
    case layout = "Layout"
    case textAndImages = "Text & Images"
    case listsAndContainers = "Lists & Containers"
    case shapes = "Shapes"
    case effects = "Effects"
    case gestures = "Gestures"
    case animation = "Animation"
    case modifiers = "Modifiers"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .controls: "slider.horizontal.3"
        case .layout: "rectangle.3.group"
        case .textAndImages: "textformat"
        case .listsAndContainers: "list.bullet.rectangle"
        case .shapes: "square.on.circle"
        case .effects: "wand.and.stars"
        case .gestures: "hand.tap"
        case .animation: "play.circle"
        case .modifiers: "paintbrush"
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
                ComponentItem(name: "SecureField", destination: .secureField),
                ComponentItem(name: "TextEditor", destination: .textEditor),
                ComponentItem(name: "ProgressView", destination: .progressView),
                ComponentItem(name: "Gauge", destination: .gauge),
                ComponentItem(name: "Menu", destination: .menu),
                ComponentItem(name: "Link", destination: .link),
                ComponentItem(name: "ShareLink", destination: .shareLink),
                ComponentItem(name: "MultiDatePicker", destination: .multiDatePicker),
            ]
        case .layout:
            [
                ComponentItem(name: "VStack", destination: .vStack),
                ComponentItem(name: "HStack", destination: .hStack),
                ComponentItem(name: "ZStack", destination: .zStack),
                ComponentItem(name: "Grid", destination: .grid),
                ComponentItem(name: "Spacer", destination: .spacer),
                ComponentItem(name: "Divider", destination: .divider),
                ComponentItem(name: "ViewThatFits", destination: .viewThatFits),
                ComponentItem(name: "TimelineView", destination: .timelineView),
                ComponentItem(name: "GeometryReader", destination: .geometryReader),
            ]
        case .textAndImages:
            [
                ComponentItem(name: "Text", destination: .text),
                ComponentItem(name: "Label", destination: .label),
                ComponentItem(name: "Image", destination: .image),
                ComponentItem(name: "AsyncImage", destination: .asyncImage),
            ]
        case .listsAndContainers:
            [
                ComponentItem(name: "List", destination: .list),
                ComponentItem(name: "ScrollView", destination: .scrollView),
                ComponentItem(name: "Form", destination: .form),
                ComponentItem(name: "TabView", destination: .tabView),
                ComponentItem(name: "Sheet", destination: .sheet),
                ComponentItem(name: "Alert", destination: .alert),
                ComponentItem(name: "DisclosureGroup", destination: .disclosureGroup),
                ComponentItem(name: "ContentUnavailableView", destination: .contentUnavailableView),
            ]
        case .shapes:
            [
                ComponentItem(name: "Rectangle", destination: .rectangle),
                ComponentItem(name: "RoundedRectangle", destination: .roundedRectangle),
                ComponentItem(name: "Circle", destination: .circle),
                ComponentItem(name: "Ellipse", destination: .ellipse),
                ComponentItem(name: "Capsule", destination: .capsule),
            ]
        case .effects:
            [
                ComponentItem(name: "Shadow", destination: .shadow),
                ComponentItem(name: "Blur", destination: .blur),
                ComponentItem(name: "Rotation", destination: .rotation),
                ComponentItem(name: "Opacity", destination: .opacity),
                ComponentItem(name: "Scale", destination: .scale),
            ]
        case .gestures:
            [
                ComponentItem(name: "TapGesture", destination: .tapGesture),
                ComponentItem(name: "LongPressGesture", destination: .longPressGesture),
                ComponentItem(name: "DragGesture", destination: .dragGesture),
            ]
        case .animation:
            [
                ComponentItem(name: "Animation Curves", destination: .animationCurves),
                ComponentItem(name: "withAnimation", destination: .withAnimation),
                ComponentItem(name: "Transition", destination: .transition),
                ComponentItem(name: "PhaseAnimator", destination: .phaseAnimator),
            ]
        case .modifiers:
            [
                ComponentItem(name: "Frame", destination: .frame),
                ComponentItem(name: "Padding", destination: .padding),
                ComponentItem(name: "Background", destination: .background),
                ComponentItem(name: "Overlay", destination: .overlay),
                ComponentItem(name: "ClipShape", destination: .clipShape),
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
    case button, toggle, slider, stepper, picker, datePicker, colorPicker, textField, secureField, textEditor, progressView, gauge, menu, link, shareLink, multiDatePicker
    // Layout
    case vStack, hStack, zStack, grid, spacer, divider, viewThatFits, timelineView, geometryReader
    // Text & Images
    case text, label, image, asyncImage
    // Lists & Containers
    case list, scrollView, form, tabView, sheet, alert, disclosureGroup, contentUnavailableView
    // Shapes
    case rectangle, roundedRectangle, circle, ellipse, capsule
    // Effects
    case shadow, blur, rotation, opacity, scale
    // Gestures
    case tapGesture, longPressGesture, dragGesture
    // Animation
    case animationCurves, withAnimation, transition, phaseAnimator
    // Modifiers
    case frame, padding, background, overlay, clipShape
}
