import SwiftUI

struct LabelStylePlayground: View {
    // MARK: - State
    @State private var selectedStyle = LabelStyleOption.automatic
    @State private var title = "Settings"
    @State private var icon = "gear"
    @State private var tintColor: Color = .blue

    enum LabelStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case titleOnly = "Title Only"
        case iconOnly = "Icon Only"
        case titleAndIcon = "Title and Icon"
        case vertical = "Vertical (Custom)"
        case badge = "Badge (Custom)"
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "LabelStyle",
            description: "Built-in and custom LabelStyle implementations. Labels combine a title and icon, with styles controlling their layout and appearance.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/labelstyle")!,
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
        VStack(spacing: 20) {
            switch selectedStyle {
            case .automatic:
                Label(title, systemImage: icon)
                    .labelStyle(.automatic)
                    .font(.title2)
                    .foregroundStyle(tintColor)
            case .titleOnly:
                Label(title, systemImage: icon)
                    .labelStyle(.titleOnly)
                    .font(.title2)
                    .foregroundStyle(tintColor)
            case .iconOnly:
                Label(title, systemImage: icon)
                    .labelStyle(.iconOnly)
                    .font(.title2)
                    .foregroundStyle(tintColor)
            case .titleAndIcon:
                Label(title, systemImage: icon)
                    .labelStyle(.titleAndIcon)
                    .font(.title2)
                    .foregroundStyle(tintColor)
            case .vertical:
                Label(title, systemImage: icon)
                    .labelStyle(VerticalLabelStyle(color: tintColor))
                    .font(.title2)
            case .badge:
                Label(title, systemImage: icon)
                    .labelStyle(BadgeLabelStyle(color: tintColor))
            }

            Text("Style: \(selectedStyle.rawValue)")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $selectedStyle,
                options: LabelStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            TextFieldControl(label: "Title", text: $title)

            PickerControl(
                label: "Icon",
                selection: $icon,
                options: ["gear", "star.fill", "heart.fill", "bell.fill", "person.fill", "folder.fill"],
                optionLabel: { $0 }
            )

            ColorControl(label: "Tint Color", color: $tintColor)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        switch selectedStyle {
        case .automatic:
            return """
            Label("\(title)", systemImage: "\(icon)")
                .labelStyle(.automatic)
            """
        case .titleOnly:
            return """
            Label("\(title)", systemImage: "\(icon)")
                .labelStyle(.titleOnly)
            """
        case .iconOnly:
            return """
            Label("\(title)", systemImage: "\(icon)")
                .labelStyle(.iconOnly)
            """
        case .titleAndIcon:
            return """
            Label("\(title)", systemImage: "\(icon)")
                .labelStyle(.titleAndIcon)
            """
        case .vertical:
            return """
            struct VerticalLabelStyle: LabelStyle {
                var color: Color = .blue

                func makeBody(configuration: Configuration) -> some View {
                    VStack(spacing: 8) {
                        configuration.icon
                            .font(.largeTitle)
                            .foregroundStyle(color)
                        configuration.title
                            .font(.caption)
                    }
                }
            }

            Label("\(title)", systemImage: "\(icon)")
                .labelStyle(VerticalLabelStyle())
            """
        case .badge:
            return """
            struct BadgeLabelStyle: LabelStyle {
                var color: Color = .blue

                func makeBody(configuration: Configuration) -> some View {
                    HStack(spacing: 8) {
                        configuration.icon
                            .padding(8)
                            .background(color.opacity(0.15), in: Circle())
                            .foregroundStyle(color)
                        configuration.title
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(color.opacity(0.08), in: Capsule())
                }
            }

            Label("\(title)", systemImage: "\(icon)")
                .labelStyle(BadgeLabelStyle())
            """
        }
    }
}

// MARK: - Custom Label Styles

struct VerticalLabelStyle: LabelStyle {
    var color: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 8) {
            configuration.icon
                .font(.largeTitle)
                .foregroundStyle(color)
            configuration.title
                .font(.caption)
        }
    }
}

struct BadgeLabelStyle: LabelStyle {
    var color: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
                .padding(8)
                .background(color.opacity(0.15), in: Circle())
                .foregroundStyle(color)
            configuration.title
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.08), in: Capsule())
    }
}

#Preview {
    NavigationStack {
        LabelStylePlayground()
    }
}
