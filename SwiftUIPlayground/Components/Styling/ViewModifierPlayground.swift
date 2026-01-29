import SwiftUI

struct ViewModifierPlayground: View {
    // MARK: - State
    @State private var selectedModifier = ModifierOption.card
    @State private var cardCornerRadius: Double = 16
    @State private var cardShadowRadius: Double = 8
    @State private var glowColor: Color = .blue
    @State private var glowRadius: Double = 10
    @State private var badgeText = "NEW"
    @State private var badgeColor: Color = .red
    @State private var shakeAmount: Double = 5
    @State private var isShaking = false

    enum ModifierOption: String, CaseIterable {
        case card = "Card"
        case glow = "Glow"
        case badge = "Badge"
        case shake = "Shake"
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "ViewModifier",
            description: "Create reusable custom ViewModifier structs with the body(content:) method. Extend View with convenience methods for clean call sites.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/viewmodifier")!,
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
        switch selectedModifier {
        case .card:
            VStack(spacing: 12) {
                Image(systemName: "doc.text.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                Text("Card Modifier")
                    .font(.headline)
                Text("Adds padding, background, corner radius, and shadow")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .modifier(CardModifier(cornerRadius: cardCornerRadius, shadowRadius: cardShadowRadius))

        case .glow:
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(glowColor)
                .modifier(GlowModifier(color: glowColor, radius: glowRadius))

        case .badge:
            HStack(spacing: 20) {
                Image(systemName: "bell.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                    .modifier(BadgeModifier(text: badgeText, color: badgeColor))

                Image(systemName: "envelope.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .modifier(BadgeModifier(text: "3", color: .red))
            }

        case .shake:
            Button {
                withAnimation(.default) {
                    isShaking = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isShaking = false
                }
            } label: {
                Label("Tap to Shake", systemImage: "exclamationmark.triangle")
                    .font(.headline)
                    .padding()
                    .background(.orange.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
            }
            .modifier(ShakeModifier(amount: shakeAmount, isShaking: isShaking))
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Modifier",
                selection: $selectedModifier,
                options: ModifierOption.allCases,
                optionLabel: { $0.rawValue }
            )

            switch selectedModifier {
            case .card:
                SliderControl(label: "Corner Radius", value: $cardCornerRadius, range: 0...30, format: "%.0f")
                SliderControl(label: "Shadow Radius", value: $cardShadowRadius, range: 0...20, format: "%.0f")
            case .glow:
                ColorControl(label: "Glow Color", color: $glowColor)
                SliderControl(label: "Glow Radius", value: $glowRadius, range: 0...30, format: "%.0f")
            case .badge:
                TextFieldControl(label: "Badge Text", text: $badgeText)
                ColorControl(label: "Badge Color", color: $badgeColor)
            case .shake:
                SliderControl(label: "Shake Amount", value: $shakeAmount, range: 1...15, format: "%.0f")
            }
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        switch selectedModifier {
        case .card:
            return """
            struct CardModifier: ViewModifier {
                var cornerRadius: Double = \(Int(cardCornerRadius))
                var shadowRadius: Double = \(Int(cardShadowRadius))

                func body(content: Content) -> some View {
                    content
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: cornerRadius))
                        .shadow(color: .black.opacity(0.1), radius: shadowRadius, y: 4)
                }
            }

            extension View {
                func cardStyle(cornerRadius: Double = 16, shadow: Double = 8) -> some View {
                    modifier(CardModifier(cornerRadius: cornerRadius, shadowRadius: shadow))
                }
            }

            // Usage
            Text("Content")
                .cardStyle()
            """
        case .glow:
            return """
            struct GlowModifier: ViewModifier {
                var color: Color = .blue
                var radius: Double = \(Int(glowRadius))

                func body(content: Content) -> some View {
                    content
                        .shadow(color: color.opacity(0.6), radius: radius)
                        .shadow(color: color.opacity(0.3), radius: radius * 2)
                }
            }

            extension View {
                func glow(color: Color = .blue, radius: Double = 10) -> some View {
                    modifier(GlowModifier(color: color, radius: radius))
                }
            }

            // Usage
            Image(systemName: "sparkles")
                .glow(color: .blue)
            """
        case .badge:
            return """
            struct BadgeModifier: ViewModifier {
                var text: String
                var color: Color = .red

                func body(content: Content) -> some View {
                    content.overlay(alignment: .topTrailing) {
                        Text(text)
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(color, in: Capsule())
                            .offset(x: 8, y: -8)
                    }
                }
            }

            extension View {
                func badge(_ text: String, color: Color = .red) -> some View {
                    modifier(BadgeModifier(text: text, color: color))
                }
            }

            // Usage
            Image(systemName: "bell.fill")
                .badge("NEW")
            """
        case .shake:
            return """
            struct ShakeModifier: ViewModifier {
                var amount: Double = \(Int(shakeAmount))
                var isShaking: Bool

                func body(content: Content) -> some View {
                    content
                        .offset(x: isShaking ? amount : 0)
                        .animation(
                            isShaking
                                ? .default.repeatCount(5, autoreverses: true).speed(6)
                                : .default,
                            value: isShaking
                        )
                }
            }

            // Usage
            @State private var isShaking = false

            Text("Error!")
                .modifier(ShakeModifier(isShaking: isShaking))
            """
        }
    }
}

// MARK: - Custom View Modifiers

struct CardModifier: ViewModifier {
    var cornerRadius: Double = 16
    var shadowRadius: Double = 8

    func body(content: Content) -> some View {
        content
            .padding()
            .background(.background, in: RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, y: 4)
    }
}

struct GlowModifier: ViewModifier {
    var color: Color = .blue
    var radius: Double = 10

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius)
            .shadow(color: color.opacity(0.3), radius: radius * 2)
    }
}

struct BadgeModifier: ViewModifier {
    var text: String
    var color: Color = .red

    func body(content: Content) -> some View {
        content.overlay(alignment: .topTrailing) {
            Text(text)
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(color, in: Capsule())
                .offset(x: 8, y: -8)
        }
    }
}

struct ShakeModifier: ViewModifier {
    var amount: Double = 5
    var isShaking: Bool

    func body(content: Content) -> some View {
        content
            .offset(x: isShaking ? amount : 0)
            .animation(
                isShaking
                    ? .default.repeatCount(5, autoreverses: true).speed(6)
                    : .default,
                value: isShaking
            )
    }
}

#Preview {
    NavigationStack {
        ViewModifierPlayground()
    }
}
