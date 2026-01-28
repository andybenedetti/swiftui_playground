import SwiftUI

struct TextPlayground: View {
    @State private var text = "Hello, SwiftUI!"
    @State private var fontDesign = FontDesignOption.default
    @State private var fontWeight = FontWeightOption.regular
    @State private var fontSize: Double = 17
    @State private var foregroundColor = Color.primary
    @State private var isItalic = false
    @State private var isUnderlined = false
    @State private var isStrikethrough = false
    @State private var lineLimit = 0
    @State private var multilineAlignment = TextAlignmentOption.leading

    enum FontDesignOption: String, CaseIterable {
        case `default` = "Default"
        case rounded = "Rounded"
        case serif = "Serif"
        case monospaced = "Monospaced"

        var design: Font.Design {
            switch self {
            case .default: .default
            case .rounded: .rounded
            case .serif: .serif
            case .monospaced: .monospaced
            }
        }
    }

    enum FontWeightOption: String, CaseIterable {
        case ultraLight = "Ultra Light"
        case thin = "Thin"
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case semibold = "Semibold"
        case bold = "Bold"
        case heavy = "Heavy"
        case black = "Black"

        var weight: Font.Weight {
            switch self {
            case .ultraLight: .ultraLight
            case .thin: .thin
            case .light: .light
            case .regular: .regular
            case .medium: .medium
            case .semibold: .semibold
            case .bold: .bold
            case .heavy: .heavy
            case .black: .black
            }
        }
    }

    enum TextAlignmentOption: String, CaseIterable {
        case leading = "Leading"
        case center = "Center"
        case trailing = "Trailing"

        var alignment: TextAlignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "Text",
            description: "A view that displays one or more lines of read-only text.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/text")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        let textView = Text(text)
            .font(.system(size: fontSize, weight: fontWeight.weight, design: fontDesign.design))
            .foregroundStyle(foregroundColor)
            .italic(isItalic)
            .underline(isUnderlined)
            .strikethrough(isStrikethrough)
            .multilineTextAlignment(multilineAlignment.alignment)

        if lineLimit > 0 {
            textView.lineLimit(lineLimit)
        } else {
            textView
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Text", text: $text)

            SliderControl(
                label: "Font Size",
                value: $fontSize,
                range: 10...40,
                format: "%.0f pt"
            )

            ParameterControl(label: "Font Weight") {
                Picker("Weight", selection: $fontWeight) {
                    ForEach(FontWeightOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.menu)
            }

            PickerControl(
                label: "Font Design",
                selection: $fontDesign,
                options: FontDesignOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ColorControl(label: "Color", color: $foregroundColor)

            HStack {
                ToggleControl(label: "Italic", isOn: $isItalic)
                ToggleControl(label: "Underline", isOn: $isUnderlined)
            }

            ToggleControl(label: "Strikethrough", isOn: $isStrikethrough)

            PickerControl(
                label: "Alignment",
                selection: $multilineAlignment,
                options: TextAlignmentOption.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        var code = """
        // Text view
        Text("\(text)")
            .font(.system(size: \(Int(fontSize)), weight: .\(fontWeight.rawValue.lowercased().replacingOccurrences(of: " ", with: "")), design: .\(fontDesign.rawValue.lowercased())))
        """

        if foregroundColor != Color.primary {
            code += "\n    .foregroundStyle(\(colorToCode(foregroundColor)))"
        }

        if isItalic {
            code += "\n    .italic()"
        }

        if isUnderlined {
            code += "\n    .underline()"
        }

        if isStrikethrough {
            code += "\n    .strikethrough()"
        }

        if multilineAlignment != .leading {
            code += "\n    .multilineTextAlignment(.\(multilineAlignment.rawValue.lowercased()))"
        }

        if lineLimit > 0 {
            code += "\n    .lineLimit(\(lineLimit))"
        }

        return code
    }

    private func colorToCode(_ color: Color) -> String {
        if color == .primary { return ".primary" }
        if color == .secondary { return ".secondary" }
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        if color == .green { return ".green" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        TextPlayground()
    }
}
