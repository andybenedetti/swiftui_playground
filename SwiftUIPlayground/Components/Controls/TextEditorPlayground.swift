import SwiftUI

struct TextEditorPlayground: View {
    @State private var text = "Enter your text here...\n\nTextEditor supports multiple lines of text input."
    @State private var lineLimit: Double = 5
    @State private var usesLineLimit = false
    @State private var scrollDisabled = false
    @State private var showBorder = true
    @State private var font = FontOption.body

    enum FontOption: String, CaseIterable {
        case body = "Body"
        case caption = "Caption"
        case headline = "Headline"
        case monospaced = "Monospaced"

        var fontStyle: Font {
            switch self {
            case .body: .body
            case .caption: .caption
            case .headline: .headline
            case .monospaced: .system(.body, design: .monospaced)
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "TextEditor",
            description: "A view that can display and edit long-form text.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 8) {
            textEditor
                .frame(width: 280, height: 150)

            Text("\(text.count) characters")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var textEditor: some View {
        let editor = TextEditor(text: $text)
            .font(font.fontStyle)
            .scrollDisabled(scrollDisabled)

        if showBorder {
            if usesLineLimit {
                editor
                    .lineLimit(Int(lineLimit))
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            } else {
                editor
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
        } else {
            if usesLineLimit {
                editor
                    .lineLimit(Int(lineLimit))
            } else {
                editor
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Font",
                selection: $font,
                options: FontOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Use Line Limit", isOn: $usesLineLimit)

            if usesLineLimit {
                SliderControl(
                    label: "Line Limit",
                    value: $lineLimit,
                    range: 1...10,
                    format: "%.0f"
                )
            }

            ToggleControl(label: "Scroll Disabled", isOn: $scrollDisabled)

            ToggleControl(label: "Show Border", isOn: $showBorder)

            Text("TextEditor is ideal for multi-line text input like notes or comments.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        var code = """
        // Multi-line text editor
        @State private var text = ""

        TextEditor(text: $text)
        """

        if font != .body {
            if font == .monospaced {
                code += "\n    .font(.system(.body, design: .monospaced))"
            } else {
                code += "\n    .font(.\(font.rawValue.lowercased()))"
            }
        }

        if usesLineLimit {
            code += "\n    .lineLimit(\(Int(lineLimit)))"
        }

        if scrollDisabled {
            code += "\n    .scrollDisabled(true)"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        TextEditorPlayground()
    }
}
