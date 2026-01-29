import SwiftUI

struct RotateGesturePlayground: View {
    // MARK: - State
    @State private var currentAngle: Angle = .zero
    @State private var lastAngle: Angle = .zero
    @State private var showAngle = true
    @State private var snapToAngles = false
    @State private var combinedWithMagnify = false
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "RotateGesture",
            description: "A gesture that recognizes a two-finger rotation motion.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/rotategesture")!,
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
                    .fill(.purple.opacity(0.1))
                    .frame(height: 280)

                VStack(spacing: 8) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.purple.opacity(0.5))

                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 120, height: 120)
                        .overlay {
                            Image(systemName: "arrow.up")
                                .font(.title)
                                .foregroundStyle(.white)
                        }
                        .rotationEffect(currentAngle)
                        .scaleEffect(combinedWithMagnify ? currentScale : 1.0)
                        .gesture(rotationGesture)
                }

                if showAngle {
                    VStack {
                        Spacer()
                        Text(String(format: "%.0f°", currentAngle.degrees))
                            .font(.caption.monospaced().bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                    .padding(.bottom, 12)
                }
            }
            .frame(height: 280)

            Button("Reset") {
                withAnimation(.spring(duration: 0.3)) {
                    currentAngle = .zero
                    lastAngle = .zero
                    currentScale = 1.0
                    lastScale = 1.0
                }
            }
            .buttonStyle(.bordered)

            Text("Use two fingers to rotate")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var rotationGesture: some Gesture {
        if combinedWithMagnify {
            return SimultaneousGesture(
                RotateGesture()
                    .onChanged { value in
                        let snapped = snapToAngles
                            ? Angle.degrees(round(value.rotation.degrees / 45) * 45)
                            : value.rotation
                        currentAngle = lastAngle + snapped
                    }
                    .onEnded { _ in
                        lastAngle = currentAngle
                    },
                MagnifyGesture()
                    .onChanged { value in
                        currentScale = lastScale * value.magnification
                    }
                    .onEnded { _ in
                        lastScale = currentScale
                    }
            )
        } else {
            return SimultaneousGesture(
                RotateGesture()
                    .onChanged { value in
                        let snapped = snapToAngles
                            ? Angle.degrees(round(value.rotation.degrees / 45) * 45)
                            : value.rotation
                        currentAngle = lastAngle + snapped
                    }
                    .onEnded { _ in
                        lastAngle = currentAngle
                    },
                MagnifyGesture()
                    .onChanged { _ in }
                    .onEnded { _ in }
            )
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Angle",
                value: Binding(
                    get: { currentAngle.degrees },
                    set: {
                        currentAngle = .degrees($0)
                        lastAngle = currentAngle
                    }
                ),
                range: -180...180,
                format: "%.0f°"
            )

            ToggleControl(label: "Show Angle", isOn: $showAngle)
            ToggleControl(label: "Snap to 45°", isOn: $snapToAngles)
            ToggleControl(label: "Combine with Magnify", isOn: $combinedWithMagnify)

            Text("RotateGesture uses two-finger rotation. Combine with MagnifyGesture using SimultaneousGesture for rotate + zoom.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        if combinedWithMagnify {
            return """
            @State private var angle: Angle = .zero
            @State private var scale: CGFloat = 1.0

            Rectangle()
                .frame(width: 120, height: 120)
                .rotationEffect(angle)
                .scaleEffect(scale)
                .gesture(
                    SimultaneousGesture(
                        RotateGesture()
                            .onChanged { value in
                                angle = value.rotation
                            },
                        MagnifyGesture()
                            .onChanged { value in
                                scale = value.magnification
                            }
                    )
                )
            """
        } else {
            return """
            @State private var currentAngle: Angle = .zero
            @State private var lastAngle: Angle = .zero

            Rectangle()
                .frame(width: 120, height: 120)
                .rotationEffect(currentAngle)
                .gesture(
                    RotateGesture()
                        .onChanged { value in
                            currentAngle = lastAngle + value.rotation
                        }
                        .onEnded { _ in
                            lastAngle = currentAngle
                        }
                )
            """
        }
    }
}

#Preview {
    NavigationStack {
        RotateGesturePlayground()
    }
}
