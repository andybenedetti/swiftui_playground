import SwiftUI

struct ImagePlayground: View {
    @State private var systemImage = "photo.fill"
    @State private var renderingMode = RenderingModeOption.original
    @State private var contentMode = ContentModeOption.fit
    @State private var foregroundColor = Color.blue
    @State private var frameWidth: Double = 100
    @State private var frameHeight: Double = 100
    @State private var cornerRadius: Double = 0
    @State private var isResizable = true

    enum RenderingModeOption: String, CaseIterable {
        case original = "Original"
        case template = "Template"
    }

    enum ContentModeOption: String, CaseIterable {
        case fit = "Fit"
        case fill = "Fill"
    }

    private let commonIcons = [
        "photo.fill", "star.fill", "heart.fill", "person.fill",
        "house.fill", "car.fill", "airplane", "globe",
        "sun.max.fill", "moon.fill", "cloud.fill", "bolt.fill"
    ]

    var body: some View {
        ComponentPage(
            title: "Image",
            description: "A view that displays an image. This example uses SF Symbols.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        imageView
            .frame(width: frameWidth, height: frameHeight)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemGray5))
            )
    }

    @ViewBuilder
    private var imageView: some View {
        if isResizable {
            if renderingMode == .template {
                Image(systemName: systemImage)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: contentMode == .fit ? .fit : .fill)
                    .foregroundStyle(foregroundColor)
            } else {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode == .fit ? .fit : .fill)
            }
        } else {
            if renderingMode == .template {
                Image(systemName: systemImage)
                    .renderingMode(.template)
                    .foregroundStyle(foregroundColor)
                    .font(.system(size: 50))
            } else {
                Image(systemName: systemImage)
                    .font(.system(size: 50))
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ParameterControl(label: "Symbol") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(commonIcons, id: \.self) { icon in
                            Button {
                                systemImage = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .foregroundStyle(systemImage == icon ? .blue : .secondary)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(systemImage == icon ? Color.blue.opacity(0.1) : Color.clear)
                                    )
                            }
                        }
                    }
                }
            }

            TextFieldControl(label: "Custom Symbol", text: $systemImage)

            ToggleControl(label: "Resizable", isOn: $isResizable)

            if isResizable {
                PickerControl(
                    label: "Content Mode",
                    selection: $contentMode,
                    options: ContentModeOption.allCases,
                    optionLabel: { $0.rawValue }
                )

                SliderControl(label: "Width", value: $frameWidth, range: 50...200, format: "%.0f")
                SliderControl(label: "Height", value: $frameHeight, range: 50...200, format: "%.0f")
            }

            PickerControl(
                label: "Rendering Mode",
                selection: $renderingMode,
                options: RenderingModeOption.allCases,
                optionLabel: { $0.rawValue }
            )

            if renderingMode == .template {
                ColorControl(label: "Color", color: $foregroundColor)
            }

            SliderControl(label: "Corner Radius", value: $cornerRadius, range: 0...50, format: "%.0f")
        }
    }

    private var generatedCode: String {
        var code = "// SF Symbol image\n"
        code += "Image(systemName: \"\(systemImage)\")"

        if renderingMode == .template {
            code += "\n    .renderingMode(.template)"
        }

        if isResizable {
            code += "\n    .resizable()"
            code += "\n    .aspectRatio(contentMode: .\(contentMode.rawValue.lowercased()))"
            code += "\n    .frame(width: \(Int(frameWidth)), height: \(Int(frameHeight)))"
        } else {
            code += "\n    .font(.system(size: 50))"
        }

        if renderingMode == .template {
            code += "\n    .foregroundStyle(\(colorToCode(foregroundColor)))"
        }

        if cornerRadius > 0 {
            code += "\n    .clipShape(RoundedRectangle(cornerRadius: \(Int(cornerRadius))))"
        }

        return code
    }

    private func colorToCode(_ color: Color) -> String {
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        if color == .green { return ".green" }
        if color == .orange { return ".orange" }
        if color == .purple { return ".purple" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        ImagePlayground()
    }
}
