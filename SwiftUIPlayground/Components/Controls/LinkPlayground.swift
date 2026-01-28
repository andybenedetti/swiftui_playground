import SwiftUI

struct LinkPlayground: View {
    @State private var linkText = "Visit Apple"
    @State private var urlString = "https://apple.com"
    @State private var tintColor = Color.blue
    @State private var fontWeight = FontWeightOption.regular

    enum FontWeightOption: String, CaseIterable {
        case regular = "Regular"
        case medium = "Medium"
        case semibold = "Semibold"
        case bold = "Bold"

        var weight: Font.Weight {
            switch self {
            case .regular: .regular
            case .medium: .medium
            case .semibold: .semibold
            case .bold: .bold
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "Link",
            description: "A control for navigating to a URL.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            if let url = URL(string: urlString) {
                Link(linkText, destination: url)
                    .font(.body.weight(fontWeight.weight))
                    .tint(tintColor)
            } else {
                Text("Invalid URL")
                    .foregroundStyle(.secondary)
            }

            Text("Tapping opens in Safari or associated app")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Link Text", text: $linkText)

            TextFieldControl(label: "URL", text: $urlString)

            PickerControl(
                label: "Font Weight",
                selection: $fontWeight,
                options: FontWeightOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ColorControl(label: "Tint Color", color: $tintColor)
        }
    }

    private var generatedCode: String {
        var code = """
        // Link opens URL in Safari or associated app
        Link("\(linkText)", destination: URL(string: "\(urlString)")!)
        """

        if fontWeight != .regular {
            code += "\n    .font(.body.weight(.\(fontWeight.rawValue.lowercased())))"
        }

        if tintColor != .blue {
            code += "\n    .tint(\(colorToCode(tintColor)))"
        }

        return code
    }

    private func colorToCode(_ color: Color) -> String {
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        if color == .green { return ".green" }
        if color == .orange { return ".orange" }
        if color == .purple { return ".purple" }
        if color == .pink { return ".pink" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        LinkPlayground()
    }
}
