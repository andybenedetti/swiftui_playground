import SwiftUI
import Charts

struct PieChartPlayground: View {
    @State private var chartStyle = ChartStyle.pie
    @State private var showLabels = true
    @State private var angularInset: Double = 1
    @State private var innerRadius: Double = 0

    enum ChartStyle: String, CaseIterable {
        case pie = "Pie"
        case donut = "Donut"
        case exploded = "Exploded"
    }

    struct SalesData: Identifiable {
        let id = UUID()
        let category: String
        let value: Double
        let color: Color
    }

    let data: [SalesData] = [
        SalesData(category: "Electronics", value: 35, color: .blue),
        SalesData(category: "Clothing", value: 25, color: .green),
        SalesData(category: "Food", value: 20, color: .orange),
        SalesData(category: "Books", value: 12, color: .purple),
        SalesData(category: "Other", value: 8, color: .gray),
    ]

    var body: some View {
        ComponentPage(
            title: "Pie Chart",
            description: "Show proportions with SectorMark (iOS 17+).",
            documentationURL: URL(string: "https://developer.apple.com/documentation/charts/sectormark")!,
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
                .frame(height: 250)
                .padding()
        }
    }

    @ViewBuilder
    private var chartView: some View {
        Chart(data) { item in
            SectorMark(
                angle: .value("Value", item.value),
                innerRadius: .ratio(currentInnerRadius),
                angularInset: angularInset
            )
            .cornerRadius(4)
            .foregroundStyle(by: .value("Category", item.category))
        }
        .chartLegend(showLabels ? .visible : .hidden)
    }

    private var currentInnerRadius: Double {
        switch chartStyle {
        case .pie:
            return 0
        case .donut:
            return 0.5
        case .exploded:
            return innerRadius
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

            ToggleControl(label: "Show Legend", isOn: $showLabels)

            SliderControl(
                label: "Gap",
                value: $angularInset,
                range: 0...5,
                format: "%.0f"
            )

            if chartStyle == .exploded {
                SliderControl(
                    label: "Inner Radius",
                    value: $innerRadius,
                    range: 0...0.7,
                    format: "%.1f"
                )
            }
        }
    }

    private var generatedCode: String {
        let innerRadiusCode = chartStyle == .pie ? "0" :
                              chartStyle == .donut ? "0.5" :
                              String(format: "%.1f", innerRadius)

        return """
        import Charts

        struct SalesData: Identifiable {
            let id = UUID()
            let category: String
            let value: Double
        }

        let data: [SalesData] = [
            SalesData(category: "Electronics", value: 35),
            SalesData(category: "Clothing", value: 25),
            SalesData(category: "Food", value: 20),
            SalesData(category: "Books", value: 12),
            SalesData(category: "Other", value: 8),
        ]

        Chart(data) { item in
            SectorMark(
                angle: .value("Value", item.value),
                innerRadius: .ratio(\(innerRadiusCode)),
                angularInset: \(Int(angularInset))
            )
            .cornerRadius(4)
            .foregroundStyle(by: .value("Category", item.category))
        }
        .chartLegend(\(showLabels ? ".visible" : ".hidden"))
        """
    }
}

#Preview {
    NavigationStack {
        PieChartPlayground()
    }
}
