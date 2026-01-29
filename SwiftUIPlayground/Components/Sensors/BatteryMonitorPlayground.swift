import SwiftUI

struct BatteryMonitorPlayground: View {
    // MARK: - State
    @State private var batteryLevel: Float = UIDevice.current.batteryLevel
    @State private var batteryState: UIDevice.BatteryState = UIDevice.current.batteryState
    @State private var isMonitoring = false
    @State private var displayStyle = DisplayStyle.gauge

    enum DisplayStyle: String, CaseIterable {
        case gauge = "Gauge"
        case progress = "Progress"
        case text = "Text Only"
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "Battery Monitor",
            description: "Monitor battery level and charging state using UIDevice. Demonstrates UIKit-to-SwiftUI bridging via NotificationCenter for real-time updates.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/uikit/uidevice/1620042-batterylevel")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
        .onDisappear {
            if isMonitoring {
                UIDevice.current.isBatteryMonitoringEnabled = false
            }
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 20) {
            switch displayStyle {
            case .gauge:
                gaugeView
            case .progress:
                progressView
            case .text:
                textView
            }

            // State indicator
            HStack(spacing: 8) {
                Image(systemName: stateIcon)
                    .foregroundStyle(stateColor)
                Text(stateLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if !isMonitoring {
                Text("Enable monitoring to get real-time updates")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
    }

    private var gaugeView: some View {
        Gauge(value: Double(effectiveLevel), in: 0...1) {
            Text("Battery")
        } currentValueLabel: {
            Text(levelText)
        } minimumValueLabel: {
            Text("0%")
                .font(.caption2)
        } maximumValueLabel: {
            Text("100%")
                .font(.caption2)
        }
        .gaugeStyle(.accessoryCircular)
        .scaleEffect(2.0)
        .frame(height: 120)
        .tint(levelGradient)
    }

    private var progressView: some View {
        VStack(spacing: 8) {
            ProgressView(value: Double(effectiveLevel), total: 1.0)
                .tint(levelColor)
                .scaleEffect(y: 3)

            Text(levelText)
                .font(.title2.bold())
        }
        .padding(.horizontal)
    }

    private var textView: some View {
        VStack(spacing: 4) {
            Text(levelText)
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(levelColor)

            Text("Battery Level")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var effectiveLevel: Float {
        batteryLevel < 0 ? 0 : batteryLevel
    }

    private var levelText: String {
        if batteryLevel < 0 {
            return "Unknown"
        }
        return "\(Int(batteryLevel * 100))%"
    }

    private var levelColor: Color {
        if batteryLevel < 0 { return .secondary }
        if batteryLevel <= 0.2 { return .red }
        if batteryLevel <= 0.5 { return .orange }
        return .green
    }

    private var levelGradient: Gradient {
        Gradient(colors: [.red, .orange, .green])
    }

    private var stateIcon: String {
        switch batteryState {
        case .unknown: "questionmark.circle"
        case .unplugged: "battery.100"
        case .charging: "battery.100.bolt"
        case .full: "battery.100.circle"
        @unknown default: "questionmark.circle"
        }
    }

    private var stateLabel: String {
        switch batteryState {
        case .unknown: "Unknown"
        case .unplugged: "On Battery"
        case .charging: "Charging"
        case .full: "Fully Charged"
        @unknown default: "Unknown"
        }
    }

    private var stateColor: Color {
        switch batteryState {
        case .charging, .full: .green
        case .unplugged: .orange
        default: .secondary
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Battery Monitoring", isOn: $isMonitoring)

            PickerControl(
                label: "Display Style",
                selection: $displayStyle,
                options: DisplayStyle.allCases,
                optionLabel: { $0.rawValue }
            )
        }
        .onChange(of: isMonitoring) {
            UIDevice.current.isBatteryMonitoringEnabled = isMonitoring
            if isMonitoring {
                refreshBattery()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)) { _ in
            refreshBattery()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification)) { _ in
            refreshBattery()
        }
    }

    private func refreshBattery() {
        batteryLevel = UIDevice.current.batteryLevel
        batteryState = UIDevice.current.batteryState
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        """
        // Enable monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true

        // Read current values
        let level = UIDevice.current.batteryLevel  // 0.0...1.0, or -1 if unknown
        let state = UIDevice.current.batteryState   // .unknown, .unplugged, .charging, .full

        // Listen for changes via NotificationCenter
        NotificationCenter.default.publisher(
            for: UIDevice.batteryLevelDidChangeNotification
        )
        .sink { _ in
            let newLevel = UIDevice.current.batteryLevel
        }

        NotificationCenter.default.publisher(
            for: UIDevice.batteryStateDidChangeNotification
        )
        .sink { _ in
            let newState = UIDevice.current.batteryState
        }
        """
    }
}

#Preview {
    NavigationStack {
        BatteryMonitorPlayground()
    }
}
