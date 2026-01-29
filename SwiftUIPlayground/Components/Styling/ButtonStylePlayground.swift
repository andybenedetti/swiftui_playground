import SwiftUI

struct ButtonStylePlayground: View {
    // MARK: - State
    @State private var selectedStyle = ButtonStyleOption.automatic
    @State private var tintColor: Color = .blue
    @State private var cornerRadius: Double = 12
    @State private var isPressedDemo = false

    enum ButtonStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case bordered = "Bordered"
        case borderedProminent = "Bordered Prominent"
        case borderless = "Borderless"
        case plain = "Plain"
        case capsule = "Capsule (Custom)"
        case gradient = "Gradient (Custom)"
        case bouncy = "Bouncy (Custom)"
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "ButtonStyle",
            description: "Built-in and custom ButtonStyle implementations. Custom styles use the makeBody(configuration:) protocol method to define appearance and interaction behavior.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/buttonstyle")!,
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
        VStack(spacing: 16) {
            switch selectedStyle {
            case .automatic:
                Button("Automatic Style") {}
                    .buttonStyle(.automatic)
            case .bordered:
                Button("Bordered Style") {}
                    .buttonStyle(.bordered)
                    .tint(tintColor)
            case .borderedProminent:
                Button("Bordered Prominent") {}
                    .buttonStyle(.borderedProminent)
                    .tint(tintColor)
            case .borderless:
                Button("Borderless Style") {}
                    .buttonStyle(.borderless)
                    .tint(tintColor)
            case .plain:
                Button("Plain Style") {}
                    .buttonStyle(.plain)
            case .capsule:
                Button("Capsule Button") {}
                    .buttonStyle(CapsuleButtonStyle(color: tintColor))
            case .gradient:
                Button("Gradient Button") {}
                    .buttonStyle(GradientButtonStyle(color: tintColor, cornerRadius: cornerRadius))
            case .bouncy:
                Button("Bouncy Button") {}
                    .buttonStyle(BouncyButtonStyle(color: tintColor, cornerRadius: cornerRadius))
            }

            Text("Tap the button to see interaction")
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
                options: ButtonStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ColorControl(label: "Tint Color", color: $tintColor)

            if selectedStyle == .gradient || selectedStyle == .bouncy {
                SliderControl(label: "Corner Radius", value: $cornerRadius, range: 0...30, format: "%.0f")
            }
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        switch selectedStyle {
        case .automatic:
            return """
            Button("Tap Me") { }
                .buttonStyle(.automatic)
            """
        case .bordered:
            return """
            Button("Tap Me") { }
                .buttonStyle(.bordered)
                .tint(.blue)
            """
        case .borderedProminent:
            return """
            Button("Tap Me") { }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            """
        case .borderless:
            return """
            Button("Tap Me") { }
                .buttonStyle(.borderless)
            """
        case .plain:
            return """
            Button("Tap Me") { }
                .buttonStyle(.plain)
            """
        case .capsule:
            return """
            struct CapsuleButtonStyle: ButtonStyle {
                var color: Color = .blue

                func makeBody(configuration: Configuration) -> some View {
                    configuration.label
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(color)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .opacity(configuration.isPressed ? 0.7 : 1)
                }
            }

            Button("Tap Me") { }
                .buttonStyle(CapsuleButtonStyle())
            """
        case .gradient:
            return """
            struct GradientButtonStyle: ButtonStyle {
                var color: Color = .blue
                var cornerRadius: Double = \(Int(cornerRadius))

                func makeBody(configuration: Configuration) -> some View {
                    configuration.label
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .scaleEffect(configuration.isPressed ? 0.95 : 1)
                        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
                }
            }
            """
        case .bouncy:
            return """
            struct BouncyButtonStyle: ButtonStyle {
                var color: Color = .blue
                var cornerRadius: Double = \(Int(cornerRadius))

                func makeBody(configuration: Configuration) -> some View {
                    configuration.label
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(color)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .scaleEffect(configuration.isPressed ? 0.85 : 1)
                        .animation(.spring(duration: 0.3, bounce: 0.5), value: configuration.isPressed)
                }
            }
            """
        }
    }
}

// MARK: - Custom Button Styles

struct CapsuleButtonStyle: ButtonStyle {
    var color: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct GradientButtonStyle: ButtonStyle {
    var color: Color = .blue
    var cornerRadius: Double = 12

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct BouncyButtonStyle: ButtonStyle {
    var color: Color = .blue
    var cornerRadius: Double = 12

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .animation(.spring(duration: 0.3, bounce: 0.5), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        ButtonStylePlayground()
    }
}
