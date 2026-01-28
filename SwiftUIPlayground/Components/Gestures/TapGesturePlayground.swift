import SwiftUI

struct TapGesturePlayground: View {
    @State private var tapCount = 0
    @State private var requiredTaps = 1
    @State private var showAnimation = true
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ComponentPage(
            title: "TapGesture",
            description: "Recognizes one or more taps on a view.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 150, height: 150)
                .overlay {
                    VStack {
                        Image(systemName: "hand.tap.fill")
                            .font(.largeTitle)
                        Text("Tap me!")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                }
                .scaleEffect(scale)
                .onTapGesture(count: requiredTaps) {
                    tapCount += 1
                    if showAnimation {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                            scale = 1.2
                        }
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.1)) {
                            scale = 1.0
                        }
                    }
                }

            Text("Tap count: \(tapCount)")
                .font(.title2)
                .monospacedDigit()
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Required Taps",
                value: Binding(
                    get: { Double(requiredTaps) },
                    set: { requiredTaps = Int($0) }
                ),
                range: 1...3,
                format: "%.0f"
            )

            ToggleControl(label: "Show Animation", isOn: $showAnimation)

            Button("Reset Count") {
                tapCount = 0
            }
            .buttonStyle(.bordered)

            Text("Tap the rectangle \(requiredTaps == 1 ? "once" : "\(requiredTaps) times") to trigger.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        if requiredTaps == 1 {
            return """
            // Single tap gesture
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .onTapGesture {
                    // Handle tap
                }
            """
        } else {
            return """
            // Multi-tap gesture
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .onTapGesture(count: \(requiredTaps)) {
                    // Handle \(requiredTaps) taps
                }
            """
        }
    }
}

#Preview {
    NavigationStack {
        TapGesturePlayground()
    }
}
