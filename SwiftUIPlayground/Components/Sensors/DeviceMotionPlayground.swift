import SwiftUI
import CoreMotion

struct DeviceMotionPlayground: View {
    // MARK: - State
    @State private var motionManager = CMMotionManager()
    @State private var pitch: Double = 0
    @State private var roll: Double = 0
    @State private var yaw: Double = 0
    @State private var updateInterval: Double = 0.05
    @State private var dataSource = MotionSource.deviceMotion
    @State private var showRawValues = false
    @State private var isActive = false

    enum MotionSource: String, CaseIterable {
        case deviceMotion = "Device Motion"
        case accelerometer = "Accelerometer"
        case gyroscope = "Gyroscope"
    }

    private var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "Device Motion",
            description: "Read accelerometer and gyroscope data using CoreMotion. Visualizes device orientation as a spirit level ball.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/coremotion/cmmotionmanager")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
        .onDisappear {
            stopMotion()
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        if isSimulator {
            ContentUnavailableView {
                Label("Device Required", systemImage: "iphone.gen3")
            } description: {
                Text("CoreMotion sensors are not available in the simulator. Run on a physical device to see the spirit level visualization.")
            }
        } else {
            ZStack {
                // Spirit level background
                Circle()
                    .stroke(.secondary.opacity(0.3), lineWidth: 2)
                    .frame(width: 200, height: 200)

                // Crosshair
                Path { path in
                    path.move(to: CGPoint(x: 100, y: 0))
                    path.addLine(to: CGPoint(x: 100, y: 200))
                    path.move(to: CGPoint(x: 0, y: 100))
                    path.addLine(to: CGPoint(x: 200, y: 100))
                }
                .stroke(.secondary.opacity(0.2), lineWidth: 1)
                .frame(width: 200, height: 200)

                // Center target
                Circle()
                    .stroke(.secondary.opacity(0.3), lineWidth: 1)
                    .frame(width: 40, height: 40)

                // Ball indicator
                Circle()
                    .fill(ballColor)
                    .shadow(color: ballColor.opacity(0.5), radius: 4)
                    .frame(width: 30, height: 30)
                    .offset(
                        x: CGFloat(roll) * 80,
                        y: CGFloat(pitch) * 80
                    )
                    .animation(.interactiveSpring(duration: 0.15), value: roll)
                    .animation(.interactiveSpring(duration: 0.15), value: pitch)

                if showRawValues {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pitch: \(pitch, format: .number.precision(.fractionLength(3)))")
                        Text("Roll: \(roll, format: .number.precision(.fractionLength(3)))")
                        Text("Yaw: \(yaw, format: .number.precision(.fractionLength(3)))")
                    }
                    .font(.caption.monospaced())
                    .padding(6)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            .frame(width: 200, height: 200)
        }
    }

    private var ballColor: Color {
        let distance = sqrt(pitch * pitch + roll * roll)
        if distance < 0.05 { return .green }
        if distance < 0.3 { return .yellow }
        return .red
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            if !isSimulator {
                PickerControl(
                    label: "Data Source",
                    selection: $dataSource,
                    options: MotionSource.allCases,
                    optionLabel: { $0.rawValue }
                )

                SliderControl(label: "Interval", value: $updateInterval, range: 0.01...0.2, format: "%.2fs")

                ToggleControl(label: "Show Raw Values", isOn: $showRawValues)

                if isActive {
                    Button("Stop", role: .destructive) {
                        stopMotion()
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button("Start") {
                        startMotion()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Text("Motion controls unavailable in simulator")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: updateInterval) {
            if isActive {
                stopMotion()
                startMotion()
            }
        }
        .onChange(of: dataSource) {
            if isActive {
                stopMotion()
                startMotion()
            }
        }
    }

    // MARK: - Motion Logic
    private func startMotion() {
        isActive = true
        switch dataSource {
        case .deviceMotion:
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.startDeviceMotionUpdates(to: .main) { data, _ in
                guard let data else { return }
                pitch = data.attitude.pitch
                roll = data.attitude.roll
                yaw = data.attitude.yaw
            }
        case .accelerometer:
            motionManager.accelerometerUpdateInterval = updateInterval
            motionManager.startAccelerometerUpdates(to: .main) { data, _ in
                guard let data else { return }
                pitch = data.acceleration.y
                roll = data.acceleration.x
                yaw = data.acceleration.z
            }
        case .gyroscope:
            motionManager.gyroUpdateInterval = updateInterval
            motionManager.startGyroUpdates(to: .main) { data, _ in
                guard let data else { return }
                pitch = data.rotationRate.x / 5
                roll = data.rotationRate.y / 5
                yaw = data.rotationRate.z / 5
            }
        }
    }

    private func stopMotion() {
        isActive = false
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        switch dataSource {
        case .deviceMotion:
            return """
            import CoreMotion

            let manager = CMMotionManager()
            manager.deviceMotionUpdateInterval = \(String(format: "%.2f", updateInterval))
            manager.startDeviceMotionUpdates(to: .main) { data, error in
                guard let data else { return }
                let pitch = data.attitude.pitch
                let roll = data.attitude.roll
                let yaw = data.attitude.yaw
            }
            """
        case .accelerometer:
            return """
            import CoreMotion

            let manager = CMMotionManager()
            manager.accelerometerUpdateInterval = \(String(format: "%.2f", updateInterval))
            manager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data else { return }
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z
            }
            """
        case .gyroscope:
            return """
            import CoreMotion

            let manager = CMMotionManager()
            manager.gyroUpdateInterval = \(String(format: "%.2f", updateInterval))
            manager.startGyroUpdates(to: .main) { data, error in
                guard let data else { return }
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        DeviceMotionPlayground()
    }
}
