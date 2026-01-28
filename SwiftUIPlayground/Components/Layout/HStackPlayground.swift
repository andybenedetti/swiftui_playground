import SwiftUI

struct HStackPlayground: View {
    @State private var alignment = VerticalAlignmentOption.center
    @State private var spacing: Double = 10
    @State private var itemCount = 3

    enum VerticalAlignmentOption: String, CaseIterable {
        case top = "Top"
        case center = "Center"
        case bottom = "Bottom"

        var alignment: VerticalAlignment {
            switch self {
            case .top: .top
            case .center: .center
            case .bottom: .bottom
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "HStack",
            description: "A view that arranges its subviews in a horizontal line.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/hstack")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        HStack(alignment: alignment.alignment, spacing: spacing) {
            ForEach(0..<itemCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(colors[index % colors.count])
                    .frame(width: 50, height: heights[index % heights.count])
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private let colors: [Color] = [.blue, .green, .orange, .purple, .pink]
    private let heights: [CGFloat] = [60, 40, 80, 50, 70]

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Alignment",
                selection: $alignment,
                options: VerticalAlignmentOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Spacing",
                value: $spacing,
                range: 0...40,
                format: "%.0f"
            )

            SliderControl(
                label: "Items",
                value: Binding(get: { Double(itemCount) }, set: { itemCount = Int($0) }),
                range: 1...5,
                step: 1,
                format: "%.0f"
            )
        }
    }

    private var generatedCode: String {
        var code = "HStack("

        var params: [String] = []
        if alignment != .center {
            params.append("alignment: .\(alignment.rawValue.lowercased())")
        }
        if spacing != 10 {
            params.append("spacing: \(Int(spacing))")
        }

        code += params.joined(separator: ", ")
        code += ") {\n"

        for i in 0..<itemCount {
            code += "    // Item \(i + 1)\n"
            code += "    Text(\"Item \(i + 1)\")\n"
        }

        code += "}"

        return code
    }
}

#Preview {
    NavigationStack {
        HStackPlayground()
    }
}
