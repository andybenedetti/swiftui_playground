import SwiftUI
import Charts

struct AreaChartPlayground: View {
    @State private var chartStyle = ChartStyle.simple
    @State private var showLine = true
    @State private var opacity: Double = 0.3

    enum ChartStyle: String, CaseIterable {
        case simple = "Simple"
        case gradient = "Gradient"
        case stacked = "Stacked"
    }

    struct DataPoint: Identifiable {
        let id = UUID()
        let month: String
        let value: Double
        let category: String
    }

    let simpleData: [DataPoint] = [
        DataPoint(month: "Jan", value: 30, category: "Revenue"),
        DataPoint(month: "Feb", value: 45, category: "Revenue"),
        DataPoint(month: "Mar", value: 38, category: "Revenue"),
        DataPoint(month: "Apr", value: 62, category: "Revenue"),
        DataPoint(month: "May", value: 55, category: "Revenue"),
        DataPoint(month: "Jun", value: 78, category: "Revenue"),
    ]

    let stackedData: [DataPoint] = [
        DataPoint(month: "Jan", value: 30, category: "Mobile"),
        DataPoint(month: "Feb", value: 45, category: "Mobile"),
        DataPoint(month: "Mar", value: 50, category: "Mobile"),
        DataPoint(month: "Apr", value: 55, category: "Mobile"),
        DataPoint(month: "May", value: 60, category: "Mobile"),
        DataPoint(month: "Jun", value: 70, category: "Mobile"),
        DataPoint(month: "Jan", value: 20, category: "Desktop"),
        DataPoint(month: "Feb", value: 25, category: "Desktop"),
        DataPoint(month: "Mar", value: 30, category: "Desktop"),
        DataPoint(month: "Apr", value: 28, category: "Desktop"),
        DataPoint(month: "May", value: 35, category: "Desktop"),
        DataPoint(month: "Jun", value: 40, category: "Desktop"),
    ]

    var body: some View {
        ComponentPage(
            title: "Area Chart",
            description: "Visualize quantities over time with filled areas.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack {
            chartView
                .frame(height: 220)
                .padding()
        }
    }

    @ViewBuilder
    private var chartView: some View {
        switch chartStyle {
        case .simple:
            Chart(simpleData) { item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(.blue.opacity(opacity))
                .interpolationMethod(.catmullRom)

                if showLine {
                    LineMark(
                        x: .value("Month", item.month),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                }
            }
        case .gradient:
            Chart(simpleData) { item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue.opacity(opacity), .blue.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                if showLine {
                    LineMark(
                        x: .value("Month", item.month),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .interpolationMethod(.catmullRom)
                }
            }
        case .stacked:
            Chart(stackedData) { item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .interpolationMethod(.catmullRom)
            }
            .chartLegend(.visible)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $chartStyle,
                options: ChartStyle.allCases,
                optionLabel: { $0.rawValue }
            )

            if chartStyle != .stacked {
                ToggleControl(label: "Show Line", isOn: $showLine)

                SliderControl(
                    label: "Opacity",
                    value: $opacity,
                    range: 0.1...0.8,
                    format: "%.1f"
                )
            }
        }
    }

    private var generatedCode: String {
        switch chartStyle {
        case .simple:
            return """
            import Charts

            Chart(data) { item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(.blue.opacity(\(String(format: "%.1f", opacity))))
                .interpolationMethod(.catmullRom)
            \(showLine ? """

                LineMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
            """ : "")
            }
            """
        case .gradient:
            return """
            import Charts

            Chart(data) { item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue.opacity(\(String(format: "%.1f", opacity))), .blue.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            \(showLine ? """

                LineMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
            """ : "")
            }
            """
        case .stacked:
            return """
            import Charts

            // Stacked area chart with categories
            Chart(data) { item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .interpolationMethod(.catmullRom)
            }
            .chartLegend(.visible)
            """
        }
    }
}

#Preview {
    NavigationStack {
        AreaChartPlayground()
    }
}
