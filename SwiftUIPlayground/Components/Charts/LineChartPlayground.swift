import SwiftUI
import Charts

struct LineChartPlayground: View {
    @State private var showPoints = true
    @State private var smoothLine = false
    @State private var showMultipleSeries = false
    @State private var lineWidth: Double = 2

    struct DataPoint: Identifiable {
        let id = UUID()
        let month: String
        let value: Double
        let series: String
    }

    let singleSeriesData: [DataPoint] = [
        DataPoint(month: "Jan", value: 30, series: "A"),
        DataPoint(month: "Feb", value: 45, series: "A"),
        DataPoint(month: "Mar", value: 38, series: "A"),
        DataPoint(month: "Apr", value: 62, series: "A"),
        DataPoint(month: "May", value: 55, series: "A"),
        DataPoint(month: "Jun", value: 78, series: "A"),
    ]

    let multiSeriesData: [DataPoint] = [
        DataPoint(month: "Jan", value: 30, series: "Product A"),
        DataPoint(month: "Feb", value: 45, series: "Product A"),
        DataPoint(month: "Mar", value: 38, series: "Product A"),
        DataPoint(month: "Apr", value: 62, series: "Product A"),
        DataPoint(month: "May", value: 55, series: "Product A"),
        DataPoint(month: "Jun", value: 78, series: "Product A"),
        DataPoint(month: "Jan", value: 20, series: "Product B"),
        DataPoint(month: "Feb", value: 35, series: "Product B"),
        DataPoint(month: "Mar", value: 50, series: "Product B"),
        DataPoint(month: "Apr", value: 45, series: "Product B"),
        DataPoint(month: "May", value: 60, series: "Product B"),
        DataPoint(month: "Jun", value: 52, series: "Product B"),
    ]

    var currentData: [DataPoint] {
        showMultipleSeries ? multiSeriesData : singleSeriesData
    }

    var body: some View {
        ComponentPage(
            title: "Line Chart",
            description: "Display trends over time with connected line segments.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/charts/linemark")!,
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
            Chart(currentData) { item in
                if showMultipleSeries {
                    LineMark(
                        x: .value("Month", item.month),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(by: .value("Series", item.series))
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .interpolationMethod(smoothLine ? .catmullRom : .linear)

                    if showPoints {
                        PointMark(
                            x: .value("Month", item.month),
                            y: .value("Value", item.value)
                        )
                        .foregroundStyle(by: .value("Series", item.series))
                    }
                } else {
                    LineMark(
                        x: .value("Month", item.month),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .interpolationMethod(smoothLine ? .catmullRom : .linear)

                    if showPoints {
                        PointMark(
                            x: .value("Month", item.month),
                            y: .value("Value", item.value)
                        )
                        .foregroundStyle(.blue)
                    }
                }
            }
            .chartLegend(showMultipleSeries ? .visible : .hidden)
            .frame(height: 220)
            .padding()
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Multiple Series", isOn: $showMultipleSeries)
            ToggleControl(label: "Show Points", isOn: $showPoints)
            ToggleControl(label: "Smooth Line", isOn: $smoothLine)

            SliderControl(
                label: "Line Width",
                value: $lineWidth,
                range: 1...6,
                format: "%.0fpt"
            )
        }
    }

    private var generatedCode: String {
        if showMultipleSeries {
            return """
            import Charts

            struct DataPoint: Identifiable {
                let id = UUID()
                let month: String
                let value: Double
                let series: String
            }

            Chart(data) { item in
                LineMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(by: .value("Series", item.series))
                .lineStyle(StrokeStyle(lineWidth: \(Int(lineWidth))))
                .interpolationMethod(\(smoothLine ? ".catmullRom" : ".linear"))
            \(showPoints ? """

                PointMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(by: .value("Series", item.series))
            """ : "")
            }
            .chartLegend(.visible)
            """
        } else {
            return """
            import Charts

            Chart(data) { item in
                LineMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
                .lineStyle(StrokeStyle(lineWidth: \(Int(lineWidth))))
                .interpolationMethod(\(smoothLine ? ".catmullRom" : ".linear"))
            \(showPoints ? """

                PointMark(
                    x: .value("Month", item.month),
                    y: .value("Value", item.value)
                )
            """ : "")
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        LineChartPlayground()
    }
}
