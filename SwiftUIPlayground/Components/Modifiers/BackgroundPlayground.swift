import SwiftUI

struct BackgroundPlayground: View {
    @State private var backgroundType = BackgroundType.color
    @State private var selectedColor: Color = .blue
    @State private var cornerRadius: Double = 12
    @State private var useShape = true

    enum BackgroundType: String, CaseIterable {
        case color = "Color"
        case gradient = "Gradient"
        case material = "Material"
    }

    var body: some View {
        ComponentPage(
            title: "Background",
            description: "Adds a background behind the view.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/background(_:in:fillstyle:)")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack {
            switch backgroundType {
            case .color:
                Text("Hello, SwiftUI!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(selectedColor, in: RoundedRectangle(cornerRadius: useShape ? cornerRadius : 0))
            case .gradient:
                Text("Hello, SwiftUI!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [selectedColor, selectedColor.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: useShape ? cornerRadius : 0)
                    )
            case .material:
                Text("Hello, SwiftUI!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: useShape ? cornerRadius : 0))
            }
        }
        .frame(height: 150)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Type",
                selection: $backgroundType,
                options: BackgroundType.allCases,
                optionLabel: { $0.rawValue }
            )

            if backgroundType != .material {
                ColorControl(label: "Color", color: $selectedColor)
            }

            ToggleControl(label: "Rounded Shape", isOn: $useShape)

            if useShape {
                SliderControl(
                    label: "Corner Radius",
                    value: $cornerRadius,
                    range: 0...30,
                    format: "%.0f"
                )
            }
        }
    }

    private var generatedCode: String {
        let shapeCode = useShape ? "RoundedRectangle(cornerRadius: \(Int(cornerRadius)))" : "Rectangle()"

        switch backgroundType {
        case .color:
            return """
            // Solid color background
            Text("Hello, SwiftUI!")
                .padding()
                .background(.\(colorName(selectedColor)), in: \(shapeCode))
            """
        case .gradient:
            return """
            // Gradient background
            Text("Hello, SwiftUI!")
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: \(shapeCode)
                )
            """
        case .material:
            return """
            // Material background (blur effect)
            Text("Hello, SwiftUI!")
                .padding()
                .background(.ultraThinMaterial, in: \(shapeCode))
            """
        }
    }

    private func colorName(_ color: Color) -> String {
        switch color {
        case .blue: return "blue"
        case .red: return "red"
        case .green: return "green"
        case .orange: return "orange"
        case .purple: return "purple"
        case .pink: return "pink"
        case .yellow: return "yellow"
        default: return "blue"
        }
    }
}

#Preview {
    NavigationStack {
        BackgroundPlayground()
    }
}
