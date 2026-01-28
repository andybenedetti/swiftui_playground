import SwiftUI

struct TimelineViewPlayground: View {
    @State private var scheduleType = ScheduleType.periodic
    @State private var updateInterval: Double = 1.0
    @State private var showSeconds = true
    @State private var showMilliseconds = false
    @State private var isPaused = false

    enum ScheduleType: String, CaseIterable {
        case periodic = "Periodic"
        case everyMinute = "Every Minute"
        case animation = "Animation"
    }

    var body: some View {
        ComponentPage(
            title: "TimelineView",
            description: "A view that updates according to a schedule. iOS 15+",
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
            if isPaused {
                clockFace(for: Date())
                    .foregroundStyle(.secondary)

                Text("Paused")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                timelineContent
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var timelineContent: some View {
        switch scheduleType {
        case .periodic:
            TimelineView(.periodic(from: .now, by: updateInterval)) { context in
                clockFace(for: context.date)
            }
        case .everyMinute:
            TimelineView(.everyMinute) { context in
                clockFace(for: context.date)
            }
        case .animation:
            TimelineView(.animation(minimumInterval: 1/60)) { context in
                animatedContent(for: context.date)
            }
        }
    }

    @ViewBuilder
    private func clockFace(for date: Date) -> some View {
        VStack(spacing: 8) {
            if showMilliseconds {
                Text(date.formatted(.dateTime.hour().minute().second()) + ".\(milliseconds(from: date))")
                    .font(.system(size: 48, weight: .light, design: .monospaced))
            } else if showSeconds {
                Text(date.formatted(.dateTime.hour().minute().second()))
                    .font(.system(size: 48, weight: .light, design: .monospaced))
            } else {
                Text(date.formatted(.dateTime.hour().minute()))
                    .font(.system(size: 48, weight: .light, design: .monospaced))
            }

            Text(date.formatted(.dateTime.weekday(.wide).month().day()))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func animatedContent(for date: Date) -> some View {
        let seconds = Calendar.current.component(.second, from: date)
        let nanoseconds = Calendar.current.component(.nanosecond, from: date)
        let progress = Double(seconds) / 60.0 + Double(nanoseconds) / 60_000_000_000.0

        VStack(spacing: 16) {
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 100, height: 100)

            Text("\(Int(progress * 100))%")
                .font(.title2.monospacedDigit())
        }
    }

    private func milliseconds(from date: Date) -> String {
        let ms = Calendar.current.component(.nanosecond, from: date) / 1_000_000
        return String(format: "%03d", ms)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Schedule",
                selection: $scheduleType,
                options: ScheduleType.allCases,
                optionLabel: { $0.rawValue }
            )

            if scheduleType == .periodic {
                SliderControl(
                    label: "Interval (sec)",
                    value: $updateInterval,
                    range: 0.1...5.0,
                    format: "%.1f"
                )
            }

            if scheduleType != .animation {
                ToggleControl(label: "Show Seconds", isOn: $showSeconds)

                if scheduleType == .periodic && updateInterval < 1 {
                    ToggleControl(label: "Show Milliseconds", isOn: $showMilliseconds)
                }
            }

            ToggleControl(label: "Paused", isOn: $isPaused)
        }
    }

    private var generatedCode: String {
        switch scheduleType {
        case .periodic:
            return """
            // TimelineView updates on a schedule
            TimelineView(.periodic(from: .now, by: \(String(format: "%.1f", updateInterval)))) { context in
                // context.date contains the current time
                Text(context.date.formatted(.dateTime.hour().minute()\(showSeconds ? ".second()" : "")))
                    .font(.largeTitle.monospacedDigit())
            }
            """
        case .everyMinute:
            return """
            // Updates at the start of every minute
            TimelineView(.everyMinute) { context in
                Text(context.date.formatted(.dateTime.hour().minute()))
                    .font(.largeTitle.monospacedDigit())
            }
            """
        case .animation:
            return """
            // High-frequency updates for smooth animation
            TimelineView(.animation(minimumInterval: 1/60)) { context in
                let progress = secondsProgress(from: context.date)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, lineWidth: 8)
                    .rotationEffect(.degrees(-90))
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        TimelineViewPlayground()
    }
}
