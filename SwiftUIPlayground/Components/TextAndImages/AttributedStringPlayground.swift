import SwiftUI

struct AttributedStringPlayground: View {
    // MARK: - State
    @State private var useBold = true
    @State private var useColor = true
    @State private var useStrikethrough = false
    @State private var useUnderline = false
    @State private var fontSize: Double = 20
    @State private var foregroundColor: Color = .blue

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "AttributedString",
            description: "A string with associated attributes for rich text styling such as font, color, strikethrough, and links.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/foundation/attributedstring")!,
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
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Styled Text")
                    .font(.headline)
                Text(styledAttributedString)
            }

            VStack(spacing: 8) {
                Text("Combined Attributes")
                    .font(.headline)
                Text(combinedAttributedString)
            }

            VStack(spacing: 8) {
                Text("With Link")
                    .font(.headline)
                Text(linkAttributedString)
            }
        }
        .padding()
    }

    private var styledAttributedString: AttributedString {
        var str = AttributedString("Hello, SwiftUI!")
        str.font = .system(size: fontSize)
        if useBold {
            str.font = .system(size: fontSize, weight: .bold)
        }
        if useColor {
            str.foregroundColor = foregroundColor
        }
        if useStrikethrough {
            str.strikethroughStyle = .single
        }
        if useUnderline {
            str.underlineStyle = .single
        }
        return str
    }

    private var combinedAttributedString: AttributedString {
        var hello = AttributedString("Hello ")
        hello.font = .system(size: 18, weight: .light)
        hello.foregroundColor = .secondary

        var world = AttributedString("World")
        world.font = .system(size: 24, weight: .bold)
        world.foregroundColor = .blue

        var excl = AttributedString("!")
        excl.font = .system(size: 24, weight: .bold)
        excl.foregroundColor = .red

        return hello + world + excl
    }

    private var linkAttributedString: AttributedString {
        var str = AttributedString("Visit Apple Developer")
        str.link = URL(string: "https://developer.apple.com")
        str.font = .body
        return str
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(label: "Font Size", value: $fontSize, range: 12...40, format: "%.0f pt")
            ToggleControl(label: "Bold", isOn: $useBold)
            ToggleControl(label: "Custom Color", isOn: $useColor)
            if useColor {
                ColorControl(label: "Color", color: $foregroundColor)
            }
            ToggleControl(label: "Strikethrough", isOn: $useStrikethrough)
            ToggleControl(label: "Underline", isOn: $useUnderline)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        var lines = [
            "var str = AttributedString(\"Hello, SwiftUI!\")",
        ]

        if useBold {
            lines.append("str.font = .system(size: \(Int(fontSize)), weight: .bold)")
        } else {
            lines.append("str.font = .system(size: \(Int(fontSize)))")
        }

        if useColor {
            lines.append("str.foregroundColor = .blue")
        }

        if useStrikethrough {
            lines.append("str.strikethroughStyle = .single")
        }

        if useUnderline {
            lines.append("str.underlineStyle = .single")
        }

        lines.append("\nText(str)")

        return lines.joined(separator: "\n")
    }
}

#Preview {
    NavigationStack {
        AttributedStringPlayground()
    }
}
