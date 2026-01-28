import SwiftUI
import Charts

struct BarChartPlayground: View {
    @State private var chartStyle = ChartStyle.vertical
    @State private var showLegend = true
    @State private var useGradient = false
    @State private var cornerRadius: Double = 4

    enum ChartStyle: String, CaseIterable {
        case vertical = "Vertical"
        case horizontal = "Horizontal"
        case stacked = "Stacked"
        case grouped = "Grouped"
    }

    struct SalesData: Identifiable {
        let id = UUID()
        let month: String
        let sales: Double
        let category: String
    }

    let simpleData: [SalesData] = [
        SalesData(month: "Jan", sales: 5000, category: "Sales"),
        SalesData(month: "Feb", sales: 8000, category: "Sales"),
        SalesData(month: "Mar", sales: 7500, category: "Sales"),
        SalesData(month: "Apr", sales: 9200, category: "Sales"),
        SalesData(month: "May", sales: 6800, category: "Sales"),
        SalesData(month: "Jun", sales: 11000, category: "Sales"),
    ]

    let stackedData: [SalesData] = [
        SalesData(month: "Jan", sales: 3000, category: "Online"),
        SalesData(month: "Jan", sales: 2000, category: "Store"),
        SalesData(month: "Feb", sales: 5000, category: "Online"),
        SalesData(month: "Feb", sales: 3000, category: "Store"),
        SalesData(month: "Mar", sales: 4500, category: "Online"),
        SalesData(month: "Mar", sales: 3000, category: "Store"),
        SalesData(month: "Apr", sales: 6000, category: "Online"),
        SalesData(month: "Apr", sales: 3200, category: "Store"),
    ]

    var body: some View {
        ComponentPage(
            title: "Bar Chart",
            description: "Display data using bars with Swift Charts.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/charts/barmark")!,
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
        case .vertical:
            Chart(simpleData) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Sales", item.sales)
                )
                .foregroundStyle(useGradient ? AnyShapeStyle(gradient) : AnyShapeStyle(Color.blue))
                .cornerRadius(cornerRadius)
            }
        case .horizontal:
            Chart(simpleData) { item in
                BarMark(
                    x: .value("Sales", item.sales),
                    y: .value("Month", item.month)
                )
                .foregroundStyle(useGradient ? AnyShapeStyle(gradient) : AnyShapeStyle(Color.blue))
                .cornerRadius(cornerRadius)
            }
        case .stacked:
            Chart(stackedData) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Sales", item.sales)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .cornerRadius(cornerRadius)
            }
            .chartLegend(showLegend ? .visible : .hidden)
        case .grouped:
            Chart(stackedData) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Sales", item.sales)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .cornerRadius(cornerRadius)
                .position(by: .value("Category", item.category))
            }
            .chartLegend(showLegend ? .visible : .hidden)
        }
    }

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .bottom,
            endPoint: .top
        )
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

            SliderControl(
                label: "Corner Radius",
                value: $cornerRadius,
                range: 0...12,
                format: "%.0f"
            )

            if chartStyle == .vertical || chartStyle == .horizontal {
                ToggleControl(label: "Gradient Fill", isOn: $useGradient)
            }

            if chartStyle == .stacked || chartStyle == .grouped {
                ToggleControl(label: "Show Legend", isOn: $showLegend)
            }
        }
    }

    private var generatedCode: String {
        switch chartStyle {
        case .vertical:
            return """
            import Charts

            struct SalesData: Identifiable {
                let id = UUID()
                let month: String
                let sales: Double
            }

            let data: [SalesData] = [
                SalesData(month: "Jan", sales: 5000),
                SalesData(month: "Feb", sales: 8000),
                // ...
            ]

            Chart(data) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Sales", item.sales)
                )
                .cornerRadius(\(Int(cornerRadius)))
            }
            """
        case .horizontal:
            return """
            import Charts

            Chart(data) { item in
                BarMark(
                    x: .value("Sales", item.sales),
                    y: .value("Month", item.month)
                )
                .cornerRadius(\(Int(cornerRadius)))
            }
            """
        case .stacked:
            return """
            import Charts

            // Data with categories for stacking
            Chart(data) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Sales", item.sales)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .cornerRadius(\(Int(cornerRadius)))
            }
            .chartLegend(\(showLegend ? ".visible" : ".hidden"))
            """
        case .grouped:
            return """
            import Charts

            // Grouped bars using position modifier
            Chart(data) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Sales", item.sales)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .cornerRadius(\(Int(cornerRadius)))
                .position(by: .value("Category", item.category))
            }
            .chartLegend(\(showLegend ? ".visible" : ".hidden"))
            """
        }
    }
}

#Preview {
    NavigationStack {
        BarChartPlayground()
    }
}
