import SwiftUI

struct ScrollViewPlayground: View {
    @State private var axis = AxisOption.vertical
    @State private var showsIndicators = true
    @State private var itemCount = 10
    @State private var spacing: Double = 10

    enum AxisOption: String, CaseIterable {
        case vertical = "Vertical"
        case horizontal = "Horizontal"
    }

    var body: some View {
        ComponentPage(
            title: "ScrollView",
            description: "A scrollable view that allows content to scroll in one or both axes.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        Group {
            switch axis {
            case .vertical:
                verticalScrollView
            case .horizontal:
                horizontalScrollView
            }
        }
        .frame(height: 200)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .cyan, .indigo, .mint, .teal]

    @ViewBuilder
    private var verticalScrollView: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            VStack(spacing: spacing) {
                ForEach(0..<itemCount, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colors[index % colors.count])
                        .frame(height: 50)
                        .overlay {
                            Text("Item \(index + 1)")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private var horizontalScrollView: some View {
        ScrollView(.horizontal, showsIndicators: showsIndicators) {
            HStack(spacing: spacing) {
                ForEach(0..<itemCount, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colors[index % colors.count])
                        .frame(width: 80, height: 80)
                        .overlay {
                            Text("\(index + 1)")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Axis",
                selection: $axis,
                options: AxisOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Show Indicators", isOn: $showsIndicators)

            SliderControl(
                label: "Items",
                value: Binding(get: { Double(itemCount) }, set: { itemCount = Int($0) }),
                range: 3...20,
                step: 1,
                format: "%.0f"
            )

            SliderControl(
                label: "Spacing",
                value: $spacing,
                range: 0...30,
                format: "%.0f"
            )
        }
    }

    private var generatedCode: String {
        let axisCode = axis == .vertical ? ".vertical" : ".horizontal"
        let stackType = axis == .vertical ? "VStack" : "HStack"

        return """
        // ScrollView with \(axis.rawValue.lowercased()) scrolling
        ScrollView(\(axisCode), showsIndicators: \(showsIndicators)) {
            \(stackType)(spacing: \(Int(spacing))) {
                ForEach(0..<\(itemCount), id: \\.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue)
                        .frame(\(axis == .vertical ? "height: 50" : "width: 80, height: 80"))
                }
            }
            .padding()
        }
        """
    }
}

#Preview {
    NavigationStack {
        ScrollViewPlayground()
    }
}
