import SwiftUI

struct GridPlayground: View {
    @State private var columns = 3
    @State private var spacing: Double = 10
    @State private var itemCount = 9
    @State private var gridStyle = GridStyleOption.fixed

    enum GridStyleOption: String, CaseIterable {
        case fixed = "Fixed"
        case flexible = "Flexible"
        case adaptive = "Adaptive"
    }

    var body: some View {
        ComponentPage(
            title: "Grid",
            description: "A container that arranges views in a grid using LazyVGrid.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: spacing) {
                ForEach(0..<itemCount, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colors[index % colors.count])
                        .frame(height: 60)
                        .overlay {
                            Text("\(index + 1)")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .cyan, .indigo, .mint]

    private var gridColumns: [GridItem] {
        switch gridStyle {
        case .fixed:
            Array(repeating: GridItem(.fixed(80), spacing: spacing), count: columns)
        case .flexible:
            Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
        case .adaptive:
            [GridItem(.adaptive(minimum: 80), spacing: spacing)]
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Grid Style",
                selection: $gridStyle,
                options: GridStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            if gridStyle != .adaptive {
                SliderControl(
                    label: "Columns",
                    value: Binding(get: { Double(columns) }, set: { columns = Int($0) }),
                    range: 1...5,
                    step: 1,
                    format: "%.0f"
                )
            }

            SliderControl(
                label: "Spacing",
                value: $spacing,
                range: 0...30,
                format: "%.0f"
            )

            SliderControl(
                label: "Items",
                value: Binding(get: { Double(itemCount) }, set: { itemCount = Int($0) }),
                range: 1...12,
                step: 1,
                format: "%.0f"
            )
        }
    }

    private var generatedCode: String {
        var code = "// LazyVGrid layout\n"

        switch gridStyle {
        case .fixed:
            code += "let columns = Array(repeating: GridItem(.fixed(80), spacing: \(Int(spacing))), count: \(columns))\n\n"
        case .flexible:
            code += "let columns = Array(repeating: GridItem(.flexible(), spacing: \(Int(spacing))), count: \(columns))\n\n"
        case .adaptive:
            code += "let columns = [GridItem(.adaptive(minimum: 80), spacing: \(Int(spacing)))]\n\n"
        }

        code += """
        LazyVGrid(columns: columns, spacing: \(Int(spacing))) {
            ForEach(0..<\(itemCount), id: \\.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(height: 60)
            }
        }
        """

        return code
    }
}

#Preview {
    NavigationStack {
        GridPlayground()
    }
}
