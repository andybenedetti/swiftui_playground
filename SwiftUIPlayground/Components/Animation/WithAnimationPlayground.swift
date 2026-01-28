import SwiftUI

struct WithAnimationPlayground: View {
    @State private var scale: Double = 1.0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0
    @State private var selectedCurve = AnimationCurve.spring
    @State private var duration: Double = 0.5

    enum AnimationCurve: String, CaseIterable {
        case linear = "Linear"
        case easeInOut = "Ease In Out"
        case spring = "Spring"
        case bouncy = "Bouncy"
    }

    var body: some View {
        ComponentPage(
            title: "withAnimation",
            description: "Wraps state changes in an animation block.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/withanimation(_:_:)")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [.orange, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)

            HStack(spacing: 12) {
                Button("Scale") {
                    withAnimation(animation) {
                        scale = scale == 1.0 ? 1.5 : 1.0
                    }
                }
                .buttonStyle(.bordered)

                Button("Rotate") {
                    withAnimation(animation) {
                        rotation += 90
                    }
                }
                .buttonStyle(.bordered)

                Button("Fade") {
                    withAnimation(animation) {
                        opacity = opacity == 1.0 ? 0.3 : 1.0
                    }
                }
                .buttonStyle(.bordered)
            }

            Button("Reset All") {
                withAnimation(animation) {
                    scale = 1.0
                    rotation = 0
                    opacity = 1.0
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var animation: Animation {
        switch selectedCurve {
        case .linear:
            return .linear(duration: duration)
        case .easeInOut:
            return .easeInOut(duration: duration)
        case .spring:
            return .spring(duration: duration)
        case .bouncy:
            return .bouncy(duration: duration)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Animation",
                selection: $selectedCurve,
                options: AnimationCurve.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Duration",
                value: $duration,
                range: 0.1...2.0,
                format: "%.1fs"
            )
        }
    }

    private var generatedCode: String {
        let animCode: String
        switch selectedCurve {
        case .linear:
            animCode = ".linear(duration: \(String(format: "%.1f", duration)))"
        case .easeInOut:
            animCode = ".easeInOut(duration: \(String(format: "%.1f", duration)))"
        case .spring:
            animCode = ".spring(duration: \(String(format: "%.1f", duration)))"
        case .bouncy:
            animCode = ".bouncy(duration: \(String(format: "%.1f", duration)))"
        }

        return """
        // withAnimation wraps state changes
        @State private var scale = 1.0
        @State private var rotation = 0.0

        RoundedRectangle(cornerRadius: 16)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))

        Button("Animate") {
            withAnimation(\(animCode)) {
                scale = scale == 1.0 ? 1.5 : 1.0
                rotation += 90
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        WithAnimationPlayground()
    }
}
