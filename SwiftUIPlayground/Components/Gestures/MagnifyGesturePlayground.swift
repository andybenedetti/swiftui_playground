import SwiftUI

struct MagnifyGesturePlayground: View {
    // MARK: - State
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var minScale: Double = 0.5
    @State private var maxScale: Double = 4.0
    @State private var showOverlay = true

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "MagnifyGesture",
            description: "A gesture that recognizes a pinch-to-zoom magnification motion.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/magnifygesture")!,
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
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue.opacity(0.1))
                    .frame(height: 250)

                Image(systemName: "photo.artframe")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                    .scaleEffect(currentScale)
                    .gesture(
                        MagnifyGesture()
                            .onChanged { value in
                                let newScale = lastScale * value.magnification
                                currentScale = min(max(newScale, minScale), maxScale)
                            }
                            .onEnded { _ in
                                lastScale = currentScale
                            }
                    )

                if showOverlay {
                    VStack {
                        Spacer()
                        Text(String(format: "%.1fx", currentScale))
                            .font(.caption.monospaced().bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                    .padding(.bottom, 12)
                }
            }
            .frame(height: 250)

            Button("Reset Zoom") {
                withAnimation(.spring(duration: 0.3)) {
                    currentScale = 1.0
                    lastScale = 1.0
                }
            }
            .buttonStyle(.bordered)

            Text("Pinch with two fingers to zoom")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Current Scale",
                value: Binding(get: { Double(currentScale) }, set: {
                    currentScale = CGFloat($0)
                    lastScale = currentScale
                }),
                range: minScale...maxScale,
                format: "%.1fx"
            )

            SliderControl(label: "Min Scale", value: $minScale, range: 0.1...1.0, format: "%.1f")
            SliderControl(label: "Max Scale", value: $maxScale, range: 2.0...10.0, format: "%.1f")

            ToggleControl(label: "Show Scale Overlay", isOn: $showOverlay)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        """
        @State private var currentScale: CGFloat = 1.0
        @State private var lastScale: CGFloat = 1.0

        Image(systemName: "photo.artframe")
            .font(.system(size: 80))
            .scaleEffect(currentScale)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        let newScale = lastScale * value.magnification
                        currentScale = min(max(newScale, \(String(format: "%.1f", minScale))), \(String(format: "%.1f", maxScale)))
                    }
                    .onEnded { _ in
                        lastScale = currentScale
                    }
            )
        """
    }
}

#Preview {
    NavigationStack {
        MagnifyGesturePlayground()
    }
}
