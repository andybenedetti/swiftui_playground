import SwiftUI

struct LongPressGesturePlayground: View {
    @State private var isPressed = false
    @State private var isPressing = false
    @State private var minimumDuration: Double = 0.5
    @State private var pressCount = 0

    var body: some View {
        ComponentPage(
            title: "LongPressGesture",
            description: "Recognizes a long-press gesture on a view.",
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
                .fill(isPressing ? Color.orange : (isPressed ? Color.green : Color.blue))
                .frame(width: 150, height: 150)
                .overlay {
                    VStack {
                        Image(systemName: isPressing ? "hand.point.down.fill" : (isPressed ? "checkmark.circle.fill" : "hand.tap.fill"))
                            .font(.largeTitle)
                        Text(isPressing ? "Hold..." : (isPressed ? "Success!" : "Long press"))
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                }
                .scaleEffect(isPressing ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressing)
                .gesture(
                    LongPressGesture(minimumDuration: minimumDuration)
                        .onChanged { _ in
                            isPressing = true
                        }
                        .onEnded { _ in
                            isPressing = false
                            isPressed = true
                            pressCount += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isPressed = false
                            }
                        }
                )

            Text("Long press count: \(pressCount)")
                .font(.title2)
                .monospacedDigit()
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Duration",
                value: $minimumDuration,
                range: 0.2...2.0,
                format: "%.1fs"
            )

            Button("Reset Count") {
                pressCount = 0
            }
            .buttonStyle(.bordered)

            Text("Hold for \(String(format: "%.1f", minimumDuration)) seconds to trigger.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        """
        // Long press gesture
        @State private var isPressed = false

        RoundedRectangle(cornerRadius: 16)
            .fill(isPressed ? .green : .blue)
            .gesture(
                LongPressGesture(minimumDuration: \(String(format: "%.1f", minimumDuration)))
                    .onEnded { _ in
                        isPressed = true
                    }
            )
        """
    }
}

#Preview {
    NavigationStack {
        LongPressGesturePlayground()
    }
}
