import SwiftUI

struct CapsulePlayground: View {
    @State private var width: Double = 200
    @State private var height: Double = 60
    @State private var fillColor: Color = .blue
    @State private var strokeWidth: Double = 0
    @State private var strokeColor: Color = .primary
    @State private var style = CapsuleStyleOption.circular

    enum CapsuleStyleOption: String, CaseIterable {
        case circular = "Circular"
        case continuous = "Continuous"

        var style: RoundedCornerStyle {
            switch self {
            case .circular: .circular
            case .continuous: .continuous
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "Capsule",
            description: "A capsule shape aligned inside the frame of the view containing it.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/capsule")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        if strokeWidth > 0 {
            Capsule(style: style.style)
                .fill(fillColor)
                .overlay(
                    Capsule(style: style.style)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                )
                .frame(width: width, height: height)
        } else {
            Capsule(style: style.style)
                .fill(fillColor)
                .frame(width: width, height: height)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Width",
                value: $width,
                range: 50...300,
                format: "%.0f"
            )

            SliderControl(
                label: "Height",
                value: $height,
                range: 20...200,
                format: "%.0f"
            )

            ColorControl(label: "Fill Color", color: $fillColor)

            PickerControl(
                label: "Style",
                selection: $style,
                options: CapsuleStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Stroke Width",
                value: $strokeWidth,
                range: 0...10,
                format: "%.1f"
            )

            if strokeWidth > 0 {
                ColorControl(label: "Stroke Color", color: $strokeColor)
            }
        }
    }

    private var generatedCode: String {
        var code = "// Capsule shape\n"

        if style == .continuous {
            code += "Capsule(style: .continuous)\n"
        } else {
            code += "Capsule()\n"
        }

        code += "    .fill(.\(fillColor.description))"

        if strokeWidth > 0 {
            code += "\n    .overlay(\n"
            if style == .continuous {
                code += "        Capsule(style: .continuous)\n"
            } else {
                code += "        Capsule()\n"
            }
            code += "            .stroke(.\(strokeColor.description), lineWidth: \(String(format: "%.1f", strokeWidth)))\n    )"
        }

        code += "\n    .frame(width: \(Int(width)), height: \(Int(height)))"
        return code
    }
}

#Preview {
    NavigationStack {
        CapsulePlayground()
    }
}
