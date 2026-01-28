import SwiftUI

struct DragGesturePlayground: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false
    @State private var minimumDistance: Double = 0
    @State private var showCoordinates = true
    @State private var snapBack = true

    var body: some View {
        ComponentPage(
            title: "DragGesture",
            description: "Recognizes a dragging motion on a view.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .frame(width: 200, height: 200)

                RoundedRectangle(cornerRadius: 12)
                    .fill(isDragging ? Color.green : Color.blue)
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .offset(offset)
                    .gesture(
                        DragGesture(minimumDistance: minimumDistance)
                            .onChanged { value in
                                isDragging = true
                                offset = value.translation
                            }
                            .onEnded { _ in
                                isDragging = false
                                if snapBack {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        offset = .zero
                                    }
                                }
                            }
                    )
            }
            .frame(width: 200, height: 200)

            if showCoordinates {
                HStack(spacing: 20) {
                    Text("X: \(Int(offset.width))")
                    Text("Y: \(Int(offset.height))")
                }
                .font(.caption)
                .monospacedDigit()
                .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Min Distance",
                value: $minimumDistance,
                range: 0...50,
                format: "%.0f"
            )

            ToggleControl(label: "Snap Back", isOn: $snapBack)

            ToggleControl(label: "Show Coordinates", isOn: $showCoordinates)

            Button("Reset Position") {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    offset = .zero
                }
            }
            .buttonStyle(.bordered)

            Text("Drag the square around. Min distance prevents accidental drags.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        if minimumDistance > 0 {
            return """
            // Drag gesture with minimum distance
            @State private var offset: CGSize = .zero

            RoundedRectangle(cornerRadius: 12)
                .fill(.blue)
                .offset(offset)
                .gesture(
                    DragGesture(minimumDistance: \(Int(minimumDistance)))
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { _ in
                            offset = .zero
                        }
                )
            """
        } else {
            return """
            // Drag gesture
            @State private var offset: CGSize = .zero

            RoundedRectangle(cornerRadius: 12)
                .fill(.blue)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { _ in
                            offset = .zero
                        }
                )
            """
        }
    }
}

#Preview {
    NavigationStack {
        DragGesturePlayground()
    }
}
