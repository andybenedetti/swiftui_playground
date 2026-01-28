import SwiftUI

struct AnimationCurvesPlayground: View {
    @State private var isAnimating = false
    @State private var duration: Double = 1.0
    @State private var selectedCurve = AnimationCurve.easeInOut

    enum AnimationCurve: String, CaseIterable {
        case linear = "Linear"
        case easeIn = "Ease In"
        case easeOut = "Ease Out"
        case easeInOut = "Ease In Out"
        case spring = "Spring"
        case bouncy = "Bouncy"
        case snappy = "Snappy"
    }

    var body: some View {
        ComponentPage(
            title: "Animation Curves",
            description: "Different timing curves affect how animations feel.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/animation")!,
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
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 80, height: 80)
                    .offset(x: isAnimating ? 100 : -100)
                    .animation(animation, value: isAnimating)
            }
            .frame(width: 280, height: 100)
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

            Button(isAnimating ? "Reset" : "Animate") {
                isAnimating.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var animation: Animation {
        switch selectedCurve {
        case .linear:
            return .linear(duration: duration)
        case .easeIn:
            return .easeIn(duration: duration)
        case .easeOut:
            return .easeOut(duration: duration)
        case .easeInOut:
            return .easeInOut(duration: duration)
        case .spring:
            return .spring(duration: duration)
        case .bouncy:
            return .bouncy(duration: duration)
        case .snappy:
            return .snappy(duration: duration)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Curve",
                selection: $selectedCurve,
                options: AnimationCurve.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Duration",
                value: $duration,
                range: 0.2...3.0,
                format: "%.1fs"
            )
        }
    }

    private var generatedCode: String {
        let curveCode: String
        switch selectedCurve {
        case .linear:
            curveCode = ".linear(duration: \(String(format: "%.1f", duration)))"
        case .easeIn:
            curveCode = ".easeIn(duration: \(String(format: "%.1f", duration)))"
        case .easeOut:
            curveCode = ".easeOut(duration: \(String(format: "%.1f", duration)))"
        case .easeInOut:
            curveCode = ".easeInOut(duration: \(String(format: "%.1f", duration)))"
        case .spring:
            curveCode = ".spring(duration: \(String(format: "%.1f", duration)))"
        case .bouncy:
            curveCode = ".bouncy(duration: \(String(format: "%.1f", duration)))"
        case .snappy:
            curveCode = ".snappy(duration: \(String(format: "%.1f", duration)))"
        }

        return """
        // Animation with \(selectedCurve.rawValue.lowercased()) curve
        @State private var isAnimating = false

        RoundedRectangle(cornerRadius: 12)
            .offset(x: isAnimating ? 100 : -100)
            .animation(\(curveCode), value: isAnimating)

        Button("Animate") {
            isAnimating.toggle()
        }
        """
    }
}

#Preview {
    NavigationStack {
        AnimationCurvesPlayground()
    }
}
