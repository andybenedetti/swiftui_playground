import SwiftUI

enum ComponentCategory: String, CaseIterable, Identifiable {
    case accessibility = "Accessibility"
    case animation = "Animation"
    case charts = "Charts"
    case containers = "Containers"
    case controls = "Controls"
    case dataFlow = "Data Flow"
    case drawing = "Drawing"
    case effects = "Effects"
    case focusKeyboard = "Focus & Keyboard"
    case gestures = "Gestures"
    case images = "Images"
    case layout = "Layout"
    case lists = "Lists"
    case maps = "Maps"
    case media = "Media"
    case modifiers = "Modifiers"
    case navigation = "Navigation"
    case shapes = "Shapes"
    case text = "Text"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .accessibility: "accessibility"
        case .animation: "play.circle"
        case .charts: "chart.bar.xaxis"
        case .containers: "square.stack"
        case .controls: "slider.horizontal.3"
        case .dataFlow: "arrow.triangle.2.circlepath"
        case .drawing: "pencil.and.outline"
        case .effects: "wand.and.stars"
        case .focusKeyboard: "keyboard"
        case .gestures: "hand.tap"
        case .images: "photo"
        case .layout: "rectangle.3.group"
        case .lists: "list.bullet.rectangle"
        case .maps: "map"
        case .media: "play.rectangle"
        case .modifiers: "paintbrush"
        case .navigation: "arrow.triangle.turn.up.right.diamond"
        case .shapes: "square.on.circle"
        case .text: "textformat"
        }
    }

    var components: [ComponentItem] {
        switch self {
        case .accessibility:
            [
                ComponentItem(name: "accessibilityLabel", destination: .accessibilityLabel),
                ComponentItem(name: "accessibilityHint", destination: .accessibilityHint),
                ComponentItem(name: "accessibilityValue", destination: .accessibilityValue),
                ComponentItem(name: "Dynamic Type", destination: .dynamicType),
                ComponentItem(name: "VoiceOver", destination: .voiceOver),
            ]
        case .animation:
            [
                ComponentItem(name: "Animation Curves", destination: .animationCurves),
                ComponentItem(name: "withAnimation", destination: .withAnimation),
                ComponentItem(name: "Transition", destination: .transition),
                ComponentItem(name: "PhaseAnimator", destination: .phaseAnimator),
            ]
        case .charts:
            [
                ComponentItem(name: "Bar Chart", destination: .barChart),
                ComponentItem(name: "Line Chart", destination: .lineChart),
                ComponentItem(name: "Area Chart", destination: .areaChart),
                ComponentItem(name: "Pie Chart", destination: .pieChart),
            ]
        case .containers:
            [
                ComponentItem(name: "Form", destination: .form),
                ComponentItem(name: "TabView", destination: .tabView),
                ComponentItem(name: "Sheet", destination: .sheet),
                ComponentItem(name: "Alert", destination: .alert),
                ComponentItem(name: "DisclosureGroup", destination: .disclosureGroup),
                ComponentItem(name: "ContentUnavailableView", destination: .contentUnavailableView),
            ]
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
        case .dataFlow:
            [
                ComponentItem(name: "@AppStorage", destination: .appStorage),
                ComponentItem(name: "@Binding", destination: .binding),
                ComponentItem(name: "@Environment", destination: .environment),
                ComponentItem(name: "@Observable", destination: .observable),
                ComponentItem(name: "@State", destination: .state),
            ]
        case .drawing:
            [
                ComponentItem(name: "Path", destination: .path),
                ComponentItem(name: "Canvas", destination: .canvas),
                ComponentItem(name: "Custom Shape", destination: .customShape),
            ]
        case .effects:
            [
                ComponentItem(name: "Shadow", destination: .shadow),
                ComponentItem(name: "Blur", destination: .blur),
                ComponentItem(name: "Rotation", destination: .rotation),
                ComponentItem(name: "Opacity", destination: .opacity),
                ComponentItem(name: "Scale", destination: .scale),
            ]
        case .focusKeyboard:
            [
                ComponentItem(name: "@FocusState", destination: .focusState),
                ComponentItem(name: "Keyboard Toolbar", destination: .keyboardToolbar),
                ComponentItem(name: "Submit Actions", destination: .submitActions),
            ]
        case .gestures:
            [
                ComponentItem(name: "TapGesture", destination: .tapGesture),
                ComponentItem(name: "LongPressGesture", destination: .longPressGesture),
                ComponentItem(name: "DragGesture", destination: .dragGesture),
                ComponentItem(name: "MagnifyGesture", destination: .magnifyGesture),
                ComponentItem(name: "RotateGesture", destination: .rotateGesture),
            ]
        case .images:
            [
                ComponentItem(name: "Image", destination: .image),
                ComponentItem(name: "AsyncImage", destination: .asyncImage),
                ComponentItem(name: "SF Symbols", destination: .sfSymbols),
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
        case .lists:
            [
                ComponentItem(name: "List", destination: .list),
                ComponentItem(name: "ScrollView", destination: .scrollView),
                ComponentItem(name: "ForEach", destination: .forEach),
                ComponentItem(name: "ScrollViewReader", destination: .scrollViewReader),
            ]
        case .maps:
            [
                ComponentItem(name: "Map Basics", destination: .mapBasics),
                ComponentItem(name: "Map Markers", destination: .mapMarkers),
                ComponentItem(name: "Map Camera", destination: .mapCamera),
            ]
        case .media:
            [
                ComponentItem(name: "VideoPlayer", destination: .videoPlayer),
                ComponentItem(name: "PhotosPicker", destination: .photosPicker),
            ]
        case .modifiers:
            [
                ComponentItem(name: "Frame", destination: .frame),
                ComponentItem(name: "Padding", destination: .padding),
                ComponentItem(name: "Background", destination: .background),
                ComponentItem(name: "Overlay", destination: .overlay),
                ComponentItem(name: "ClipShape", destination: .clipShape),
            ]
        case .navigation:
            [
                ComponentItem(name: "NavigationLink", destination: .navigationLink),
                ComponentItem(name: "Toolbar", destination: .toolbar),
                ComponentItem(name: "NavigationSplitView", destination: .navigationSplitView),
                ComponentItem(name: "NavigationPath", destination: .navigationPath),
            ]
        case .shapes:
            [
                ComponentItem(name: "Rectangle", destination: .rectangle),
                ComponentItem(name: "RoundedRectangle", destination: .roundedRectangle),
                ComponentItem(name: "Circle", destination: .circle),
                ComponentItem(name: "Ellipse", destination: .ellipse),
                ComponentItem(name: "Capsule", destination: .capsule),
            ]
        case .text:
            [
                ComponentItem(name: "Text", destination: .text),
                ComponentItem(name: "Label", destination: .label),
                ComponentItem(name: "AttributedString", destination: .attributedString),
                ComponentItem(name: "Markdown", destination: .markdown),
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
    // Accessibility
    case accessibilityLabel, accessibilityHint, accessibilityValue, dynamicType, voiceOver
    // Animation
    case animationCurves, withAnimation, transition, phaseAnimator
    // Charts
    case barChart, lineChart, areaChart, pieChart
    // Containers
    case form, tabView, sheet, alert, disclosureGroup, contentUnavailableView
    // Controls
    case button, toggle, slider, stepper, picker, datePicker, colorPicker, textField, secureField, textEditor, progressView, gauge, menu, link, shareLink, multiDatePicker
    // Data Flow
    case appStorage, binding, environment, observable, state
    // Drawing
    case path, canvas, customShape
    // Effects
    case shadow, blur, rotation, opacity, scale
    // Focus & Keyboard
    case focusState, keyboardToolbar, submitActions
    // Gestures
    case tapGesture, longPressGesture, dragGesture, magnifyGesture, rotateGesture
    // Images
    case image, asyncImage, sfSymbols
    // Layout
    case vStack, hStack, zStack, grid, spacer, divider, viewThatFits, timelineView, geometryReader
    // Lists
    case list, scrollView, forEach, scrollViewReader
    // Maps
    case mapBasics, mapMarkers, mapCamera
    // Media
    case videoPlayer, photosPicker
    // Modifiers
    case frame, padding, background, overlay, clipShape
    // Navigation
    case navigationLink, toolbar, navigationSplitView, navigationPath
    // Shapes
    case rectangle, roundedRectangle, circle, ellipse, capsule
    // Text
    case text, label, attributedString, markdown
}
